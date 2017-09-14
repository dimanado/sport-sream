require 'spec_helper'

describe "Social sharing" do
  # TODO: Mock twitter\facebook clients
  it "#share in facebook" do
    @business = FactoryGirl.create(:business, :credentials)
    facebook_client = Koala::Facebook::GraphAPI.new(@business.facebook_page_access_token)
    expect(facebook_client).to be_an(Koala::Facebook::GraphAPI)
    # stub valid response
    allow(facebook_client).to receive(:put_wall_post).with("TESTING").and_return({"id"=>"709445139101831_710920812287597"})
    post_id = facebook_client.put_wall_post( "TESTING" )
    expect(post_id['id']).to_not be_nil
  end

  it "#share in twitter" do
    @business = FactoryGirl.create(:business, :credentials)
    twitter_client = TwitterClient.new(@business.access_token, @business.secret_token)
    # stub valid response
    allow(twitter_client).to receive(:update).with('test').and_return(Twitter::Tweet.new(id: '464298762350100480'))
    # Twitter::Tweet id=464298762350100480
    tweet_id = twitter_client.update( 'test' )
    expect(tweet_id[:id]).to_not be_nil
  end
end