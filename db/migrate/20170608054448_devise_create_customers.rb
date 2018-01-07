class DeviseCreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :firstname
      t.string :lastname
      t.string :address
      t.string :zip
      t.string :city
      t.string :country
      t.string :tel
      t.boolean :company
      t.string :company_name
      t.string :ic
      t.string :dic
      t.boolean :other
      t.string :other_firstname
      t.string :other_lastname
      t.string :other_address
      t.string :other_zip
      t.string :other_city
      t.string :other_tel
      t.string :other_country
      t.boolean :pub
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :customers, :email,                unique: true
    add_index :customers, :reset_password_token, unique: true
    # add_index :customers, :confirmation_token,   unique: true
    # add_index :customers, :unlock_token,         unique: true
  end
end
