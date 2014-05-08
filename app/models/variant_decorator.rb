require 'elasticsearch/model'
Spree::Variant.class_eval do
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def self.elasticsearch(term, params)
    params[:per_page] ||= 25
    params[:page] ||= 1

    results = search(
      min_score: 0.1,
      query: {
        query_string: {
          fields: [:name, "sku^10", "option_values.name"],
          query: term
        }
      },
      size: params[:per_page],
      from: params[:per_page] * (params[:page]-1)
    ).records
  end

  def as_indexed_json(options={})
    as_json({
      methods: [:name],
      only: [:name, :sku],
      include: {
        option_values: {
          only: [:name, :presentation]
        }
      }
    })
  end
end