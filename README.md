# Rails Courrier

Rails-specific features for [Courrier](https://github.com/Rails-Designer/courrier), the API-powered email delivery gem for Ruby.

![Preview of the Rails Courrier inbox with a list of images on the left and preview of an email on the right](https://raw.githubusercontent.com/Rails-Designer/rails_courrier/HEAD/.github/rails_courrier_inbox.jpg)


<a href="https://railsdesigner.com/" target="_blank">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Rails-Designer/courrier/HEAD/.github/logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Rails-Designer/courrier/HEAD/.github/logo-light.svg">
    <img alt="Rails Designer logo" src="https://raw.githubusercontent.com/Rails-Designer/courrier/HEAD/.github/logo-light.svg" width="240" style="max-width: 100%;">
  </picture>
</a>

**Sponsored By [Rails Designer](https://railsdesigner.com/)**


## Installation

Add to your Gemfile:
```bash
bundle add rails_courrier
```


## Setup

Generate the initializer:
```bash
bin/rails generate courrier:install
```

This creates `config/initializers/courrier.rb`.

Generate an email:
```bash
bin/rails generate courrier:email Order
```

This creates `app/emails/order_email.rb`.

Mount the engine for inbox previews:
```ruby
# config/routes.rb
mount Courrier::Engine => "/courrier"
```


## Usage

### Send emails

```ruby
OrderEmail.deliver to: "recipient@railsdesigner.com"
```


### Deliver later via ActiveJob

```ruby
OrderEmail.deliver_later to: "recipient@railsdesigner.com"
```

Configure queue options in the email class:
```ruby
class OrderEmail < Courrier::Email
  enqueue queue: "emails", wait: 5.minutes

  def subject = "Your order is ready!"
  # …
end
```


### Inbox provider

Preview emails in your browser:
```ruby
# config/initializers/courrier.rb
Courrier.configure do |config|
  config.email = { provider: "inbox" }
end
```

Enable auto-open:

```ruby
config.email = { provider: "inbox" }
config.inbox.auto_open = true
```

Clear inbox files:

```bash
bin/rails courrier:clear
```


### URL helpers

Rails Courrier automatically includes Rails URL helpers in your email classes:
```ruby
class OrderEmail < Courrier::Email
  def text
    "View your order: #{order_url(token: "abc123")}"
  end
end
```


## Documentation

See the [Courrier README](https://github.com/Rails-Designer/courrier) for full configuration, providers, layouts, templates and more.


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `rake` before submitting pull requests.


## License

Courrier is released under the [MIT License](https://opensource.org/licenses/MIT).
