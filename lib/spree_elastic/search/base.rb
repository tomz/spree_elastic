module SpreeElastic
  module Search
    class Base
      attr_accessor :current_user
      attr_accessor :current_currency
      attr_accessor :params

      def initialize(params={})
        @params = params
      end
    end
  end
end