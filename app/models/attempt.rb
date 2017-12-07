class Attempt < ApplicationRecord
	belongs_to :user
	belongs_to :record

	validates :user_id, :presence => true
	validates :record_id, :presence => true
end
