FactoryGirl.define do
  factory :organization do
    name "org"
    external_id 10
  end

  factory :relation do
    external_id 100
    relation_type :daughter
    association :organization, factory: :organization
    association :related_organization, factory: :organization, name: 'child org'
  end
end