require 'rails_helper'

RSpec.describe OrganizationCreateJob, type: :job do
  it "Posts to pipedrive" do
    org = create(:organization)

    expect(Pipedrive).to receive(:post).with(
                             '/v1/organizations', body: {name: 'org'}
                         ).and_return(
                             JSON.parse '{"success": true, "data": {"id":123}}')

    OrganizationCreateJob.perform_now org.id
  end
end
