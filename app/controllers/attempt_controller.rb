class AttemptController < ApplicationController
	before_action :current_user

	def new
		@record = Record.find(params[:record_id])

		current_holder = @record.current_holder

		if current_holder
			hasPendingAttempt = false
			@record.attempts.where(user_id: current_user.id).each do |attempt|
				if attempt.success.blank?
					hasPendingAttempt = true
				end
			end
			if hasPendingAttempt || User.find(current_holder.user_id).id == current_user.id; redirect_back fallback_location: root_path end
		end

		redirect_back fallback_location: root_path unless (@record.init_attempt || @record.user_id == current_user.id)
	end

	def create
		record = Record.find(params[:record_id])
		redirect_back fallback_location: root_path unless (record.init_attempt || record.user_id == current_user.id)

		attempt = Attempt.create(user_id: current_user.id, record_id: params[:record_id])

		attempt.video = VideoUploader.store_video(attempt.id, params[:video_string])
		
		if !record.init_attempt
			record.init_attempt = true
			record.save!
			attempt.success = true
		end

		attempt.save!

		redirect_to '/record/' + record.id.to_s
	end
end
