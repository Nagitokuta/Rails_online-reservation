# 既存データを全て削除（依存関係に注意）
Reservation.delete_all
YogaClass.delete_all
User.delete_all  # Userも消す場合。消したくなければコメントアウト

# 追加のライブクラス
another_live_class = YogaClass.create!(
  name: "今日ヨガライブ",
  description: "テスト",
  start_time: 1.hour.from_now,
  instructor: "佐藤先生",
  capacity: 30,
  youtube_live_id: "jfKfPfyJRdk",
  live_status: "live"
)

# ユーザーが存在していれば予約も作成
if User.exists?
  user = User.first
  Reservation.create!(
    user: user,
    yoga_class: live_class
  )
end
