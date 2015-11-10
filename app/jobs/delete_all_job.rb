class DeleteAllJob < ActiveJob::Base
  queue_as :default

  def perform(ids)
    Pipedrive.new.delete_organizations(ids)
  end
end
