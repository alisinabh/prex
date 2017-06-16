defmodule Mix.Tasks.Prex.Gen.FromBlueprint do
  @moduledoc """
  Create interface mix task
  """

  use Mix.Task

  @shortdoc "Create modules for API based on ApiBlueprint"

  @bljson_filename ".prex.api.json"

  def run([filename, api_name]) do
    {current_dir, _} = System.cmd "pwd", []
    current_dir = String.slice current_dir, 0, String.length(current_dir) -1

    full_name =
      if filename |> String.starts_with?("/") do
          filename
        else
          Path.join current_dir, filename
      end

    if full_name |> String.downcase |> String.ends_with?(".apib") do
      {data, _} = System.cmd("drafter", ["-t" ,"ast", "-f", "json", full_name])
      File.rm @bljson_filename
      File.write(@bljson_filename, data)
    else
      System.cmd("cp", ["#{full_name}", @bljson_filename])
    end

    file = Prex.AstFile.parse_file! @bljson_filename
    groups = Prex.AstFile.get_resource_groups file
    host = Prex.AstFile.get_host file

    :ok = process_groups groups, api_name, host

    File.rm @bljson_filename
  end

  def run(_) do
    IO.puts "mix prex.gen.from_blueprint [.apib or .json file] [api name]"
  end

  defp process_groups([gp | tail], api_name, base_url) do
     {:ok, filename, code} = Prex.generate_module(api_name ,gp, base_url)
     # File.open(filename, :write)

     :ok = prepare_directory(filename)

     File.touch filename
     File.write filename, code

     process_groups(tail, api_name, base_url)
  end

  defp process_groups([], _, _), do: :ok

  defp prepare_directory(full_name) when is_binary(full_name) do
    dirs = String.split(full_name, "/")
    dirs = Enum.take(dirs, Enum.count(dirs) - 1)

    prepare_directory(dirs, "")
  end

  defp prepare_directory([dir | tail], parent) do
    new_path = Path.join(parent, dir)
    if !File.exists?(new_path) do
      new_path |> File.mkdir!
    end
    prepare_directory(tail, new_path)
  end

  defp prepare_directory([], _) do
    :ok
  end

end
