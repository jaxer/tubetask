class OrganizationCreateJob < ActiveJob::Base
  queue_as :default

  def perform(org_id)
    org = Organization.find(org_id)
    return if org.sync_finished_at

    id = Pipedrive.new.create_organization(org.name)
    org.external_id = id
    org.sync_finished_at = DateTime.now
    org.save!

    SyncJob.perform_later
  end
end
