class RecordController < ApplicationController
	before_action :current_user

	def index
		@records = Record.where(init_attempt: true).reverse_order
	end

	def new
	end

	def create
		record = Record.create!(title: params[:title], description: params[:desc], user_id: current_user.id)
		redirect_to '/record/' + record.id.to_s
	end

	def show
		@record = Record.find(params[:id])
		redirect_back fallback_location: root_path unless (@record.init_attempt || @record.user_id == current_user.id)
	end
end
