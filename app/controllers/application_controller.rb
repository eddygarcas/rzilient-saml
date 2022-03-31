class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection


  def idp_login
    email = params[:email]
    if (user = user.find_by_email(email))
      @idps = user.identity_providers
    end
  end
end
