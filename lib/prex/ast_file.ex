defmodule Prex.AstFile do
  @moduledoc """
  Documentation for AstFile.
  """

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

end
