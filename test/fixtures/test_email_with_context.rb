require "courrier/email"

class TestEmailWithContext < Courrier::Email
  def subject = "Order #{order_id}"

  def text = "Test order #{order_id} with token #{token}"
end
