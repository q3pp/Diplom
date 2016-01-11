module RocketCMS
  module Controllers
    module Search
      extend ActiveSupport::Concern
      def index
        if params[:query].blank?
          @results = []
        else
          if RocketCMS.mongoid?
            @results = Mongoid::Search.search({
              body: {
                query: {
                  query_string: {
                    query: Mongoid::Search::Utils.clean(params[:query])
                  }
                },
                highlight: {
                  fields: {
                    name: {},
                    content: {}
                  }
                }
              }},
              page: params[:page],
              per_page: RocketCMS.config.search_per_page,
            )
          else
            @results = PgSearch.multisearch(params[:q])
          end
        end
      end
    end
  end
end
