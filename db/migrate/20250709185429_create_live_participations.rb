# db/migrate/xxx_create_live_participations.rb
class CreateLiveParticipations < ActiveRecord::Migration[7.0]
  def change
    create_table :live_participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :yoga_class, null: false, foreign_key: true
      t.datetime :joined_at
      t.datetime :left_at
      t.integer :duration_seconds, default: 0

      t.timestamps
    end

    add_index :live_participations, [ :user_id, :yoga_class_id ], unique: true
  end
end
