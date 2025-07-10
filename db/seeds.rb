# db/seeds.rb に追加
# テスト用のライブ配信クラス
live_class = YogaClass.create!(
  name: "朝ヨガライブ",
  description: "朝の目覚めを促すストレッチ中心のライブクラスです。初心者向け。",
  start_time: 1.hour.from_now,
  instructor: "佐藤先生",
  capacity: 30,
  youtube_live_id: "jfKfPfyJRdk", # YouTubeのサンプル動画ID
  live_status: "live"
)

live_class = YogaClass.create!(
  name: "今日ヨガライブ",
  description: "テスト",
  start_time: 1.hour.from_now,
  instructor: "佐藤先生",
  capacity: 30,
  youtube_live_id: "jfKfPfyJRdk", # YouTubeのサンプル動画ID
  live_status: "live"
)

# 現在のユーザーで予約を作成（テスト用）
if User.exists?
  user = User.first
  Reservation.create!(
    user: user,
    yoga_class: live_class
  )
end
