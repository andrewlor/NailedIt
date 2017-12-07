class AttemptController < ApplicationController
	before_action :current_user

	def new
		@record = Record.find(params[:record_id])
	end

	def create
		Attempt.create!(user_id: current_user.id, record_id: params[:record_id])
		redirect_to '/record/' + params[:record_id]
	end
end
