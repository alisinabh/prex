defmodule Prex.Templates do
  @moduledoc """
  Templates for equivalant code for api requests
  """

  import Prex.NameHelpers

  @url_regex ~r/{([A-Za-z0-9\\?,]+)}/

  @doc """
  Creates an elixir module code for an API group

  ## Parameters
    - api_name: The name of the api. Used to determine module name.
    - group_name: Name of api group
    - base_url: Base url of current group. e.g. "http://example.com"
    - docs: description of current module
    - actions: group actions
  """
  @spec get_module(String.t, String.t, String.t, String.t, Enum.t) :: String.t
  def get_module(api_name, group_name, base_url, docs, actions) do
    module_name = cond do
      group_name == nil or group_name == "" ->
        IO.puts "warning: there is an unnamed resource group. using base module name..."
        normalize_module_name(api_name)
      true ->
        normalize_module_name(api_name) <> "." <> normalize_module_name(group_name)
    end
    """
    # Created by Prex
    defmodule #{module_name} do
      @moduledoc \"\"\"
      #{docs |> String.replace("\n", "\n  ")}
      \"\"\"

      @base_url \"#{base_url}\"

      ###
      # API Calls
      ###

    #{actions}end
    """
  end

  @spec get_module(String.t, String.t, String.t, [], String.t) :: String.t
  def action_template(name, url, method, [], docs) do
    action_name = normalize_func_name(name)
    req_method = normalize_http_method method
    """
      @doc \"\"\"
      #{docs}
      \"\"\"
      def #{action_name} do
        req_url = Path.join @base_url, \"#{url}\"
        HTTPotion.request(#{req_method}, req_url)
      end

      def #{action_name}! do
        {:ok, result} = #{action_name}()
        result
      end

    """
  end

  @doc """
  Generates elixir code for an action without any arguments

  ## Parameters:
    - name: Name of action
    - url: Url of action
    - method: Http method of action
    - params: List of action parameters
    - docs: Action documentation
  """
  @spec get_module(String.t, String.t, String.t, Enum.t, String.t) :: String.t
  def action_template(name, url, method, params, docs) do
    action_name = normalize_func_name(name)
    req_method = normalize_http_method method
    {:ok, action_params, recall_params, body, param_docs} = get_action_params(params, "", "", "", "")
    {:ok, striped_url, opt_params} = process_url url
    extra_url =
      case opt_params do
        nil ->
          ""
        "" ->
          ""
        opts ->
          " <>\n     #{Enum.join(opts, " <> \"&\" <> \n     ")}"
      end
    """
      @doc \"\"\"
      #{docs}

      ## Parameters
      #{param_docs}
      \"\"\"
      def #{action_name}(#{action_params}) do
        req_url = Path.join @base_url, \"#{striped_url}\"#{extra_url}
        
        HTTPotion.request(#{req_method}, req_url, body: Poison.encode!(%{#{body}}), headers: ["Content-Type": "application/json"])
      end

      def #{action_name}!(#{action_params}) do
        {:ok, result} = #{action_name}(#{recall_params})
        result
      end

    """
  end

  defp get_action_params([param | tail], param_acc, recall_acc, body_acc, doc_acc) do
    %{"name" => name, "description" => description, "required" => required, "default" => default} = param

    var_name = normalize_var_name(name)

    new_param_acc = param_acc <> var_name

    new_param_acc =
      case {required, default} do
      {true, nil} ->
        new_param_acc
      {true, ""} ->
        new_param_acc
      {true, default_val} ->
        new_param_acc <> " \\\\ \"#{default_val}\""
      {false, nil} ->
        new_param_acc <> " \\\\ nil"
      {false, ""} ->
        new_param_acc <> " \\\\ nil"
      {false, default_val} ->
        new_param_acc <> " \\\\ \"#{default_val}\""
    end

    IO.puts inspect {required, default}

    new_param_acc = new_param_acc <> ","

    new_recall_acc = recall_acc <> var_name <> ","

    new_body_acc = body_acc <> "\"#{name}\" => #{var_name}, "

    new_doc_acc = doc_acc <> "\n- #{var_name}: #{description}"

    get_action_params(tail, new_param_acc, new_recall_acc, new_body_acc, new_doc_acc)
  end

  defp get_action_params([], param_acc, recall_acc, body_acc, doc_acc) do
    param = param_acc |> String.slice(0, String.length(param_acc) - 1) |> String.replace(",", ", ")
    recall = recall_acc |> String.slice(0, String.length(recall_acc) - 1) |> String.replace(",", ", ")
    body = body_acc |> String.slice(0, String.length(body_acc) - 2)
    doc =  "  " <> (doc_acc |> String.slice(1, String.length(doc_acc)) |> String.replace("\n", "\n    "))
    {:ok, param, recall, body, doc}
  end

  defp process_url(url) do
    case Regex.run @url_regex, url do
      [_, url_params] ->
        params = String.split url_params, ","
        flat_url = Regex.replace(@url_regex, url, "")
        {:ok, req_params, opt_params} =
          do_process_url(params, [], [])

        IO.puts inspect opt_params

        case req_params do
          [] ->
            {:ok, flat_url, opt_params}
          [_a | _b] ->
            IO.puts inspect req_params
            query = Enum.join(req_params, "&")
            {:ok, "#{flat_url}?#{query}", opt_params}
        end
      _ ->
        {:ok, url, []}
    end

  end


  defp do_process_url([], params, optional_params), do: {:ok, params, optional_params}
  defp do_process_url([param | tail], params, optional_params) do
    if String.starts_with?(param, "?") do
      name = String.slice(param, 1, String.length(param)-1)
      do_process_url(tail,
       params,
       ["(if #{name} != nil, do: \"#{urlify_param(name)}\", else: \"\")" | optional_params])
    else
      do_process_url(tail,
      # url <> "#{param}=\#{#{param}}&",
       [urlify_param(param) | params],
       optional_params)
    end
  end

  defp urlify_param(param), do: "#{param}=\#{#{param} |> URI.encode_www_form}"

end
