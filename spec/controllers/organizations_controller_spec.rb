require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  it "prints list of organizations" do
    org1 = create(:organization)
    org2 = create(:organization, name: 'org2')

    get :index

    expect(response).to be_success
    expect(assigns(:organizations)).to eq([org1, org2])
  end

  describe "deletes all organizations and relations and calls DeleteAllJob" do
    before(:each) do
      @org1 = create(:organization, name: 'org', external_id: 15)
      @org2 = create(:organization, name: 'related org', external_id: 25)
      @rel = create(:relation, organization: @org1, related_organization: @org2)
    end

    subject { delete :destroy_all }
    let(:orgs) { Organization.all }

    it { expect(subject).to be_success }
    it { expect { subject }.to change { Organization.all.size }.from(2).to(0) }
    it { expect { subject }.to change { Relation.all.size }.from(1).to(0) }
    it { expect { subject }.to enqueue_a(DeleteAllJob).with([15, 25]) }
  end

  it 'creates models from json' do
    post :create, <<-EOS
      {
          "org_name": "Paradise Island",
          "daughters": [
              {
                  "org_name": "Banana tree",
                  "daughters": [
                      {"org_name": "Yellow Banana"},
                      {"org_name": "Brown Banana"},
                      {"org_name": "Green Banana"}
                  ]
              }
          ],
          "relatives": [
              {
                  "org_name": "Hawaii Island"
              }
          ]
      }
    EOS

    expect(Organization.all.pluck :name).to eq ["Paradise Island", "Banana tree",
                                                "Yellow Banana", "Brown Banana",
                                                "Green Banana", "Hawaii Island"]
    expect(Relation.all.map { |o| [
               o.relation_type,
               o.organization.name,
               o.related_organization.name] }).to eq [
                                                         ["daughter", "Banana tree", "Yellow Banana"],
                                                         ["daughter", "Banana tree", "Brown Banana"],
                                                         ["daughter", "Banana tree", "Green Banana"],
                                                         ["daughter", "Paradise Island", "Banana tree"],
                                                         ["relative", "Paradise Island", "Hawaii Island"]
                                                     ]
  end
end
