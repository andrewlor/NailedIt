class AttemptController < ApplicationController
	before_action :current_user, except: :get_video

	def new
		@record = Record.find(params[:record_id])
		@attempt = @attempt ? @attempt : Attempt.new
		current_holder = @record.current_holder

		if current_holder
			hasPendingAttempt = false
			@record.attempts.where(user_id: current_user.id).each do |attempt|
				if attempt.success.blank?
					hasPendingAttempt = true
				end
			end
			if hasPendingAttempt || User.find(current_holder.user_id).id == current_user.id

				redirect_back fallback_location: root_path
			end
		end

		redirect_back fallback_location: root_path unless (@record.init_attempt || @record.user_id == current_user.id)
	end

	def create
		result = create_helper(params)
		respond_to do |format|
			if result
				format.html { render nothing: true, status: 200 }
	     	format.json { render nothing: true, status: 200 }
			else
				format.html { render nothing: true, status: 500 }
	     	format.json { render nothing: true, status: 500 }
			end
		end
	end

	def create_helper(params)
		record = Record.find(params[:record_id])
		redirect_back fallback_location: root_path unless (record.init_attempt || record.user_id == current_user.id)

		attempt = Attempt.create(user_id: current_user.id, record_id: params[:record_id])

		attempt.video = VideoUploader.store_video(params[:file])

		if !attempt.valid?
			flash[:errors] = attempt.errors.full_messages
			flash.keep
			return false
		end

		if !record.init_attempt
			record.init_attempt = true
			record.save!
			attempt.success = true
		end

		attempt.save!

		return true
	end

	def get_video
		render json: {video: VideoUploader.read_video(Attempt.find(params[:id]).video)}
	end
end
