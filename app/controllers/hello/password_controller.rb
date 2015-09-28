module Hello
  class PasswordController < ApplicationController

    kick :guest, :novice
    sudo_mode

    before_action do
      @password = current_user.passwords.first || raise(ActiveRecord::NotFound)
      @entity = UpdateMyUserEntity.new(@password)
    end



    # GET /hello/password
    def edit
      respond_to do |format|
        format.html {  }
        format.json { head :no_content }
      end
    end

    # PATCH /hello/password
    def update
      @password.password = password_params[:password]
      # @password.password_confirmation = password_params[:password_confirmation] if password_params[:password_confirmation]

      if @password.save
        flash[:notice] = @entity.success_message
        respond_to do |format|
          format.html { redirect_to hello.password_path }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @password.errors, status: :unprocessable_entity }
        end
      end
    end



    private

    def password_params
      params.require(:password)
    end

  end
end
