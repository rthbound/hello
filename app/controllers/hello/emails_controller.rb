require_dependency "hello/application_controller"

#
# IT IS RECOMMENDED THAT YOU DO NOT OVERRIDE THIS FILE IN YOUR APP
#

module Hello
  class EmailsController < ApplicationController
    
    helper_method :credentials

    restrict_to_users
    
    before_actions do
      all { restrict_access_to_sudo_mode }
      only(:index)  { @credential = Credential.new }
      only(:create) { @credential = hello_user.credentials.classic.build(credential_params) }
      only(:destroy, :deliver)  { @credential = hello_user.credentials.classic.find(params[:id]) }
    end

    # GET /hello/emails
    def index
    end

    # POST /hello/emails
    def create
      if @credential.save
        redirect_to hello.emails_path, notice: "Your email was successfully added."
      else
        render action: :index
      end
    end

    # DELETE /hello/emails/1
    def destroy
      if @credential.destroy
        redirect_to hello.emails_path, notice: "Your email was successfully removed."
      else
        render action: :index
      end
    end

    # POST /hello/emails/1/deliver
    def deliver
      entity = SendConfirmationEmailEntity.new(self, @credential)
      entity.deliver
      flash[:notice] = entity.success_message
      redirect_to hello.emails_path
    end




    private

      # Only allow a trusted parameter "white list" through.
      def credential_params
        params.require(:credential).permit(:email)
      end

      def credentials
        hello_user.credentials.classic
      end

  end

end
