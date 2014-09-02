defmodule Chat.RoomChannel do
  use Phoenix.Channel

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic

  Possible Return Values

  {:ok, socket} to authorize subscription for channel for requested topic

  {:error, socket, reason} to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join(socket, "lobby", message) do
    socket = socket |> Phoenix.Socket.assign :user, message["user"]
    IO.puts "JOIN #{socket.channel}:#{socket.topic}"
    reply socket, "join", %{status: "connected"}
    broadcast socket, "user:entered", %{user: message["user"]}
    {:ok, socket}
  end

  def join(socket, _private_topic, _message) do
    {:error, socket, :unauthorized}
  end

  def leave(socket, message) do
    user = socket |> Phoenix.Socket.get_assign :user
    broadcast socket, "user:left", %{user: user}
    socket
  end

  def event(socket, "new:msg", message) do
    broadcast socket, "new:msg", message
    socket
  end
end

