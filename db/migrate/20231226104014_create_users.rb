class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.text :bio
      t.string :image

      t.timestamps
    end

    add_index :users, :email, unique: true
    change_column_null :users, :bio, true
    change_column_null :users, :image, true
  end
end
