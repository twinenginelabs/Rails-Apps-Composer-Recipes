class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|

      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :full_name

      t.string :time_zone, :default => "Central Time (US & Canada)"
      t.string :device_token, :size => 255
      t.string :facebook_id
      t.datetime :birthday
      t.string :gender
      t.string :current_city
      t.string :hometown
      t.string :relationship_status

      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at

      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :phone_number
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Token authenticatable
      t.string :authentication_token

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true

    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :token

      t.timestamps
    end

    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
  end

  def self.down
    drop_table :users
    drop_table :authentications
    drop_table :roles_users
  end
end
