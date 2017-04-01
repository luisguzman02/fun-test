class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :tax_id

      t.timestamps
    end

    create_table :signatures do |t|
      t.belongs_to :document, index: true
      t.belongs_to :user, index: true
    end
  end
end
