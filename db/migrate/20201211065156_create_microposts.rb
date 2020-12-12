class CreateMicroposts < ActiveRecord::Migration[6.0]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    # By including both the user_id and created_at columns as an array, we
    # arrange for Rails to create a multiple key index , which means that 
    # Active Record uses both keys at the same time.
    
    # I have added a page which have detailed explanations of add_index into 
    # favorites on Chrome.
    add_index :microposts, [:user_id, :created_at]
  end
end
