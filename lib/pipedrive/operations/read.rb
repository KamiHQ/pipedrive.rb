# frozen_string_literal: true

module Pipedrive
  module Operations
    module Read
      extend ActiveSupport::Concern
      include ::Enumerable
      include ::Pipedrive::Utils

      def each(params = {}, &block)
        return to_enum(:each, params) unless block_given?

        follow_pagination(:chunk, [], params, &block)
      end

      def all(params = {})
        each(params).to_a
      end

      def chunk(params = {})
        res = make_api_call(:get, params)
        return [] unless res.success?

        res
      end

      def find_by_id(id)
        raise ArgumentError, "id must be Integer or String" unless id.is_a?(String) || id.is_a?(Integer)

        make_api_call(:get, id)
      end
    end
  end
end
