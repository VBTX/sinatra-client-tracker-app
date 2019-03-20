class CreateClientsTable < ActiveRecord::Migration
  def change
  	 create_table :clients do |t|
     t.string :business_name
     t.text :address
     t.string :email
     t.string :website
     t.text :projects
     t.integer :user_id
     t.timestamps null: false
    end
  end
end
