defmodule Prex do
  @moduledoc """
  Prex module is used to generate actions
  """

  import Prex.NameHelpers
  import Prex.AstFile

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
