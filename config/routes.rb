# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  root "yoga_classes#index"

  resources :yoga_classes, only: [ :index, :show ] do
    member do
      get "live"
      post "join_live"
      delete "leave_live"
    end

    # フィードバック関連のルート
    resources :feedbacks, only: [ :new, :create, :show ]
  end

  resources :reservations, only: [ :create, :destroy ]

  # カレンダー関連のルート
  get "calendar", to: "calendars#index"
  get "calendar/day", to: "calendars#day", as: "calendar_day"

  # マイページ関連のルート
  get "mypage", to: "users#show", as: "mypage"
  get "mypage/edit", to: "users#edit", as: "edit_user"
  patch "mypage", to: "users#update"
  get "mypage/password", to: "users#edit_password", as: "edit_user_path_password"
  patch "mypage/password", to: "users#update_password"
  get "mypage/feedbacks", to: "users#feedbacks", as: "user_feedbacks"
end
