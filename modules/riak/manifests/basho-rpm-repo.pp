class riak::basho-rpm-repo {
  yumrepo { "basho-repository":
    baseurl => "http://yum.basho.com/el/6/products/\$basearch",
    descr => "Basho repository",
    enabled => 1,
    gpgcheck => 1,
    gpgkey => "http://yum.basho.com/gpg/RPM-GPG-KEY-basho",
  }
}
