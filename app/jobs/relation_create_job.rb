class RelationCreateJob < ActiveJob::Base
  queue_as :default

  def perform(rel_id)
    rel = Relation.find(rel_id)
    return if rel.sync_finished_at

    id = Pipedrive.new.create_relation(
        rel.organization.external_id,
        rel.related_organization.external_id,
        rel.relation_type)

    rel.external_id = id
    rel.sync_finished_at = DateTime.now
    rel.save!
  end
end
