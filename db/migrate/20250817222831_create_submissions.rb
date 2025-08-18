class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.string :first_name
      t.string :last_name
      t.text :description

      t.timestamps
    end
  end
end
