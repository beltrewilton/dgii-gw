defmodule DgiiGw.MixProject do
  use Mix.Project

  def project do
    [
      app: :dgii_gw,
      version: "0.1.0",
      elixir: "~> 1.17.2",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DgiiGw.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.18"},
      {:bandit, "~> 1.8"},      # HTTP server (pure Elixir)
      {:jason, "~> 1.4"}        # JSON parser/encoder
    ]
  end
end
