class Order < ApplicationRecord
  has_many :line_foods

  validates :total_price, numericality: { greater_than: 0 }
  # 注文が完了した後、商品のactiveをfalseに戻す
  def save_with_update_line_foods!(line_foods)
    # トランザクションはActiveRecord::Base.transaction do ... endというかたちで記述
    # line_food.update_attributes!かself.save!が失敗したらロールバック
    ActiveRecord::Base.transaction do
      line_foods.each do |line_food|
        # LineFoodモデルとOrderモデルはリレーションを貼っており、またorder_idという外部keyをLineFoodが持っているので、
        # order: selfのように参照先モデル名で属性を更新することができます。
        # selfとは、モデルクラスの中で使う場合は、そのモデルのインスタンス自身を指します。
        # 今回はselfはOrderインスタンスオブジェクトを指します。
        line_food.update_attributes!(active: false, order: self)
      end
      self.save!
    end
  end
end