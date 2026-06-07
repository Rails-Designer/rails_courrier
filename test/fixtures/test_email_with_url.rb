require "courrier/email"

class TestEmailWithUrl < Courrier::Email
  def subject = "Email with URL"

  def text = "Click here: #{default_url_options[:host]}"
end
