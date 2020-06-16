defmodule SGenServer do
    use GenServer

    def start_link() do
        GenServer.start_link(__MODULE__,[],name: Server)
    end

    def init(args) do
        state = {}
        # state = Enum.at(args,0)
        :ets.new(:account_register ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        :ets.new(:activeaccounts ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        :ets.new(:sublist ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        :ets.new(:usertweets ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        :ets.new(:subscribedtweets ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        :ets.new(:mentions ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        :ets.new(:hashtags ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        :ets.new(:webusers ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        :ets.new(:webtweets ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        :ets.new(:websubs ,[:set,:public,:named_table,{:read_concurrency, true}, {:write_concurrency, true}])
        # Registry.start_link(keys: :unique,name: :TweetRegister)
        # state = Enum.at(args,0)
        # SGenServer.getsubscribers(numusers)
        {:ok, state}
    end

    # def getsid() do
    #     state
    # end

    def handle_cast({:check},state) do
        IO.inspect "checking"
        {:noreply, state}
      end

    # def handle_cast({:register, username},state) do
    #     :ets.insert_new(:webusers,{username,self()})
    #     IO.inspect "registering in server"
    #     IO.inspect username        
    #     {:noreply, state}
    # end

    def handle_call({:register,username},_from,state) do
        :ets.insert_new(:webusers,{username,self()})
        IO.inspect "registering in server"
        IO.inspect username        
        {:reply,"fj",state}
    end

    def handle_cast({:tweet_subs,tweetvalue,username},state) do
        IO.inspect "tweeting"
        :ets.insert_new(:webusers,{username,tweetvalue})
        {:noreply, state}
    end

    def handle_cast({:subscribeuser,subscriberName,username},state) do
        IO.inspect "subscribing"
        :ets.insert_new(:webusers,{subscriberName,username})
        {:noreply, state}
    end

    def handle_cast({:searchhash,hashtagValue,username},state) do
        IO.inspect "searching"
        # :ets.insert_new(:webusers,{subscriberName,username})

        {:noreply, state}
    end

#   def getsubscribers(numusers) do

#     users= Enum.to_list(1..numusers)
#     Enum.reduce(users, 1, fn x, acc ->
#       numsubs = length(users)
#       zipfFollowCount = ceil((1/acc)*numsubs)
#       subscribers = Enum.take_random(users, zipfFollowCount) -- [x]
#     #   IO.inspect (Registry.lookup(:NameRegister,[x]))
#     #   ßGenServer.cast(elem(Enum.at(Registry.lookup(:NameRegister,x),0),0), {:addsubscribers, subscribers})
#     # IO.inspect elem(Enum.at(Registry.lookup(:NameRegister,x),0),0)
#     IO.inspect Registry.lookup(:NameRegister,x)
#       acc + 1
#     end)
#     :timer.sleep(10)
#     # GenServer.cast(Server, {:printtable, 1})
#     # IO.puts "initialexit"
#   end

    def start_workers() do
        # GenServer.cast(sid,{:table})
        # {:noreply, state}
    end

    def handle_cast({:table},state) do
        # IO.inspect state
        {:noreply, state}
    end

    def handle_cast({:getsubs,numusers,uid,sid,x},state) do
        # IO.inspect "coming here"
        users= Enum.to_list(1..numusers)
            # Enum.reduce(users, 1, fn x, acc ->
              numsubs = length(users)
              rank = Enum.at(Enum.take_random(users,1),0)
            #   IO.inspect rank
            #   ceil((1/acc)*numsubs)
                zipfFollowCount = ceil((1/rank)*numsubs)
              subscribers = Enum.take_random(users, zipfFollowCount) -- [x]
            #   IO.inspect (Registry.lookup(:NameRegister,[x]))
            #   ßGenServer.cast(elem(Enum.at(Registry.lookup(:NameRegister,x),0),0), {:addsubscribers, subscribers})
            # IO.inspect SGenServer.getpidofnode(x)
            # IO.inspect Registry.lookup(:NameRegister,x)
            # :ets.insert_new(:account_register,{uid, subscribers})
            # :ets.insert_new(:activeaccounts,{uid, :true})
              GenServer.cast(SGenServer.userpid(x), {:addsubscribers, subscribers,uid,sid})
            #   acc + 1
            # end)
        {:noreply, state}
    end

    # def handle_call({:getsubs,numusers,uid,sid,x},_from,state) do
    #     # IO.inspect "coming here"
    #     users= Enum.to_list(1..numusers)
    #         # Enum.reduce(users, 1, fn x, acc ->
    #           numsubs = length(users)
    #           rank = Enum.at(Enum.take_random(users,1),0)
    #         #   IO.inspect rank
    #         #   ceil((1/acc)*numsubs)
    #             zipfFollowCount = ceil((1/rank)*numsubs)
    #           subscribers = Enum.take_random(users, zipfFollowCount) -- [x]
    #         #   IO.inspect (Registry.lookup(:NameRegister,[x]))
    #         #   ßGenServer.cast(elem(Enum.at(Registry.lookup(:NameRegister,x),0),0), {:addsubscribers, subscribers})
    #         # IO.inspect SGenServer.getpidofnode(x)
    #         # IO.inspect Registry.lookup(:NameRegister,x)
    #         # :ets.insert_new(:account_register,{uid, subscribers})
    #         # :ets.insert_new(:activeaccounts,{uid, :true})
    #           GenServer.cast(SGenServer.getpidofnode(x), {:addsubscribers, subscribers,uid,sid})
    #         #   acc + 1
    #         # end)
    #     {:stop, state}
    # end

    # def handle_cast({:addsubscribers,subscribers,uid,sid},state) do
    #     IO.inspect "coming here"
    #     {:noreply, state}
    # end

    def handle_cast({:sample,uid,sid,subscriberslist},state) do
        # IO.inspect "coming here"
        :ets.insert_new(:sublist,{uid, subscriberslist})
        :ets.insert_new(:activeaccounts,{uid, :true})
        {:noreply, state}
    end

    def handle_cast({:registeraccount,uid,usertweets},state) do
        # IO.puts ("coming to server thread")
        # IO.inspect Registry.keys(:NameRegister,uid)
        :ets.insert(:account_register,{uid,usertweets})
        :ets.insert(:usertweets,{uid,usertweets})

        # IO.inspect(:ets.lookup(:usertweets,uid))
        {:noreply, state}
    end

    def handle_cast({:deleteaccount,uid},state) do
        :ets.delete(:account_register,uid)
    end

    def handle_cast({:hashtagsearch,uid,usertweets},state) do
        # IO.inspect usertweets
        Enum.each(usertweets,fn x ->
        # IO.inspect (String.split(x," "))
        temp = String.split(x," ")
        acc = ""
        Enum.reduce(temp,acc,fn y,acc-> 
        if(String.at(y,0) == "#") do
            # IO.inspect x
            # IO.inspect y
            if(:ets.lookup(:hashtags,y) == []) do
                :ets.insert_new(:hashtags,{y, [x]})
            else 
                new = Enum.at(Tuple.to_list(Enum.at(:ets.lookup(:hashtags,y),0)),1)
                # IO.inspect new
                :ets.insert(:hashtags,{y, new ++ [x]})
            end
        end
        if(:ets.lookup(:hashtags,y) != []) do
            #  IO.inspect :ets.lookup(:hashtags,y)
        end
        end)
        
    #     if(:ets.lookup(:hashtags,y) != []) do
    #         IO.inspect :ets.lookup(:hashtags,y)
    #    end
        # IO.inspect "end"
        # IO.inspect (IO.inspect :ets.lookup(:hashtags,"#kasiiggs")

        end)
        {:noreply, state}
    end


    def handle_cast({:mentionsearch,uid,usertweets},state) do
        # IO.inspect usertweets
        Enum.each(usertweets,fn x ->
        # IO.inspect (String.split(x," "))
        temp = String.split(x," ")
        acc = ""
        Enum.reduce(temp,acc,fn y,acc-> 
        if(String.at(y,0) == "@") do
            # IO.inspect x
            # IO.inspect y
            if(:ets.lookup(:mentions,y) == []) do
                :ets.insert_new(:mentions,{y, [x]})
            else 
                new = Enum.at(Tuple.to_list(Enum.at(:ets.lookup(:mentions,y),0)),1)
                # IO.inspect new
                :ets.insert(:mentions,{y, new ++ [x]})
            end
        end
        if(:ets.lookup(:mentions,y) != []) do
            #  IO.inspect :ets.lookup(:mentions,y)
        end
        end)
        
        end)
        {:noreply, state}
    end


    def handle_cast({:tweetuser,usertweet,sid,uid},state) do
        # IO.inspect "server tweet" 
        # IO.inspect usertweet

        {:noreply, state}
    end

    def handle_cast({:subscribedtweets,tweets,pid},state) do
        # IO.inspect "in server"
        # cond do
        #     :ets.lookup(:subscribedtweets,pid) == [] -> :ets.insert_new(:subscribedtweets,{pid, tweets})
        # true ->
        #     a =  Enum.at(Tuple.to_list(Enum.at(:ets.lookup(:subscribedtweets,pid),0)),1)
        #     IO.inspect a
        #     IO.inspect a ++ tweets
        # :ets.insert(:sunscribedtweets,{pid,a ++ tweets})
        
        # end
        cond do 
           Registry.lookup(:TweetRegister,pid) == [] -> Registry.register(:TweetRegister,pid,tweets)
        true->
            a =  Enum.at(Tuple.to_list(Enum.at(Registry.lookup(:TweetRegister,pid),0)),1)
            b = a ++ tweets
            # IO.inspect b
            Registry.unregister(:TweetRegister,pid)
            Registry.register(:TweetRegister,pid,b)
        end
        
        # IO.inspect :ets.lookup(:usertweets,pid) |> Enum.at(0) |> elem(1)
        # if(:ets.lookup(:usertweets,pid) != []) do
        #     IO.inspect :ets.lookup(:usertweets,pid) |> Enum.at(0) |> elem(1)
        # end
        # IO.inspect Registry.lookup(:TweetRegister,pid)
        # if(elem(Enum.at(Registry.lookup(:TweetRegister,pid),0),0)!=nil) do
        #     IO.inspect Enum.at(Tuple.to_list(Enum.at(Registry.lookup(:TweetRegister,pid),0)),1)
        #     end
        # if(Registry.lookup(:TweetRegister,1) != nil) do
        # IO.inspect Registry.lookup(:TweetRegister,1) |> Enum.at(0) |> elem(1)
        # end
    
        {:noreply, state}
    end

    def userpid(user) do
        case Registry.lookup(:NameRegister, user) do
        [{pid, _}] -> pid
        [] -> nil
        end
      end

    #   def handle_call(:logout, _from, nil) do
    #     # :ets.insert(:activeusers,{userid, :false})
    #     IO.puts "user logged out"
    #     {:reply, "userlogouts", nil}
    
    #   end
end