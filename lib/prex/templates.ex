defmodule Prex.Templates do
  @moduledoc """
  Templates for equivalant code for api requests
  """

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

    """
  end

  defp normalize_module_name(mod_name) do
    mod_name = mod_name |> String.replace(" ", "")
    IO.puts mod_name
    String.upcase(String.at(mod_name, 0)) <> String.slice(mod_name, 1, String.length(mod_name))
  end

  defp normalize_func_name(fun_name) do
    fun_name |> String.downcase |> String.replace(" ", "_")
  end

  defp normalize_http_method(method) do
    (":" <> method) |> String.downcase |> String.trim
  end

end
