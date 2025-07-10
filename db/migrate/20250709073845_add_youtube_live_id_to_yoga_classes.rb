# db/migrate/xxx_add_youtube_live_id_to_yoga_classes.rb
class AddYoutubeLiveIdToYogaClasses < ActiveRecord::Migration[7.0]
  def change
    add_column :yoga_classes, :youtube_live_id, :string
    add_column :yoga_classes, :live_status, :integer, default: 0
  end
end
