require "test_helper"

class TestEmailWithI18n < Courrier::Email
  def subject = t(".subject")
end

class Courrier::Email::TranslationTest < Minitest::Test
  def setup
    @email = TestEmailWithI18n.new(from: "sender@example.com", to: "recipient@example.com")
  end

  def test_translates_dotted_key_with_scope
    captured_key = nil

    I18n.stub :t, ->(key, **) {
      captured_key = key
      key
    } do
      @email.send(:t, ".subject")
    end

    assert_equal "courrier.email.test_email_with_i18n.subject", captured_key
  end

  def test_passes_through_full_keys
    captured_key = nil

    I18n.stub :t, ->(key, **) {
      captured_key = key
      key
    } do
      @email.send(:t, "shared.greeting")
    end

    assert_equal "shared.greeting", captured_key
  end

  def test_forwards_options_to_i18n
    captured_options = nil

    I18n.stub :t, ->(key, **options) {
      captured_options = options
      key
    } do
      @email.send(:t, ".subject", name: "Jane")
    end

    assert_equal({name: "Jane"}, captured_options)
  end

  def test_i18n_scope_uses_underscored_class_name
    assert_equal "courrier.email.test_email_with_i18n", @email.send(:i18n_scope)
  end
end
