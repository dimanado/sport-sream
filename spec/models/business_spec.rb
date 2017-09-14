require "spec_helper"

describe Business do
  it "has valid factory" do
    expect( build(:business) ).to be_valid
  end
  it "has valid factory with credentials" do
    expect( build(:business, :credentials) ).to be_valid
  end

  describe "#distance_to_latlon" do
    it "should return distance in km" do
      subject.latitude = subject.longitude = 0
      expect(subject.distance_to_latlon(0, 1).floor).to eql(111)
    end
  end

  let(:with_credentials) { create(:business, :credentials) }
  let(:without_credentials) { create(:business) }

  describe "check credentials" do
    it "return true if business has credentials" do
      expect(with_credentials.has_twitter_credentials?).to be_true
      expect(with_credentials.has_facebook_credentials?).to be_true
    end

    it "false if business not has credentials" do
      expect(without_credentials.has_twitter_credentials?).to be_false
      expect(without_credentials.has_facebook_credentials?).to be_false
    end
  end

  describe "reset credentials" do
    it "#reset_facebook_credentials" do
      with_credentials.reset_facebook_credentials
      expect(with_credentials.facebook_access_token).to be_nil
      expect(with_credentials.facebook_page_access_token).to be_nil
    end
    it "#reset_twitter_credentials" do
      with_credentials.reset_twitter_credentials
      expect(with_credentials.access_token).to be_nil
      expect(with_credentials.secret_token).to be_nil
    end
  end

  describe "assigns facebook page identifier" do
    context "nil argument" do
      it "not change state" do
        expect{ with_credentials.facebook_page_identifier = nil }.to_not change{ with_credentials.facebook_page_identifier }
      end
    end
    context "invalid argument" do
      it "not change state" do
        expect{ with_credentials.facebook_page_identifier = "1337" }.to_not change{ with_credentials.facebook_page_identifier }
      end
    end
    context "valid argument" do
      it "change state" do
        @business = with_credentials
        @valid_account = @business.facebook_user.accounts.find{ |a| a.identifier != @business.facebook_page_identifier }
        @business.facebook_page_identifier = @valid_account.identifier
        expect(@business.facebook_page_identifier).to eq @valid_account.identifier
      end
    end
  end

  describe "facebook objects" do
      it "return facebook client object with inserted uri" do
        pending('fix')
        @facebook_client = with_credentials.facebook_client('http://weeee.com')
        expect(@facebook_client.redirect_uri).to eq 'http://weeee.com'
      end

    context "with credentials" do

      it "return facebook user object" do
        expect(with_credentials.facebook_user).to be_a(FbGraph::User)
      end

      it "return facebook page object" do
        expect(with_credentials.facebook_page).to be_a(FbGraph::Page)
      end
    end

    context "without credentials" do

      it "raise error on facebook user request" do
        expect{ without_credentials.facebook_user }.to raise_error(FbGraph::InvalidRequest)
      end

      it "raise error on facebook page request" do
        expect{ without_credentials.facebook_page }.to raise_error(FbGraph::InvalidRequest)
      end
    end
  end

  describe "facebook authorization check" do
    context "with credentials" do
      it "return true when authorized" do
        expect(with_credentials.facebook_client_authorized?).to be_true
      end
    end
    context "without credentials" do
      it "return false when not authorized" do
        expect(without_credentials.facebook_client_authorized?).to be_false
      end
    end
  end

end
