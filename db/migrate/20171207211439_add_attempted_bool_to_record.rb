class AddAttemptedBoolToRecord < ActiveRecord::Migration[5.0]
  def change
  	change_table :records do |t|
  		t.boolean :init_attempt, default: false
  	end
  end
end
