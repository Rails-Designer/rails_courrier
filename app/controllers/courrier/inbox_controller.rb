# frozen_string_literal: true

module Courrier
  class InboxController < PreviewsController
    def index
      @show_clear = true

      @emails = Dir.glob("#{Courrier.configuration.inbox.destination}/*.html")
        .sort_by { -File.basename(it, ".html").to_i }
        .map do |path|
          email = Courrier::Email::Providers::Inbox::Email.from_file(path)

          Courrier::Preview::Email.new(
            primary: email.metadata.to,
            secondary: email.metadata.subject || "No subject",
            link: courrier.inbox_path(email.filename),
            scenarios: nil
          )
        end

      # render "courrier/previews/index"
    end

    def show
      file_path = File.join(Courrier.configuration.inbox.destination, params[:id])
      email = Courrier::Email::Providers::Inbox::Email.from_file(file_path)

      @email = Courrier::Preview::Result.new(
        email_class: nil,
        scenario: nil,
        subject: email.metadata.subject,
        html: File.read(file_path),
        text: nil,
        from: nil,
        to: email.metadata.to
      )

      # render "courrier/previews/show"
    end

    def create
      system("bin/rails courrier:clear")

      redirect_to root_path
    end
  end
end
