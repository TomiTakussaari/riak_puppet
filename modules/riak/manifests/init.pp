class riak ($join_ip = undef, $listen_ip = $::ipaddress_eth2, $riak_control = false, $controlUser = 'user', $controlPassword = 'pass') {
  require riak::basho-rpm-repo

  package { "riak":
    ensure => "1.3.0-1.el6"
  }

  file { ["/data","/data/riak","/data/riak/logs", "/data/riak/ring"]:
    require => Package["riak"],
    ensure => directory,
    owner => "riak",
    group => "riak"
  }

  file { "app.config":
    path => "/etc/riak/app.config",
    ensure => present,
    content => template("riak/etc/riak/app.config.erb"),
    require => Package["riak"],
  }

  file { "/etc/security/limits.d/riak.conf":
    ensure => present,
    source => "puppet:///modules/riak/etc/security/limits.d/riak.conf",
    require => Package["riak"]
  }

  file { "vm.args":
    path => "/etc/riak/vm.args",
    ensure => present,
    content => template("riak/etc/riak/vm.args.erb"),
    require => Package["riak"],
  }

  service { "riak":
    require   => [ File["app.config"], File["vm.args"], File["/data/riak"] ],
    ensure    => "running",
    hasstatus => true,
    enable    => true,
    status    => "service riak ping",
    subscribe => [ File["app.config"], File["vm.args"] ]
  }

  if $riak_control == true {
    file { "cert.pem":
      require => Package["riak"],
      path => "/etc/riak/cert.pem",
      ensure => present,
      source => "puppet:///modules/riak/etc/riak/cert.pem",
    }
    file { "key.pem":
      require => Package["riak"],
      path => "/etc/riak/key.pem",
      ensure => present,
      source => "puppet:///modules/riak/etc/riak/key.pem",
    }
  }

  if $join_ip != undef {
    exec { "join-cluster":
      command => "/usr/sbin/riak-admin cluster join riak@$join_ip",
      tries => 3,
      try_sleep => 30,
      unless => "/usr/sbin/riak-admin status | grep ring_members | grep $join_ip",
      require => Service["riak"],
      logoutput => "on_failure",
    }

    exec { "plan-cluster":
      command => "/usr/sbin/riak-admin cluster plan",
      tries => 3,
      try_sleep => 30,
      unless => "/usr/sbin/riak-admin status | grep ring_members | grep $join_ip",
      require => Exec["join-cluster"],
      logoutput => "on_failure",
    }

    exec { "commit-cluster":
      command => "/usr/sbin/riak-admin cluster commit",
      tries => 3,
      try_sleep => 30,
      unless => "/usr/sbin/riak-admin status | grep ring_members | grep $join_ip",
      require => Exec["plan-cluster"],
      logoutput => "on_failure",
    }

  }
}
