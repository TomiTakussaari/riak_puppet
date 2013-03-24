node "riak1", "riak2", "riak3" {
	exec { "purge default firewall":
        command => "/sbin/iptables --flush",
        user    => 'root',
    }
  	if $::fqdn == "riak1.vagrant.local" {
    	class { "riak": riak_control => true}
  	} else {
    	class { "riak": join_ip => "10.0.3.10" }
  	}
}
