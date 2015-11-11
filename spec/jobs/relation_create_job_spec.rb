require 'rails_helper'

RSpec.describe RelationCreateJob, type: :job do
  it "Posts to pipedrive" do
    org = create(:organization, external_id: 20)
    rel = create(:relation, related_organization: org)

    expect(Pipedrive).to receive(:post).with(
                             '/v1/organizationRelationships',
                             body: {
                                 rel_owner_org_id: 10,
                                 rel_linked_org_id: 20,
                                 type: 'parent'}
                         ).and_return(
                             JSON.parse '{"success": true, "data": {"id":123}}')

    RelationCreateJob.perform_now rel.id
  end
end
