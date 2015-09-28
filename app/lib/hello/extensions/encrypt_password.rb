# Learn more at config/initializers/hello.rb
#
module Hello
  module Extensions
    module EncryptPassword

      def self.encrypt(plain_text)
        BCrypt::Password.create(plain_text)
      end

      def self.check(password_model, plain_text)
        BCrypt::Password.new(password_model.digest) == plain_text 
      rescue BCrypt::Errors::InvalidHash
        false
      end

    end
  end
end
