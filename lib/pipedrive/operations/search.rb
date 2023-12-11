# frozen_string_literal: true

module Pipedrive
  module Operations
    module Search
      extend ActiveSupport::Concern
      include ::Enumerable
      include ::Pipedrive::Utils

      def search(*args)
        params = args.extract_options!
        params[:term] ||= args[0]

        raise 'term is missing' unless params[:term]

        follow_pagination(:make_api_call, [:get, 'search'], params)
      end

      def partial_match_search(*args, &block)
        params = args.extract_options!
        params[:term] ||= args[0]

        raise 'term is missing' unless params[:term]

        return to_enum(:search, params) unless block

        follow_pagination(:make_api_call, [:get, 'search'], params, &block)
      end

      def search2(*args)
        params = args.extract_options!
        params[:term] ||= args[0]

        raise 'term is missing' unless params[:term]

        make_api_call(:get, 'search', params)
      end
      # def search_in_chunks(params = {})
      #   res = make_api_call(:get, :search, params)
      #   return [] unless res.success?

      #   res
      # end

      # def all_results(params = {})
      #   search(params).to_a
      # end
    end
  end
end
