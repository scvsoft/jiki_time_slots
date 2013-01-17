require 'date'

# REF http://blog.baugues.com/google-calendar-api-oauth2-and-ruby-on-rails
class SessionsController < ApplicationController

  def create
    #What data comes back from OmniAuth?
    auth = request.env["omniauth.auth"]
    #Use the token from the data to request a list of calendars
    token = auth["credentials"]["token"]
    refresh_token = auth["credentials"]["refresh_token"]
    email = auth["uid"]

    ape = MonkeyCredential.where(email: email).first

    attrs = {
      email: email,
      token: token,
      refresh_token: refresh_token
    }

    if ape
      ape.update_attributes(attrs)
    else
      MonkeyCredential.create(attrs)
    end

  end
end
