class AddActivationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :activation_digest, :string
    # Just like the admin attribute, add default boolean value of false to the 
    # activated attribute.
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
  end
end
