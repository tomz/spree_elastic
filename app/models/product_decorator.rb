Spree::Product.class_eval do
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def self.elasticsearch(params={})
    filtered = {}
    if params[:keywords].present?
      filtered[:query] = {
        query_string: {
          fields: ["name"],
          query: params[:keywords]
        }
      }
    end

    if params[:taxon].present?
      filtered[:filter] = {
        and: [
          term: {
            taxon_ids: params[:taxon]
          }
        ]
      }
    end

    if filtered.present?
    results = search({ min_score: 0.1, :query => { :filtered => filtered }})
      .page(params[:page]).per(params[:per_page]).records
    else
      results = Spree::Product.page(params[:page]).per(params[:per_page])
    end 

    results
  end

  def as_indexed_json(options={})
    as_json({
      methods: [:name, :taxon_ids],
      only: [:name, :taxon_ids],
      include: { 
        variants: {
          only: [:sku],
          include: {
            option_values: {
              only: [:name, :presentation]
            }
          }
        }
      }
    })
  end
end