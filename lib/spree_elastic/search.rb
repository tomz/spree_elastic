module SpreeElastic
  class Search
    def retrieve_variants(scope, query, params={})
      scope.elasticsearch(query, params)
    end
  end
end