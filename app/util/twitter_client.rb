class TwitterClient
  def initialize (token, secret, secure = false)
    configure token, secret
    begin
      @client.verify_credentials
      @authorized = true
    rescue Twitter::Error::TooManyRequests
      @authorized = false
      raise if secure
    rescue Twitter::Error => e
      puts e.inspect
    end
  end

  def authorized?
    @authorized ||= false
  end

  def screen_name
    return 'Unauthorized' unless authorized?
    begin
      @screen_name = @client.current_user.screen_name
    rescue Twitter::Error => e
      puts "Twitter access exception: #{e.inspect}"
      @screen_name = 'Rate Limit Exceeded'
    end
  end

  def update (status)
    return unless authorized?
    @client.update(status)
  end

  def raw_client
    @client
  end

  private

  def configure (token, secret)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = TwitterLink::CONSUMER_KEY
      config.consumer_secret     = TwitterLink::CONSUMER_SECRET
      config.access_token        = token
      config.access_token_secret = secret
    end
  end
end
