defmodule DgiiGw.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port    = Application.get_env(:dgii_gw, :port, 3022)
    plug    = DgiiGw.Router

    children = [
      # Starts a worker by calling: DgiiGw.Worker.start_link(arg)
      # {DgiiGw.Worker, arg}
      {Bandit, plug: plug, scheme: :http, port: port}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DgiiGw.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
