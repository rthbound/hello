module Hello
  class RegistrationMailer < ActionMailer::Base
    default from: Hello.configuration.mailer_sender

    def welcome(credential, password)
      @credential = credential
      @user       = credential.user
      @password   = password

      mail to: credential.email
    end

    def confirm_email(credential, url)
      @credential = credential
      @user       = credential.user
      @url        = url

      mail to: credential.email
    end

    def forgot_password(credential, url)
      @credential = credential
      @user       = credential.user
      @url        = url

      mail to: credential.email
    end

  end
end
