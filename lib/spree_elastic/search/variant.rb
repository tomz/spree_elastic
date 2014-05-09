module SpreeElastic
  module Search
    class Variant < Base
      def search(params={})
        scope = params.delete(:scope)
        query = params.delete(:query)
        scope.elasticsearch(query, params)
      end
    end
  end
end