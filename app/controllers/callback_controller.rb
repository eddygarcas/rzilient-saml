# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery with: :exception, except: :saml

  def saml
    auth_hash = request.env["omniauth.auth"]
    @user = User.find_by_email(email: auth_hash[:uid])
    render json: Warden::JWTAuth::UserEncoder.new.call(@user, :client, nil), status: :ok
  end
end
