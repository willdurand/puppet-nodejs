{
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  crack = {
    dependencies = ["safe_yaml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abb0fvgw00akyik1zxnq7yv391va148151qxdghnzngv66bl62k";
      type = "gem";
    };
    version = "0.4.3";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  domain_name = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12hs8yijhak7p2hf1xkh98g0mnp5phq3mrrhywzaxpwz1gw5r3kf";
      type = "gem";
    };
    version = "0.5.20170404";
  };
  facter = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0775zsymzv0pjkr3gz9l26cvzr8640f1ckcq2n4hh9z7iqbsc231";
      type = "gem";
    };
    version = "2.5.1";
  };
  fast_gettext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ci71w9jb979c379c7vzm88nc3k6lf68kbrsgw9nlx5g4hng0s78";
      type = "gem";
    };
    version = "1.1.2";
  };
  hashdiff = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yj5l2rw8i8jc725hbcpc4wks0qlaaimr3dpaqamfjkjkxl0hjp9";
      type = "gem";
    };
    version = "0.3.7";
  };
  hiera = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v82y87wv6y9b637kv7hjkshfn9wikdvwzf61dwjf1lwgjichszz";
      type = "gem";
    };
    version = "3.4.2";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  iconv = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkiq76d6cpxpa00yfyslnfql6yrpbnfhmzdxdxx60jhw293x4gg";
      type = "gem";
    };
    version = "1.0.5";
  };
  locale = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sls9bq4krx0fmnzmlbn64dw23c4d6pz46ynjzrn9k8zyassdd0x";
      type = "gem";
    };
    version = "2.1.2";
  };
  metaclass = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hp99y2b1nh0nr8pc398n3f8lakgci6pkrg4bf2b2211j1f6hsc5";
      type = "gem";
    };
    version = "0.0.4";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
  };
  mocha = {
    dependencies = ["metaclass"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hil2164qa3j1h9p83ai3la1gl3131ddj4il56vp2q8sfqvahc6q";
      type = "gem";
    };
    version = "1.5.0";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  netrc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x5h1dh1i3gwc01jbg01rly2g6a1qwhynb1s8a30ic507z1nh09s";
      type = "gem";
    };
    version = "3.0.2";
  };
  puppet = {
    dependencies = ["facter" "fast_gettext" "hiera" "locale" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10wxq37vg1lq5kjjbba9hhrqg0kwmh7mdx88bjlqc7h2mxmbnqf7";
      type = "gem";
    };
    version = "5.5.0";
  };
  puppet-blacksmith = {
    dependencies = ["rest-client"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n0cf644gwsqiara9635lwqc3pn90b4nfv9x4bcll31kk09grncg";
      type = "gem";
    };
    version = "4.1.2";
  };
  puppet-lint = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kif69a37q4c4870p871vk9vbcp8fqgjija33lmq2bhyfycg183r";
      type = "gem";
    };
    version = "2.3.5";
  };
  puppet-syntax = {
    dependencies = ["rake"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bf250k44m2bpjrq15cc0kazghs59dnhn54rf0kq51l8mchjbsif";
      type = "gem";
    };
    version = "2.4.1";
  };
  puppetlabs_spec_helper = {
    dependencies = ["mocha" "puppet-lint" "puppet-syntax" "rspec-puppet"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bf08cri19dnp39v4qkb18dljx0vbdscj4j9x3qg2pndqzym9cab";
      type = "gem";
    };
    version = "2.7.0";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1idi53jay34ba9j68c3mfr9wwkg3cd9qh0fn9cg42hv72c6q8dyg";
      type = "gem";
    };
    version = "12.3.1";
  };
  rest-client = {
    dependencies = ["http-cookie" "mime-types" "netrc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hzcs2r7b5bjkf2x2z3n8z6082maz0j8vqjiciwgg3hzb63f958j";
      type = "gem";
    };
    version = "2.0.2";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0134g96wzxjlig2gxzd240gm2dxfw8izcyi2h6hjmr40syzcyx01";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zvjbymx3avxm3lf8v4gka3a862vnaxldmwvp6767bpy48nhnvjj";
      type = "gem";
    };
    version = "3.7.1";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fw06wm8jdj8k7wrb8xmzj0fr1wjyb0ya13x31hidnyblm41hmvy";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b02ya3qhqgmcywqv4570dlhav70r656f7dmvwg89whpkq1z1xr3";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-puppet = {
    dependencies = ["rspec"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nd867iypapfqybgvsrk775bmhc6xsznk5nsv5rgwpqrqwprb7mn";
      type = "gem";
    };
    version = "2.6.11";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nl30xb6jmcl0awhqp6jycl01wdssblifwy921phfml70rd9flj1";
      type = "gem";
    };
    version = "3.7.1";
  };
  safe_yaml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
      type = "gem";
    };
    version = "1.0.4";
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06p1i6qhy34bpb8q8ms88y6f2kz86azwm098yvcc0nyqk9y729j1";
      type = "gem";
    };
    version = "0.0.7.5";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wsrrbvawcr198v4mhzy43br7i7l9d3av6sjq6if509qrj4y5x07";
      type = "gem";
    };
    version = "3.3.0";
  };
}