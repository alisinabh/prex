defmodule Mix.Tasks.Prex.Gen.FromBlueprint do
  @moduledoc """
  Create interface mix task
  """

  use Mix.Task

  @shortdoc "Create interface of API based on blueprint json"

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
      File.rm "api.json"
      File.write("api.json", data)
    else
      System.cmd("cp", ["#{full_name}", "api.json"])
    end

    file = Prex.AstFile.parse_file! "api.json"
    groups = Prex.AstFile.get_resource_groups file
    host = Prex.AstFile.get_host file

    process_groups groups, api_name, host
  end

  def run(_) do
    IO.puts "mix prex.gen.from_blueprint [blueprint or json blueprint file] [a name for this api]"
  end

  defp process_groups([gp | tail], api_name, base_url) do
     {:ok, filename, code} = Prex.generate_module(api_name ,gp, base_url)
     # File.open(filename, :write)

     File.touch filename
     File.write filename, code

     process_groups(tail, api_name, base_url)
  end

  defp process_groups([], _, _), do: :ok
end
