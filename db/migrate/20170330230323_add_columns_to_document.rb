class AddColumnsToDocument < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :hsh, :text
    add_column :documents, :pdf, :text
  end
end
