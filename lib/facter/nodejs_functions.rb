class Version < Array
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


# Ideas from http://puppetlabs.com/blog/facter-part-3-caching-and-ttl
def get_cached_value(key, ttl=86400, dir = '/tmp/puppetfacts/nodejs', file = 'cache.yaml')
  cache_file = File.join(dir, file)

  if File::exist?(cache_file)    
    cache = YAML.load_file(cache_file)
    value = cache[key]
    cache_time = File.mtime(cache_file)
  else
    value = nil
    cache_time = Time.at(0)
  end

  if !value || (Time.now - cache_time) > ttl then
    nil
  else
    value
  end
end


def set_cached_value(key, value, dir = '/tmp/puppetfacts/nodejs', file = 'cache.yaml')
  FileUtils.mkdir_p(dir) if !File::exists?(dir)
  cache_file = File.join(dir, file)  
  
  cache = File::exist?(cache_file) ? YAML.load_file(cache_file) : Hash.new
  cache[key] = value

  File.open(cache_file, 'w') do |out|
    YAML.dump(cache, out)
  end
end


# inspired by https://github.com/visionmedia/n/blob/5630984059fb58f47def8dca2f25163456181ed3/bin/n#L363-L372
def get_latest_version
  uri = URI('http://nodejs.org/dist/')
  res = Net::HTTP.get(uri)
  match = res.scan(/[0-9]+\.[0-9]+\.[0-9]+/);
  match.sort! { |a,b| Version.new(a) <=> Version.new(b) }
  'v' + match.last
end


def get_stable_version
  uri = URI('http://nodejs.org/dist/')
  res = Net::HTTP.get(uri)
  match = res.scan(/[0-9]+\.[0-9]*[02468]\.[0-9]+/);
  match.sort! { |a,b| Version.new(a) <=> Version.new(b) }
  'v' + match.last
end
