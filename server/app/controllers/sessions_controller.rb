require 'date'

# REF http://blog.baugues.com/google-calendar-api-oauth2-and-ruby-on-rails
class SessionsController < ApplicationController
  
  def create
    #What data comes back from OmniAuth?
    @auth = request.env["omniauth.auth"]
    #Use the token from the data to request a list of calendars
    @token = @auth["credentials"]["token"]
    email = @auth["uid"]

    ape = MonkeyCredential.where(email: email).first

    if ape
      ape.update_attributes(email: email, token: @token)
    else
      MonkeyCredential.create(email: email, token: @token)
    end

  end
end
