require 'net/http'

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

# inspired by https://github.com/visionmedia/n/blob/5630984059fb58f47def8dca2f25163456181ed3/bin/n#L363-L372
Facter.add("nodejs_latest_version") do
  setcode do
    uri = URI('http://nodejs.org/dist/')
    res = Net::HTTP.get(uri)
    match = res.scan(/[0-9]+\.[0-9]+\.[0-9]+/);
    match.sort! { |a,b| Version.new(a) <=> Version.new(b) }
    'v' + match.last
  end
end
