defmodule UGenServer do
    use GenServer

    def start_link(sid,numusers,nummsg,x) do
        GenServer.start_link(__MODULE__,[sid,numusers,nummsg,x],name: {:via, Registry, {:NameRegister, x}})
    end

    def init(args) do
        # state = {}
        numusers = Enum.at(args,1)
        nummsgs = Enum.at(args,2)
        # texts = ["Just Abhi","Pilla kutha","Kasi","Akka","DAS ANNA","Sri Sri Sri Pathanandha Swami Choudhary garu","pk = pathi kumar","pilla kutha","Zefee","Kiku  = Shadow","Douchebag feels"]
        # tags = ["#swamiji","#douchebagfeels","#isashadow","#kasiiggs","#chilipishadow","#pkanitaoanita","#varunbrofeels"]
        # Enum.each(1..3, fn x-> 
        #     usertexts = Enum.take_random(texts,4)
        #     usertweet = Enum.reduce(1..4,"",fn x,acc -> 
        #         acc = Enum.join([acc,Enum.at(usertexts,x-1)]," ")
        #         acc
        #     end)
        #     usertags = Enum.take_random(tags,1)
        #     usertweet = Enum.join([usertweet,usertags],"")
        #     # IO.inspect usertweet
        # end)

        # texts = ["This","Lakers","Lebron","James","Harden","Sri Sri Sri Pathanandha Swami Choudhary garu","pk = pathi kumar","pilla kutha","Zefee","Kiku  = Shadow","Douchebag feels"]
        # tags = ["#swamiji","#douchebagfeels","#isashadow","#kasiiggs","#chilipishadow","#pkanitaoanita","#varunbrofeels"]
        texts = ["Just Abhi","Pilla kutha","Kasi","Akka","DAS ANNA","Sri Sri Sri Pathanandha Swami Choudhary garu","pk = pathi kumar","pilla kutha","Zefee","Kiku  = Shadow","Douchebag feels"]
        tags = ["#swamiji","#douchebagfeels","#isashadow","#kasiiggs","#chilipishadow","#pkanitaoanita","#varunbrofeels"]
        finaltweets = Enum.reduce(1..nummsgs,[],fn x,acc->   
            tweet = Enum.join(["",Enum.join(Enum.take_random(texts,10)," ")]," ")
            tagtweet = Enum.at(Enum.take_random([Enum.at(Enum.take_random(tags,1),0," ")],1),0)
            usermen = Enum.at(Enum.take_random([Enum.join(["@User-",Integer.to_string(Enum.at(Enum.take_random(Enum.to_list(1..numusers),1),0))],""),""],1),0)
            usertweet = Enum.join([tagtweet,usermen]," ")
            fintweet = Enum.join([tweet,usertweet], " ")
            acc = acc ++ [fintweet]
        end)
      

        state = finaltweets
        # state = Enum.join(Enum.at(args,0),usertweet)
        {:ok, state}
    end

    def start_workers(uid,sid,numusers,x)do
        
        # :timer.sleep(5)
        GenServer.cast(uid,{:register,uid,sid})
        # GenServer.cast(uid,{:tweetgen,sid,uid})
        # GenServer.cast(sid,{:getsubs,numusers,uid,sid,x})
        # :timer.sleep(5)
        # GenServer.call(sid,{:getsubs,numusers,uid,sid,x})
        UGenServer.getsubscribers(sid,numusers,uid,x)
        :timer.sleep(50)
        GenServer.cast(uid,{:tosubtweets,uid,sid})
        GenServer.cast(uid,{:printtweets})
        GenServer.cast(uid,{:hashtagsearch,uid,sid})
        GenServer.cast(uid,{:mentionsearch,uid,sid})
        # GenServer.cast(uid,{:lookup})
    end 

    def getsubscribers(sid,numusers,uid,x) do
        GenServer.cast(sid,{:getsubs,numusers,uid,sid,x})
    end

    def handle_cast({:addsubscribers,subscribers,uid,sid},state) do
        # IO.inspect "adding subs"
        # IO.inspect subscribers

        # :ets.insert_new(:sublist,{uid, subscribers})
        # :ets.insert_new(:activeaccounts,{uid, :true})
        # GenServer.cast(sid,{{:addsubscribers,subscribers,uid,sid}})
        # subscriberslist = subscribers
        GenServer.cast(sid,{:sample,uid,sid,subscribers})
        {:noreply, state}
    end

    def handle_cast({:tosubtweets,uid,sid},state) do
        # IO.inspect :ets.lookup(:sublist,uid)
        # IO.inspect elem(Enum.at(:ets.lookup(:sublist,uid),0),1)
        # sublist = elem(Enum.at(:ets.lookup(:sublist,uid),0),1)
        # IO.inspect "sub tweets"
        # IO.inspect Enum.at(:ets.lookup(:sublist,uid),0)
        if(Enum.at(:ets.lookup(:sublist,uid),0)!=nil)do
        sublist = Enum.at(Tuple.to_list(Enum.at(:ets.lookup(:sublist,uid),0)),1)
        # IO.inspect sublist
        Enum.each(sublist,fn x-> 
        cond do
        Registry.lookup(:NameRegister,x)!=[] ->
        pid = elem(Enum.at(Registry.lookup(:NameRegister,x),0),0)
        tweets = state
        GenServer.cast(sid,{:subscribedtweets,tweets,pid})
        # IO.inspect pid
        true ->
        end
        end)
    end
        
        {:noreply, state}
    end

    def handle_cast({:hashtagsearch,uid,sid},state) do
        GenServer.cast(sid,{:hashtagsearch,uid,state})
        {:noreply, state}
    end

    def handle_cast({:mentionsearch,uid,sid},state) do
        GenServer.cast(sid,{:mentionsearch,uid,state})
        {:noreply, state}
    end

    def handle_cast({:tweetgen,sid,uid},state) do
        texts = ["This","Lakers","Lebron","James","Harden","Sri Sri Sri Pathanandha Swami Choudhary garu","pk = pathi kumar","pilla kutha","Zefee","Kiku  = Shadow","Douchebag feels"]
        tags = ["#swamiji","#douchebagfeels","#isashadow","#kasiiggs","#chilipishadow","#pkanitaoanita","#varunbrofeels"]
        Enum.each(1..3, fn x-> 
            usertexts = Enum.take_random(texts,4)
            i = 0
            usertweet = Enum.reduce(1..4,"",fn x,acc -> 
                acc = Enum.join([acc,Enum.at(usertexts,x-1)]," ")
                acc
            end)
            usertags = Enum.take_random(tags,1)
            usertweet = Enum.join([usertweet,usertags],"")
            # IO.inspect usertweet
            GenServer.cast(sid,{:tweetuser,usertweet,sid,uid})
        end)
        {:noreply, state}
    end

    def handle_cast({:register,uid,sid},state) do
        # IO.inspect "coming here"
        # IO.inspect state
        GenServer.cast(sid,{:registeraccount,uid,state})
        {:noreply, state}
    end

    def handle_cast({:delete,uid},state) do
        GenServer.cast(state,{:deleteaccount,uid})
        {:noreply, state}
    end 

    def handle_cast({:tweetuser,tweet,sid,uid},state) do
        GenServer.cast(sid,{:tweetuser,tweet})
        {:noreply, state}
    end

    def handle_cast({:printtweets},state) do
        # IO.inspect state
        {:noreply, state}
    end

    def handle_cast({:lookup},state) do
        # IO.inspect Registry.lookup(:NameRegister,7)
        if(Enum.at(Registry.lookup(:NameRegister,9),0) != nil) do
        # IO.inspect elem(Enum.at(Registry.lookup(:NameRegister,9),0),0)
        # new = Enum.at(Tuple.to_list(Enum.at(Registry.lookup(:NameRegister,7),0)),1)
        # elem()
        # IO.inspect SGenServer.getsid()
        
        end
        GenServer.cast(Server,{:check})
        # GenServer.call(Server,:logout)
        {:noreply, state}
    end

    # def handle_call({:logout,uid}, _from,state) do

    #     IO.puts "user wants to log out"
    #     GenServer.call(Server,{:logout, uid})
    #     {:reply, "loggedout", state}
    #   end
    

end