module Shortener
  mattr_accessor :url, :stubbed

  def self.code
    seed = Time.now.to_f.to_s
    Base64.urlsafe_encode64([Digest::MD5.hexdigest(seed).to_i(16)].pack("N")).sub(/==\n?$/, '')
  end

  def self.store(url_to_shorten, code)
    return URI.join(self.url, code).to_s if self.stubbed
    response = RestClient.post(self.url, :url => url_to_shorten, :code => code)
    response.headers[:location]
  end
end
