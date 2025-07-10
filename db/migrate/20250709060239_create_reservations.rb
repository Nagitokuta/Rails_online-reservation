class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :yoga_class, null: false, foreign_key: true

      t.timestamps
    end

    # 同じユーザーが同じクラスを重複予約できないようにする
    add_index :reservations, [ :user_id, :yoga_class_id ], unique: true
  end
end
