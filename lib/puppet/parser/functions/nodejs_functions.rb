require 'json'

class NodeVersion < Array
  def initialize s
    super(s.split('.').map { |e| e.to_i })
  end
  def < x
    (self <=> x) < 0
  end
  def > x
    (self <=> x) > 0
  end
  def == x
    (self <=> x) == 0
  end
end

class NodeJSListStore
  @@list = nil
  def self.set_list(list)
    @@list = list
  end
  def self.is_cached
    @@list.nil? == false
  end
  def self.get_list
    return @@list
  end
end

# inspired by https://github.com/visionmedia/n/blob/5630984059fb58f47def8dca2f25163456181ed3/bin/n#L363-L372
def get_version_list
  if NodeJSListStore::is_cached
    return NodeJSListStore::get_list
  end

  uri = URI('https://nodejs.org/dist/index.json')

  http_proxy = ENV["http_proxy"]
  if http_proxy.to_s != ''
    if http_proxy =~ /^http[s]{0,1}:\/\/.*/
      proxy = URI.parse(http_proxy)
    else
      proxy = URI.parse('http://' + http_proxy)
    end
    request = Net::HTTP::Proxy(proxy.host, proxy.port).new(uri.host, uri.port)
  else
    request = Net::HTTP.new(uri.host, uri.port)
  end
  request.use_ssl = (uri.scheme == 'https')
  request.open_timeout = 2
  request.read_timeout = 2

  result = JSON.parse(request.get(uri.request_uri).body)
  NodeJSListStore::set_list(result)

  return result
end

def get_latest_version
  version_data = get_version_list.map { |o| o['version'].gsub(/^v/, '') }
  version_data.sort! { |a,b| NodeVersion.new(a) <=> NodeVersion.new(b) };
  'v' + version_data.last
end

