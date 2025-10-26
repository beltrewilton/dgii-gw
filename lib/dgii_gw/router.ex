defmodule DgiiGw.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match

  plug Plug.Parsers,
    parsers: [:json, :urlencoded, :multipart],
    pass: ["*/*"],
    json_decoder: Jason

  plug :dispatch

  post "/" do
    # prefer parsed body; fall back to raw body if content-type is unknown
    params =
      case conn.body_params do
        %Plug.Conn.Unfetched{} ->
          {:ok, raw, _conn} = Plug.Conn.read_body(conn, length: 10_000_000, read_timeout: 15_000)
          raw
        other ->
          other
      end

    entry = %{
      ts: DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601(),
      ip: format_ip(conn.remote_ip),
      method: conn.method,
      path: conn.request_path,
      headers: Map.new(conn.req_headers),
      body: params
    }

    case DgiiGw.RequestLogger.append(entry) do
      :ok ->
        send_resp(conn, 200, Jason.encode!(%{status: "ok"}))
      {:error, reason} ->
        send_resp(conn, 500, Jason.encode!(%{status: "error", reason: inspect(reason)}))
    end
  end

  match _ do
    send_resp(conn, 404, Jason.encode!(%{error: "not_found"}))
  end

  defp format_ip({a,b,c,d}), do: Enum.join([a,b,c,d], ".")
  defp format_ip(other), do: to_string(:inet.ntoa(other))
end
