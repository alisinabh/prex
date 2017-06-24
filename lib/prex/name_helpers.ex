defmodule Prex.NameHelpers do
  @moduledoc """
  Naming helpers for Prex
  """

  @doc """
  Normalizes a module name to use in elixir

  ## Examples
      iex> Prex.NameHelpers.normalize_module_name " hello world"
      "Helloworld"
  """
  @spec normalize_module_name(String.t) :: String.t
  def normalize_module_name(mod_name) do
    mod_name = mod_name |> remove_schar |> String.replace(" ", "")
    String.upcase(String.at(mod_name, 0)) <> String.slice(mod_name, 1, String.length(mod_name))
  end

  @doc """
  Normalizes function names for use in elixir

  ## Examples
      iex> Prex.NameHelpers.normalize_func_name "(Get user info )"
      "get_user_info"
  """
  @spec normalize_func_name(String.t) :: String.t
  def normalize_func_name(fun_name) do
    fun_name |> remove_schar |> String.trim |> String.downcase |> String.replace(" ", "_")
  end

  @doc """
  Converts an http method name to equivalant atom for HTTPoison to use

  ## Examples
      iex> Prex.NameHelpers.normalize_http_method "GET"
      ":get"

      iex> Prex.NameHelpers.normalize_http_method "POST "
      ":post"
  """
  @spec normalize_http_method(String.t) :: String.t
  def normalize_http_method(method) do
    ":" <> (method |> remove_schar |> String.downcase |> String.trim |> String.replace(" ", ""))
  end

  @doc """
  Normalizes a variable name for use in elixir

  ## Examples
      iex> Prex.NameHelpers.normalize_var_name "A bad var name "
      "a_bad_var_name"
  """
  @spec normalize_var_name(String.t) :: String.t
  def normalize_var_name(var_name) do
    var_name |> String.trim |> remove_schar |> String.replace(" ", "_") |> String.downcase
  end

  @doc """
  Remove special chars form string

  ## Examples
      iex> Prex.NameHelpers.remove_schar "s()72mca&q "
      "s72mcaq "
  """
  @spec remove_schar(String.t) :: String.t
  def remove_schar(string), do: String.replace(string, ~r/[^0-9a-zA-Z ]/, "")

end
