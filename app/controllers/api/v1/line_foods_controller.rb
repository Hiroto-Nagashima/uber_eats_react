module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create replace]

      def index
        # activeがtrueのline_foodsを全部取得
        line_foods = LineFood.active
        if line_foods.exists?
          render json: {
            # mapのうしろ、sumの後ろにブロックを置くと、一つ一つを展開してくれる
            line_food_ids: line_foods.map { |line_food| line_food.id },
            restaurant: line_foods[0].restaurant,
            count: line_foods.sum { |line_food| line_food[:count] },
            amount: line_foods.sum { |line_food| line_food.total_amount },
          }, status: :ok
        else
          # ステータスコードは「リクエストは成功したが、空データ」として204を返す
          render json: {}, status: :no_content
        end
      end

      def create
        # もしも他の店舗の仮注文があった時の処理
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
          # 処理の一番最初にリターンで処理を終える
          return render json: {
            # 既に存在している注文のレストラン
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            # 新しく注文しようとしたレストラン
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
            # 406 Not Acceptableを返します。
          }, status: :not_acceptable
        end
        # line_foodインスタンスを生成
        set_line_food(@ordered_food)
          if @line_food.save
            render json: {
              line_food: @line_food
            }, status: :created
          else
            # HTTPレスポンスステータスコードが500系になる
            render json: {}, status: :internal_server_error
          end
        end
      end

      def replace
        # activeがtrueのline_foodsのなかで、オーダーした商品をおいているレストランではないレストランを取り出す
        LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
          # 論理削除
          line_food.update_attribute(:active, false)
        end

        set_line_food(@ordered_food)

        if @line_food.save
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end

      private

      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food)
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food
          # 既存のline_foodインスタンスの既存の情報を更新
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          # build_association()新しいオブジェクトを生成。引数にはオブジェクトを生成するのに必要なパラメータを指定。
          # この時点では保存されない
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end