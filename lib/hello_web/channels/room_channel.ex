defmodule HelloWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
end
def join("room:"<> _private_room_id, _params, _socket) do
  {:error, %{reason: "unauthorized"}}
end

   #handle to register clients
   def handle_in("register", username, socket) do
    IO.inspect "receiving"
    IO.inspect username
    GenServer.call(Server, {:register, username})
    push socket, "registered",  %{"userName" => username}
    {:reply, :registered, socket}
end

  def handle_in("sendtweet",payload,socket) do
    # IO.inspect "inside tweeting"
    
    username = payload["username"]
    tweetvalue = payload["tweetvalue"]
    # IO.inspect tweetvalue
    # IO.inspect "inside tweeting 1"
    GenServer.cast(:server, {:tweet_subs,tweetvalue,username})
    {:noreply, socket}
  end

  def handle_in("subscribeuser",payload,socket) do
    # IO.inspect "inside tweeting"
    
    username = payload["username"]
    subscriberName= payload["subscriberName"]
    IO.inspect subscriberName
    # IO.inspect "inside tweeting 1"
    GenServer.cast(Server, {:subscribeuser,subscriberName,username})
    {:noreply, socket}
  end

  def handle_in("searchhashtag",payload,socket) do
    # IO.inspect "inside tweeting"
    
    username = payload["username"]
    hashtagValue= payload["hashtagValue"]
    IO.inspect hashtagValue
    # IO.inspect "inside tweeting 1"
    GenServer.cast(Server, {:searchhash,hashtagValue,username})
    {:noreply, socket}
  end




end