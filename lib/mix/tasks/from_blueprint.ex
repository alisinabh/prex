defmodule Mix.Tasks.Prex.Gen.FromBlueprint do
  @moduledoc """
  Create interface mix task
  """

  use Mix.Task

  import Prex.NameHelpers

  @shortdoc "Create interface of API based on blueprint json"

  def run([]) do
    IO.puts "mix prex.gen.from_blueprint [blueprint or json blueprint file] [a name for this api]"
  end

  def run([filename, api_name]) do

    # if filename |> String.downcase |> String.ends_with?(".apib") do
    #   System.cmd("drafter -t ast -f json #{filename} > api.json", [])
    # else
    #   System.cmd("cp #{filename} ~/api.json", [])
    # end

    file = Prex.AstFile.parse_file! filename
    groups = Prex.AstFile.get_resource_groups(file)
    host = Prex.AstFile.get_host(file)

    process_groups(groups, api_name, host)
  end

  defp process_groups([gp | tail], api_name, base_url) do
     {:ok, filename, code} = Prex.AstFile.generate_module(api_name ,gp, base_url)
     # File.open(filename, :write)
     
     File.touch filename
     File.write filename, code
  end

  defp process_groups([], _, _), do: :ok
end
