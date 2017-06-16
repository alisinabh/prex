defmodule PrexTest do
  use ExUnit.Case
  doctest Prex
  doctest Prex.NameHelpers

  test "the truth" do
    assert 1 + 1 == 2
  end

  setup_all _context do
    [ast_file: Prex.AstFile.parse_file! "test/test.json"]
  end

  test "get host name", context do
    hostname = Prex.AstFile.get_host context[:ast_file]
    assert hostname == "http://sample.pandurangpatil.com"
  end

  test "get resource groups", context do
    resource_groups = Prex.AstFile.get_resource_groups(context[:ast_file])
    assert Enum.count(resource_groups) == 1
  end
end
