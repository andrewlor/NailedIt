class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
  	if session[:user_id]
  		@current_user = User.find(session[:user_id])
  	else
  		redirect_to '/signup'
  	end
  end

  def logout
  	session[:user_id] = nil
  	redirect_to '/signup'
  end

  def login_action
  	@user = User.find_by(username: params[:username])
    redirect_to '/signup' && return unless @user
  	if BCrypt::Password.new(@user.encrypted_password) == params[:password]
  		session[:user_id] = @user.id
  		redirect_to '/'
  	else
  		redirect_to '/signup' # change to render so we can see validation errors in view
  	end
  end
end
