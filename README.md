#Riak puppet rhel


##Usage

      vagrant up
      
And it should magically setup Riak cluster with 3 virtual servers

You can test it with: 
      
      curl -v 10.0.3.10:8098/riak/ping

Or test Riak Control on node riak1 by going with your browser to: https://10.0.3.10:8068 
and logging in with user/pass
