class FailureApp < Devise::FailureApp
  def redirect_url
    return super
   # return super unless [:partner].include?(scope) #make it specific to a scope
   # new_partner_session_path
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
