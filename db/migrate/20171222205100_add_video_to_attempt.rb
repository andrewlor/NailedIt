class AddVideoToAttempt < ActiveRecord::Migration[5.0]
  def change
  	change_table :attempts do |t|
  		t.string :video
  	end
  end
end
