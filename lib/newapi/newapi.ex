# Created by Prex
defmodule Newapi do
  @moduledoc """
  
  """

  @base_url ""

  ###
  # API Calls
  ###

  # Tasks

  @doc """
  

  ## Parameters
    - status: 
    - priority: 
    - number: 
  """
  def list_all_tasks(status, priority, number) do
    req_url = Path.join @base_url, "/tasks/tasks?priority=#{priority |> URI.encode_www_form}" <>
     (if number != nil, do: "number=#{number |> URI.encode_www_form}", else: "") <> "&" <> 
     (if status != nil, do: "status=#{status |> URI.encode_www_form}", else: "")
    
    HTTPotion.request(:get, req_url, body: Poison.encode!(%{"status" => status, "priority" => priority, "number" => number}), headers: ["Content-Type": "application/json"])
  end

  def list_all_tasks!(status, priority, number) do
    {:ok, result} = list_all_tasks(status, priority, number)
    result
  end

  @doc """
  This is a state transition to another resource.

  ## Parameters
    - status: 
    - priority: 
    - number: 
    - id: 
  """
  def retrieve_task(status, priority, number, id) do
    req_url = Path.join @base_url, "/tasks/tasks?priority=#{priority |> URI.encode_www_form}" <>
     (if number != nil, do: "number=#{number |> URI.encode_www_form}", else: "") <> "&" <> 
     (if status != nil, do: "status=#{status |> URI.encode_www_form}", else: "")
    
    HTTPotion.request(:get, req_url, body: Poison.encode!(%{"status" => status, "priority" => priority, "number" => number, "id" => id}), headers: ["Content-Type": "application/json"])
  end

  def retrieve_task!(status, priority, number, id) do
    {:ok, result} = retrieve_task(status, priority, number, id)
    result
  end

  @doc """
  

  ## Parameters
    - status: 
    - priority: 
    - number: 
    - id: 
  """
  def delete_task(status, priority, number, id) do
    req_url = Path.join @base_url, "/tasks/tasks?priority=#{priority |> URI.encode_www_form}" <>
     (if number != nil, do: "number=#{number |> URI.encode_www_form}", else: "") <> "&" <> 
     (if status != nil, do: "status=#{status |> URI.encode_www_form}", else: "")
    
    HTTPotion.request(:delete, req_url, body: Poison.encode!(%{"status" => status, "priority" => priority, "number" => number, "id" => id}), headers: ["Content-Type": "application/json"])
  end

  def delete_task!(status, priority, number, id) do
    {:ok, result} = delete_task(status, priority, number, id)
    result
  end

end
