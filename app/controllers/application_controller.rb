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
  	user = User.find_by(username: params[:username])
    if !user
      login_error && return
    end
  	if BCrypt::Password.new(user.encrypted_password) == params[:password]
  		session[:user_id] = user.id
  		redirect_to '/'
  	else
  		login_error && return
  	end
  end

  private

  def login_error
    flash[:errors] = ['Invalid Username/Password']
    redirect_to '/signup'
  end
end
