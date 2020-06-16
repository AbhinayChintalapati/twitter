defmodule Twitter do
  use GenServer
  @moduledoc """
  Documentation for Twitter.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Twitter.hello()
      :world

  """
  def off() do
    off()
end


def main(num1,num2) do
    # n1 = Enum.at(arg,0)
    # num1 = String.to_integer(n1)
    # n2 = Enum.at(arg,1)
    # num2 = String.to_integer(n2)
    Registry.start_link(keys: :unique,name: :NameRegister)
    Registry.start_link(keys: :unique,name: :TweetRegister)
 
    {:ok,sid} = SGenServer.start_link(num1)
    # tweet = "tweeting"
    SGenServer.start_workers(sid);
    # IO.inspect num2
    Enum.each(1..num1,fn x->
    {:ok,uid} = UGenServer.start_link(sid,num1,num2,x)
    UGenServer.start_workers(uid,sid,num1,x)
    # GenServer.cast(uid,{:tweetuser,tweet})
    end)

    # off()
end

  def hello do
    :world
  end
end
