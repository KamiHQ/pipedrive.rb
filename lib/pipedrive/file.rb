# frozen_string_literal: true

module Pipedrive
  class File < Base
    include ::Pipedrive::Operations::Create
    include ::Pipedrive::Operations::Read
    include ::Pipedrive::Operations::Update
    include ::Pipedrive::Operations::Delete

    def create_remote(params)
      make_api_call(:post, :remote, params)
    end

    def create_remote_link(params)
      make_api_call(:post, :remoteLink, params)
    end
  end
end
