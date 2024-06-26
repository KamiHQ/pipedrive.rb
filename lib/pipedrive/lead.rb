module Pipedrive
  class Lead < Base
    include ::Pipedrive::Operations::Create
    include ::Pipedrive::Operations::Read
    include ::Pipedrive::Operations::Update
    include ::Pipedrive::Operations::Delete
    include ::Pipedrive::Operations::Search
  end
end
