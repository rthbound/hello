module Hello
  module PasswordCredentialModel
      extend ActiveSupport::Concern


      included do
        attr_reader :password
        validates_presence_of :password, on: :create
        # WIP: do you think we should validate such fields as well?
        # validates_presence_of :digest

        before_destroy :cannot_destroy_last_password_credential
      end

      module ClassMethods

        def hello_apply_config!
          Hello.configuration.tap do |c|
            validates_length_of  :password,
                                      in: c.password_length,
                                      too_long:  'maximum of %{count} characters',
                                      too_short: 'minimum of %{count} characters',
                                      if: :digest_changed?
            end
        end

      end

      def password=(value)
        # puts "password=('#{value}')".blue
        if value.blank?
          self.digest = @password = nil
        end
        value = value.to_s.gsub(' ', '')
        @password = value
        
        self.digest = password_encryption_extension.encrypt(value)
      end

      def password_is?(plain_text_password)
        password_encryption_extension.check(self, plain_text_password)
      end

      def password_encryption_extension
        Hello.configuration.extensions.encrypt_password
      end





      def reset_password_token
        uuid, digest = Token.pair
        update(reset_token_digest: digest, reset_token_digested_at: 1.second.ago)
        return uuid
      end

      def invalidate_password_token
        update(reset_token_digest: nil, reset_token_digested_at: nil)
      end

    private

    # TODO: this is actually never tested anywhere :)
    def cannot_destroy_last_password_credential
      return if hello_is_user_being_destroyed?
      return if not is_last_password_credential?
      errors[:base] << "must have at least one credential"
      false
    end

    def is_last_password_credential?
      user.password_credentials.count == 1
    end



  end
end