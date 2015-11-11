require 'rails_helper'

RSpec.describe SyncJob, type: :job do
  before(:each) do
    @rel = create(:relation)
  end

  it "schedules OrganizationCreateJob" do
    SyncJob.perform_now
    expect(OrganizationCreateJob).to have_been_enqueued.with(@rel.organization_id)
    expect(OrganizationCreateJob).to have_been_enqueued.with(@rel.related_organization_id)
  end

  it "does not schedule RelationCreateJob" do
    SyncJob.perform_now
    expect(RelationCreateJob).not_to have_been_enqueued
  end

  it "...until all Organizations got synced" do
    @rel.organization.sync_started_at = DateTime.now
    @rel.organization.sync_finished_at = DateTime.now
    @rel.organization.save!
    @rel.related_organization.sync_started_at = DateTime.now
    @rel.related_organization.sync_finished_at = DateTime.now
    @rel.related_organization.save!

    SyncJob.perform_now

    expect(RelationCreateJob).to have_been_enqueued.with(@rel.id)
  end
end
