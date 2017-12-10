class Record < ApplicationRecord
	belongs_to :user
	has_many :attempts

	validates :user_id, :presence => true

	def current_holder # returns the most recent successful attempt
		self.attempts.where(success: true).order('created_at').last
	end
end
