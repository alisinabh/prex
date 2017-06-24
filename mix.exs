defmodule Prex.Mixfile do
  use Mix.Project

  @version "0.0.3"

  def project do
    [app: :prex,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps(),
     name: "Prex",
     source_url: "https://github.com/alisinabh/prex",
     docs: [main: "readme", extras: ["README.md"]]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:poison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:poison, "~> 3.1"},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    # These are the default files included in the package
    [
      name: :prex,
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Alisina Bahadori"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/alisinabh/prex"}
    ]
  end

  defp description do
   """
   Prex is a REST API client code generator for elixir
   """
  end

end
