defmodule Prex.Templates do
  @moduledoc """
  Templates for equivalant code for api requests
  """

  import Prex.NameHelpers

  def get_module(api_name, group_name, base_url, docs, actions) do
    module_name = normalize_module_name(api_name) <> "." <> normalize_module_name(group_name)
    """
    # Created by Prex
    defmodule #{module_name} do
      @moduledoc \"\"\"
      #{docs}
      \"\"\"

      @base_url \"#{base_url}\"

      ###
      # API Calls
      ###

    #{actions}end
    """
  end

  def action_template(name, url, method, [], docs) do
    action_name = normalize_func_name(name)
    req_method = normalize_http_method method
    """
      @doc \"\"\"
      #{docs}
      \"\"\"
      def #{action_name} do
        req_url = Path.join @base_url, \"#{url}\"
        HTTPoison.request(#{req_method}, req_url)
      end

      def #{action_name}! do
        {:ok, result} = #{action_name}
        result
      end

    """
  end

  def action_template(name, url, method, params, docs) do
    action_name = normalize_func_name(name)
    req_method = normalize_http_method method
    {:ok, action_params, body} = get_action_params(params, "", "")
    """
      @doc \"\"\"
      #{docs}
      \"\"\"
      def #{action_name}(#{action_params}) do
        req_url = Path.join @base_url, \"#{url}\"
        HTTPoison.request(#{req_method}, req_url, body: Poison.encode!(%{#{body}}), headers: ["Content-Type": "application/json"])
      end

      def #{action_name}!(#{action_params}) do
        {:ok, result} = #{action_name}(#{action_params})
        result
      end

    """
  end

  defp get_action_params([param | tail], param_acc, body_acc) do
    %{"name" => name, "description" => description, "required" => required, "default" => default} = param

    var_name = normalize_var_name(name)

    new_param_acc = param_acc <> var_name <> ","
    new_body_acc = body_acc <> " \"#{name}\" => #{var_name},"

    get_action_params(tail, new_param_acc, new_body_acc)
  end

  defp get_action_params([], param_acc, body_acc) do
    param = param_acc |> String.slice(0, String.length(param_acc) - 1)
    body = body_acc |> String.slice(0, String.length(body_acc) - 1)

    {:ok, param, body}
  end

end
