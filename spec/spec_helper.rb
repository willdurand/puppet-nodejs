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
<a href="v5.0.0/">v5.0.0/</a>                                            29-Oct-2015 21:04                   -
<a href="v5.1.0/">v5.1.0/</a>                                            18-Nov-2015 14:35                   -
<a href="v5.1.1/">v5.1.1/</a>                                            04-Dec-2015 02:38                   -
<a href="v5.10.0/">v5.10.0/</a>                                           01-Apr-2016 03:24                   -
<a href="v5.10.1/">v5.10.1/</a>                                           05-Apr-2016 23:31                   -
<a href="v5.11.0/">v5.11.0/</a>                                           21-Apr-2016 20:35                   -
<a href="v5.11.1/">v5.11.1/</a>                                           05-May-2016 22:56                   -
<a href="v5.2.0/">v5.2.0/</a>                                            09-Dec-2015 05:24                   -
<a href="v5.3.0/">v5.3.0/</a>                                            16-Dec-2015 20:05                   -
<a href="v5.4.0/">v5.4.0/</a>                                            06-Jan-2016 22:39                   -
<a href="v5.4.1/">v5.4.1/</a>                                            12-Jan-2016 23:45                   -
<a href="v5.5.0/">v5.5.0/</a>                                            21-Jan-2016 02:25                   -
<a href="v5.6.0/">v5.6.0/</a>                                            10-Feb-2016 14:20                   -
<a href="v5.7.0/">v5.7.0/</a>                                            23-Feb-2016 05:36                   -
<a href="v5.7.1/">v5.7.1/</a>                                            02-Mar-2016 23:22                   -
<a href="v5.8.0/">v5.8.0/</a>                                            09-Mar-2016 15:38                   -
<a href="v5.9.0/">v5.9.0/</a>                                            16-Mar-2016 21:33                   -
<a href="v5.9.1/">v5.9.1/</a>                                            23-Mar-2016 17:36                   -
<a href="v6.0.0/">v6.0.0/</a>                                            27-Apr-2016 05:14                   -
<a href="v6.1.0/">v6.1.0/</a>                                            06-May-2016 15:01                   -
</pre><hr></body>
</html>
HTML


RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, "http://nodejs.org/dist/")
      .to_return(:status => 200, :body => nodejs_response, :headers => {})
  end
end

$:.unshift File.join(File.dirname(__FILE__),  'fixtures', 'modules', 'stdlib', 'lib')
