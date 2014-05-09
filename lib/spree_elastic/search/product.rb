module SpreeElastic
  module Search
    class Product < Base
      def search
        Spree::Product.elasticsearch(params)
      end
    end
  end
end