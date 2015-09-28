module Hello
  module PasswordModel
      extend ActiveSupport::Concern


      included do
        belongs_to :user, counter_cache: false
        validates_presence_of :user

        attr_reader :password
        validates_presence_of :password, on: :create
        # WIP: do you think we should validate such fields as well?
        # validates_presence_of :digest
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





  end
end