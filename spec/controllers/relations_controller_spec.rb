require 'rails_helper'

RSpec.describe RelationsController, type: :controller do
  it "prints list of relations" do
    rel = create(:relation)
    org1 = rel.organization
    org2 = rel.related_organization

    get :index, {id: org1.id}

    expect(response).to be_success
    expect(assigns(:relations)).to eq([rel])
    expect(assigns(:organizations)).to eq([org1, org2])
  end
end
