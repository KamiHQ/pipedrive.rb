# frozen_string_literal: true

module Pipedrive
  module Operations
    module Search
      extend ActiveSupport::Concern
      include ::Enumerable
      include ::Pipedrive::Utils

      def search(params, &block)
        return to_enum(:search, params) unless block_given?

        follow_pagination(:search_chunk, [], params, &block)
      end

      def search_chunk(params)
        raise ArgumentError, 'term is missing' unless params[:term]

        res = make_api_call(:get, 'search', params)
        return [] unless res.success?

        res
      end
    end
  end
end
