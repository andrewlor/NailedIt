class Record < ApplicationRecord
	belongs_to :user
	has_many :attempts

	validates :user_id, :presence => true
end
