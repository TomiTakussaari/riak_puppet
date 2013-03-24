#Riak puppet rhel


##Just do

      vagrant up
      
On project roo, and it should automagically setup Riak cluster with 3 virtual servers:

      10.0.3.10 (will have Riak Control installed)
      10.0.3.11
      10.0.3.11

You can test it with: 
      
      curl -v 10.0.3.10:8098/riak/ping

Or test Riak Control on node riak1 by going with your browser to: https://10.0.3.10:8068 
and logging in with user/pass (it will whine about invalid certificate)
