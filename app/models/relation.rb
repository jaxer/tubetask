class Relation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :related_organization, :class_name => 'Organization'
end
