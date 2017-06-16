defmodule Prex.AstFile do
  @moduledoc """
  Documentation for AstFile.
  """

  import Prex.NameHelpers

  @doc """
  Parses an ast json of an ap blueprint into a map.
  """
  @spec parse_file!(String.t) :: Poison.Parser.t | no_return
  def parse_file!(file_name) do
    file_name
    |> File.read!
    |> Poison.decode!
  end

  @doc """
  Returns the HOST of api. ``nil`` if nothing.

  ## Examples
      iex> Prex.parse_file("test.json") |> Prex.get_host
      "http://sample.pandurangpatil.com"
  """
  @spec get_host(Map.t) :: String.t | nil
  def get_host(%{"ast" => %{"metadata" => metadata}}), do: do_get_host(metadata)

  defp do_get_host([%{"name" => "HOST", "value" => host} | _tail]), do: host

  defp do_get_host([_hd | tail]), do: do_get_host(tail)

  defp do_get_host([]), do: nil

  @doc """
  Returns ast file ``resourceGroups`` as an Enum or ``nil`` if not exists.
  """
  @spec get_resource_groups(Map.t) :: Enum.t | nil
  def get_resource_groups(%{"ast" => %{"resourceGroups" => groups}}), do: groups

  def get_resource_groups(%{"ast" => _data}), do: nil

  @doc """
  Generate elixir modules for a group
  """
  @spec generate_module(String.t, Map.t, String.t) :: {:ok, String.t, String.t}
  def generate_module(api_name, group, base_url) do
    %{"name" => group_name, "description" => group_description, "resources" => resources} = group
    actions_code = do_generate_module(base_url, group_name, group_description, resources, [])

    {:ok,
     "#{normalize_var_name(api_name)}__#{normalize_var_name(group_name)}.ex", # TODO fix folders
     Prex.Templates.get_module(api_name, group_name, base_url, group_description, actions_code)}
  end

  defp do_generate_module(base_url, group_name, group_description, [resource | tail], acc) do
    %{"name" => name, "uriTemplate" => uri, "parameters" => global_params, "actions" => actions} = resource

    get_actions(uri, global_params, actions, "")
  end

  defp do_generate_module(_group_name, _group_description, [], acc), do: acc

  defp get_actions(uri, global_params, [action | tail], acc) do
    %{"name" => name, "description" => description, "method" => method, "parameters" => parameters} = action
    function_string = Prex.Templates.action_template(name, uri, method, global_params ++ parameters, description)

    get_actions(uri, global_params, tail, acc <> function_string)
  end

  defp get_actions(_uri, _global_params, [], acc), do: acc

end
