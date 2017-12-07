class User < ApplicationRecord
	has_many :records
	has_many :attempts

	before_save :encrypt_password
	after_save :clear_password

	attr_accessor :password # password accessor

  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates_length_of :password, :in => 6..20, :on => :create

	def encrypt_password # on save we take the password from the input, encrypt, then store in db
	  if password.present?
	    self.salt = BCrypt::Engine.generate_salt
	    self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
	  end
	end

	def clear_password # after save we clear the password field
	  self.password = nil
	end
end
