class Restaurant < ApplicationRecord
  has_many :foods
  has_many :line_foods, through: :foods
  belongs_to :order, optional: true

  validates :name, :fee, :time_required, presence: true
  validates :name, length: { maximum: 30 }
  # 属性に数値のみが使われていることを検証します
  # 指定された値よりも大きくなければならないことを指定します
  validates :fee, numericality: { greater_than: 0 }
end