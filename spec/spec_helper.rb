require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'webmock/rspec'
require 'rspec'

WebMock.disable_net_connect!()

nodejs_response = <<HTML
<html>
<head><title>Index of /dist/</title></head>
<body bgcolor="white">
<h1>Index of /dist/</h1><hr><pre><a href="../">../</a>
<a href="latest/">latest/</a>                                            06-Feb-2015 22:03                   -
<a href="nightlies/">nightlies/</a>                                         07-Aug-2014 17:11                   -
<a href="npm/">npm/</a>                                               23-May-2014 16:55                   -
<a href="patch/">patch/</a>                                             30-Jul-2014 23:02                   -
<a href="v0.10.14/">v0.10.14/</a>                                          12-Aug-2013 20:37                   -
<a href="v0.11.10/">v0.11.10/</a>                                          21-Jan-2014 19:19                   -
<a href="v0.11.11/">v0.11.11/</a>                                          11-Apr-2014 20:49                   -
<a href="v0.11.12/">v0.11.12/</a>                                          11-Apr-2014 21:06                   -
<a href="v0.11.13/">v0.11.13/</a>                                          02-May-2014 14:53                   -
<a href="v0.11.14/">v0.11.14/</a>                                          16-Jan-2015 16:37                   -
<a href="v0.11.15/">v0.11.15/</a>                                          20-Jan-2015 23:42                   -
<a href="v0.11.16/">v0.11.16/</a>                                          30-Jan-2015 17:05                   -
<a href="v0.11.2/">v0.11.2/</a>                                           15-May-2013 18:29                   -
<a href="v0.11.3/">v0.11.3/</a>                                           27-Jun-2013 00:26                   -
<a href="v0.11.4/">v0.11.4/</a>                                           13-Jul-2013 19:50                   -
<a href="v0.11.5/">v0.11.5/</a>                                           12-Aug-2013 21:07                   -
</pre><hr></body>
</html>
HTML


RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, "http://nodejs.org/dist/").
         to_return(:status => 200, :body => nodejs_response, :headers => {})
  end
end

$:.unshift File.join(File.dirname(__FILE__),  'fixtures', 'modules', 'stdlib', 'lib')
