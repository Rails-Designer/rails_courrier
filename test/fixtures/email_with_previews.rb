# frozen_string_literal: true

require "courrier/email"

class EmailWithPreviews < Courrier::Email
  def subject
    "Hello, #{name}"
  end

  def html
    "<h1>Hello #{name}</h1>"
  end

  preview :default, to: "recipient@example.com", from: "sender@example.com", name: "John"
  preview :with_code, to: "recipient@example.com", from: "sender@example.com", name: "Jane", code: "SECRET"
  preview :dynamic do
    {to: "dynamic@example.com", from: "sender@example.com", name: "Dynamic-#{rand(100)}"}
  end
end
