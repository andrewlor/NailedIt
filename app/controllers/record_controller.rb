class RecordController < ApplicationController
	before_action :current_user

	def index
		@records = Record.where(init_attempt: true).reverse_order
	end

	def new
	end

	def create
		record = Record.create(title: params[:title], description: params[:desc], user_id: current_user.id)
		if record.errors.any?
			flash[:errors] = record.errors.full_messages
			redirect_to '/record/new'
			return
		end
		redirect_to '/record/' + record.id.to_s
	end

	def show
		@record = Record.find(params[:id])
		current_holder = @record.current_holder
		@current_holder_id = current_holder ? current_holder.id : -1
		redirect_back fallback_location: root_path unless (@record.init_attempt || @record.user_id == current_user.id)
	end
end
