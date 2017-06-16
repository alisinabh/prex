defmodule Prex.NameHelpers do
  @moduledoc """
  Naming helpers for Prex
  """

  @doc false
  def normalize_module_name(mod_name) do
    mod_name = mod_name |> String.replace(" ", "")
    IO.puts mod_name
    String.upcase(String.at(mod_name, 0)) <> String.slice(mod_name, 1, String.length(mod_name))
  end

  @doc false
  def normalize_func_name(fun_name) do
    fun_name |> String.downcase |> String.replace(" ", "_")
  end
  
  @doc false
  def normalize_http_method(method) do
    (":" <> method) |> String.downcase |> String.trim
  end

  @doc false
  def normalize_var_name(var_name) do
    var_name |> String.downcase |> String.replace(" ", "_")
  end
end
