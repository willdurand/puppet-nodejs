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
      sha256 = "0abdlwb64ns7ssmiqhdwgl27ly40x2l27l8hs8hn0z4kb3zd2x3v";
      type = "gem";
    };
    version = "0.5.20180417";
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
      sha256 = "1ybxhp83wg6fichplssk5d405p1gzawc00963f71w9j3rxypzxji";
      type = "gem";
    };
    version = "3.4.5";
  };
  hocon = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "125yg9qliw8p4cw32kj4lxw75kk7hclxya5if30l99km9qp4pc1k";
      type = "gem";
    };
    version = "1.2.5";
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
  httpclient = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
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
      sha256 = "0fjxy1jm52ixpnv3vg9ld9pr9f35gy0jp66i1njhqjvmnvq0iwwk";
      type = "gem";
    };
    version = "3.2.2";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07wvp0aw2gjm4njibb70as6rh5hi1zzri5vky1q6jx95h8l56idc";
      type = "gem";
    };
    version = "3.2018.0812";
  };
  mocha = {
    dependencies = ["metaclass"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13whjmrm4n48rwx7h7a2jwa5grar3m0fxspbm2pm4lyp7hi119c1";
      type = "gem";
    };
    version = "1.7.0";
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
      sha256 = "08q64b5br692dd3v0a9wq9q5dvycc6kmiqmjbdxkxbfizggsvx6l";
      type = "gem";
    };
    version = "3.0.3";
  };
  puppet = {
    dependencies = ["facter" "fast_gettext" "hiera" "httpclient" "locale" "multi_json" "puppet-resource_api" "semantic_puppet"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmv8abx1pbc2ksm1f7k1fnz2a6zazdc3hsz8974jgahhqj4s9vk";
      type = "gem";
    };
    version = "6.0.0";
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
      sha256 = "1wyk2l440d96ps3x127r52n51kqpqi2nzb3xlg92qn6aksqhnkis";
      type = "gem";
    };
    version = "2.3.6";
  };
  puppet-resource_api = {
    dependencies = ["hocon"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ab0k2jgrc19igicsfdz7bw4h7kfw6lb52x8k752l2myz1k30dgy";
      type = "gem";
    };
    version = "1.5.0";
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
      sha256 = "00zlil6lw0hc9vy50ymn5v3jkym2lc459x0cph8057skf3nh41ab";
      type = "gem";
    };
    version = "2.10.0";
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
      sha256 = "15ppasvb9qrscwlyjz67ppw1lnxiqnkzx5vkx1bd8x5n3dhikxc3";
      type = "gem";
    };
    version = "3.8.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1s5bnbqp3sxk67y0fh0x884jjym527r0vgmhbm81w7aq6b7l4p";
      type = "gem";
    };
    version = "3.8.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vfqqcjmhdq25jrc8rd7nx4n8xid7s1ynv65ph06bk2xafn3rgll";
      type = "gem";
    };
    version = "3.8.1";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06y508cjqycb4yfhxmb3nxn0v9xqf17qbd46l1dh4xhncinr4fyp";
      type = "gem";
    };
    version = "3.8.0";
  };
  rspec-puppet = {
    dependencies = ["rspec"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wicvg769z5ndp0jj9c0cqkclswbw80rvg263p5wr194ssj1rz56";
      type = "gem";
    };
    version = "2.6.15";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p3m7drixrlhvj2zpc38b11x145bvm311x6f33jjcxmvcm0wq609";
      type = "gem";
    };
    version = "3.8.0";
  };
  safe_yaml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
      type = "gem";
    };
    version = "1.0.4";
  };
  semantic_puppet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "046m45rdwpvfz77s7bxid27c89w329c1nj593p74wdd8kknf0nv0";
      type = "gem";
    };
    version = "1.0.2";
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
      sha256 = "03994dxs4xayvkxqp01dd1ivhg4xxx7z35f7cxw7y2mwj3xn24ib";
      type = "gem";
    };
    version = "3.4.2";
  };
}