class AttemptController < ApplicationController
	before_action :current_user

	def new
		@record = Record.find(params[:record_id])
		redirect_back fallback_location: root_path unless (@record.init_attempt || @record.user_id == current_user.id)
	end

	def create
		record = Record.find(params[:record_id])
		redirect_back fallback_location: root_path unless (record.init_attempt || record.user_id == current_user.id)
		attempt = Attempt.create(user_id: current_user.id, record_id: params[:record_id])
		
		if !record.init_attempt
			record.init_attempt = true
			record.save!
			attempt.success = true
		end

		attempt.save!

		redirect_to '/record/' + params[:record_id]
	end
end
