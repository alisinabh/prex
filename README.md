# Prex
[![Status](https://img.shields.io/badge/status-under%20development-red.svg)]()
[![Build Status](https://travis-ci.org/alisinabh/prex.svg?branch=master)](https://travis-ci.org/alisinabh/prex)

Tasks for generating api interfaces in elixir from ApiBlueprint files.

**This project is under development and in experimental stage**

## What is ApiBlueprint?

According to [ApiBlueprint.org](https://apiblueprint.org/)

> API Blueprint is a powerful high-level API description language for web APIs.

So in an ApiBlueprint file (.apib) there is information on Actions and their parameters.

## What Prex does?

Prex can convert .apib files to equivalant elixir code as a bootstrap with .apib documents.

It can help you spend your time mostly on your issues instead of developing API client.

## How prex Does it?

1. Simply add ``:prex`` as dev only dependency in your project like this:

```elixir
def deps do
  [{:prex, "~> 0.1.0", only: [:dev]}]
end
```

2. Install ``drafter``: [github.com/apiaryio/drafter](https://github.com/apiaryio/drafter#install)
3. Run ``mix deps.get`` and ``mix deps.compile``
4. Now you can run ``mix prex.gen.from_blueprint [path to .apib file] [name for api]``
5. Tadaa! A file like this is now generated in lib directory of your project

```elixir
# Created by Prex
defmodule MyApi.User do
  @moduledoc """
  Represents user details.
  
  **User attributes:**
  - id `(Number)` : unique identifier.
  - fname `(String)` : First Name.
  - lname `(String)` : Last Name.
  - email `(String)` : email id of the user.
  """

  @base_url "http://sample.pandurangpatil.com"

  ###
  # API Calls
  ###

  # User Collection

  @doc """
  Retrieve paginated list of users.

  ## Parameters
    - since: Timestamp in ISO 8601 format: `YYYY-MM-DDTHH:MM:SSZ` Only users updated at or after this time are returned.
    - limit: maximum number of records expected by client.
  """
  def list_all_users(since \\ nil, limit \\ nil) do
    req_url = Path.join @base_url, "/users(?since,limit)"
    HTTPoison.request(:get, req_url, body: Poison.encode!(%{ "since" => since, "limit" => limit}), headers: ["Content-Type": "application/json"])
  end

  def list_all_users!(since \\ nil, limit \\ nil) do
    {:ok, result} = list_all_users(since, limit)
    result
  end

  @doc """
  Create a user
  """
  def create_a_user do
    req_url = Path.join @base_url, "/users(?since,limit)"
    HTTPoison.request(:put, req_url)
  end

  def create_a_user! do
    {:ok, result} = create_a_user()
    result
  end

end
```

## Documents

Currently docs for mix task and usage is not available!

[Full documents](https://hexdocs.pm/prex).

## License

MIT
