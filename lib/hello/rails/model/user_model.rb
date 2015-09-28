require "hello/rails/model/user_model_username"
require "hello/rails/model/user_model_roles"

module Hello
  module UserModel
    extend ActiveSupport::Concern

    included do
      has_many :credentials,       dependent: :destroy
      has_many :email_credentials, dependent: :destroy
      has_many :password_credentials, dependent: :destroy # WIP TODO: if this PR is chosen, review all places that use user.credentials_count}
      has_many :access_tokens,     dependent: :destroy

      validates_presence_of :name, :locale, :time_zone
      validates_inclusion_of :locale,    in: Hello.available_locales
      validates_inclusion_of :time_zone, in: Hello.available_time_zones

      include UserModelUsername
      include UserModelRoles
    end

    # NOTE:
    # dup your changes on lib/generators/hello/install/templates/user.rb
    def to_json_web_api
      attributes.reject { |k, v| k.include?("password") }
    end

    def destroy
      # In Rails 4.0
      # 'this instance' and the 'user in the credential instance'
      # are 2 separate instances, making it impossible for them to share state
      # therefore, an instance variable used as a flag will not work for Rails 4.0
      # It will however, work for Rails 4.1 and 4.2
      # @hello_is_this_being_destroyed = true 
      Thread.current["Hello.destroying_user"] = true
      super
    end

    # def hello_is_this_being_destroyed?
    #   !!@hello_is_this_being_destroyed
    # end








    module ClassMethods

      def hello_apply_config!
        Hello.configuration.tap do |c|
          PasswordCredential.hello_apply_config!
          validates_format_of :username, with: c.username_regex
          validates_length_of :username,
                                   in: c.username_length,
                                   too_long:  'maximum of %{count} characters',
                                   too_short: 'minimum of %{count} characters'
        end
      end
    end

  end
end