class Organization < ActiveRecord::Base
  has_many :related_organizations_association, :class_name => 'Relation'
  has_many :related_organizations, :through => :related_organizations_association, :source => :related_organization
end
