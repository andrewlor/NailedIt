class CreateAttempts < ActiveRecord::Migration[5.0]
  def change
    create_table :attempts do |t|
    	t.belongs_to :users, index: true
    	t.belongs_to :record, index: true
    	t.boolean :success

      t.timestamps
    end
  end
end
