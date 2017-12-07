class UserController < ApplicationController
	before_action :current_user, except: [:new, :create]

	def index
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(username: params[:user][:username], password: params[:user][:password])
    if @user.save
    	session[:user_id] = @user.id
      redirect_to '/'
    else
      render 'new'
    end
	end
end
