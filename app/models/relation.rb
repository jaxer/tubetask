class Relation < ActiveRecord::Base
  enum relation_type: [ :daughter, :relative ]

  belongs_to :organization
  belongs_to :related_organization, :class_name => 'Organization'
end
