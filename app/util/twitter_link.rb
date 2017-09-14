class TwitterLink
CONSUMER_KEY = ENV['TWITTER_CONSUMER_KEY']
CONSUMER_SECRET = ENV['TWITTER_CONSUMER_SECRET']
  OPTIONS = {
    :site => "https://api.twitter.com",
    :request_endpoint => "https://api.twitter.com"
  }

  attr_reader :access_token

  def self.request_token (callback)
    client = auth_consumer
    client.get_request_token(:oauth_callback => callback)
  end

  def initialize (token, secret, verifier)
    @client = self.class.auth_consumer
    begin
      @access_token = attemt_to_authorize(token, secret, verifier)
      @authorized = true
    rescue OAuth::Unauthorized
      p 'failed to authorize'
      @authorized = false
    end
  end

  def authorized?
    @authorized || false
  end

  private

  def attemt_to_authorize (token, secret, verifier)
    OAuth::RequestToken.new(@client, token, secret)
                       .get_access_token(:oauth_verifier => verifier)
  end

  def self.auth_consumer
    @consumer ||= OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, OPTIONS)
  end

end
