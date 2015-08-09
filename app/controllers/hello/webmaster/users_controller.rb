require_dependency "hello/application_controller"

module Hello
  class Webmaster::UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    dont_kick :webmaster
    
    # GET /users
    def index
      @users = User.all
    end

    # GET /users/1
    def show
    end

    # GET /users/new
    def new
      @user = User.new
    end

    # GET /users/1/edit
    def edit
    end

    # POST /users
    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /users/1
    def destroy
      if @user.destroy
        redirect_to users_url, notice: 'User was successfully destroyed.'
      else
        render :edit
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:username, :name, :role, :locale, :time_zone)
      end
  end
end
