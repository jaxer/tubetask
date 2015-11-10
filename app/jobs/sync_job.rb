class SyncJob < ActiveJob::Base
  queue_as :default

  def perform
    orgs = Organization.all.where(sync_started_at: nil)
    orgs.each do |org|
      org.sync_started_at = DateTime.now
      org.save!
      OrganizationCreateJob.perform_later org.id
    end

    # only sync relations after all organizations are already there (to make
    # sure that we never create relation for unexistant org)
    if Organization.all.where(sync_finished_at: nil).size == 0
      rels = Relation.all.where(sync_started_at: nil)
      rels.each do |rel|
        rel.sync_started_at = DateTime.now
        rel.save!
        RelationCreateJob.perform_later rel.id
      end
    end
  end
end
