require 'rails_helper'

RSpec.describe DeleteAllJob, type: :job do
  it "Posts to pipedrive" do
    expect(Pipedrive).to receive(:delete).with(
        '/v1/organizations', body: {ids: [1, 4, 8]})
    DeleteAllJob.perform_now [1, 4, 8]
  end
end
