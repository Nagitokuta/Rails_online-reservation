class CreateYogaClasses < ActiveRecord::Migration[7.1]
  def change
    create_table :yoga_classes do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.string :instructor
      t.integer :capacity

      t.timestamps
    end
  end
end
