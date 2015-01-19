class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|

      t.string :name
      t.string :device_token, size: 255
      t.attachment :avatar
      t.string :time_zone, default: "Central Time (US & Canada)"

      ## Database authenticatable
      t.string :email, default: ""
      t.string :phone_number
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Token authenticatable
      t.string :authentication_token
      
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true

    create_table :identities do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.text :token
      t.text :secret
      t.string :friendly_identifier

      t.timestamps
      t.datetime :deleted_at
    end

    create_table :roles_users, id: false do |t|
      t.references :role, :user
    end
  end

  def self.down
    drop_table :users
    drop_table :identities
    drop_table :roles_users
  end
end
