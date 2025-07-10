# db/migrate/xxx_create_feedbacks.rb
class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.integer :rating, null: false
      t.text :comment, null: false
      t.references :user, null: false, foreign_key: true
      t.references :yoga_class, null: false, foreign_key: true

      t.timestamps
    end

    # 1つのクラスに対して1ユーザー1回のみフィードバック可能
    add_index :feedbacks, [ :user_id, :yoga_class_id ], unique: true
  end
end
