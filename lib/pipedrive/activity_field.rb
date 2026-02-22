# frozen_string_literal: true

module Pipedrive
  class ActivityField < Base
    include ::Pipedrive::Operations::Create
    include ::Pipedrive::Operations::Read
    include ::Pipedrive::Operations::Delete

    def entity_name
      "activityFields"
    end
  end
end
