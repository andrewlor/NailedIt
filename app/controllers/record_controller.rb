class RecordController < ApplicationController
	before_action :current_user

	def index
		@records = Record.limit(10)
	end

	def new
	end

	def create
		Record.create!(title: params[:title], description: params[:desc], user_id: current_user.id)
		redirect_to '/record'
	end
end
