require "courrier/email"

class TestEmail < Courrier::Email
  def subject = "Test Subject"

  def html = "<p>Test HTML Body</p>"

  def text = "Test Body"
end
