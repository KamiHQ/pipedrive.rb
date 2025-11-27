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

      def each_items(id, item_path_name, params = {}, before_request = nil, &block)
        return to_enum(:each_items, id, item_path_name, params, before_request) unless block_given?

        follow_pagination(:item_chunk, [id, item_path_name], params, before_request, &block)
      end

      def all_items(id, item_path_name, params = {}, &block)
        each_items(id, item_path_name, params, block).to_a
      end

      def item_chunk(id, item_path_name, params = {})
        res = make_api_call(:get, "#{id}/#{item_path_name}", params)
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
