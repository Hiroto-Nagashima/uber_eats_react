Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    # apiのバージョンを切り替えやすいようにURL内で明示
    # namespace 識別子みたいなもの。名前の衝突を避ける
    namespace :v1 do
      resources :restaurants do
        # %[]要素がシンボルの配列を作る。
        resources :foods, only: %i[index]
      end
      resources :line_foods, only: %i[index create]
      put 'line_foods/replace', to: 'line_foods#replace'
      resources :orders, only: %i[create]
    end
  end
end
