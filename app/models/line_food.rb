class LineFood < ApplicationRecord
  class LineFood < ApplicationRecord
    belongs_to :food
    belongs_to :restaurant
    belongs_to :order, optional: true
  
    validates :count, numericality: { greater_than: 0 }
  # LineFood.activeのようにLineFoodからwhereでactive: trueなもの一覧をActiveRecord_Relationのかたちで返してくれる
    scope :active, -> { where(active: true) }
    # scopeとは、クラスメソッドを使う際、可読性を保つためにある
    # (){}前の（）は引数
    scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id) }

    def total_amount
      food.price * count
    end
  end
end