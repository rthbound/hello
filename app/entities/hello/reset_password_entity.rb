module Hello
  class ResetPasswordEntity < AbstractEntity

    attr_reader :password

    def initialize(unencrypted_token=nil)
      if unencrypted_token
        @password = find_password(unencrypted_token)
      end
    end

    def update_password(plain_text_password)
      simply_update_password(plain_text_password)
      @password.invalidate_password_token
    end

    def user
      password.user
    end

    private

        # initialize helpers

        def find_password(unencrypted_token)
          digest = Token.encrypt(unencrypted_token)
          Password.where(reset_token_digest: digest).first
        end

        # update password helpers

        def simply_update_password(password)
          @password.password = password
          merge_errors_to_self and return false unless @password.save
          return true
        end

            def merge_errors_to_self
              hash = @password.errors.to_hash
              hash.each { |k,v| v.each { |v1| errors.add(k, v1) } }
            end

  end
end
