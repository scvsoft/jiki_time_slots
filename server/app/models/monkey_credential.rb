class MonkeyCredential < ActiveRecord::Base
  attr_accessible :email, :token, :refresh_token

  def calendar
    Calendar.new(self)
  end
end
