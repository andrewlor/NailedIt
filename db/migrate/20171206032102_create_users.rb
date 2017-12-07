class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
    	t.string :username
    	t.string :encrypted_password

      t.timestamps
    end

    change_table :records do |t|
    	t.belongs_to :user, index: true
    end
  end
end
