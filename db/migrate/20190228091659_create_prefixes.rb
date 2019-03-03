class CreatePrefixes < ActiveRecord::Migration[5.2]
  def change
    create_table :prefixes do |t|
      t.integer :value
      t.integer :min_length
      t.integer :max_length
      t.string :usage
      t.string :comment

      t.timestamps
    end
  end
end
