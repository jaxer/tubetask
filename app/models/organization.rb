class Organization < ActiveRecord::Base
  has_many :related_organizations_association,
           :class_name => 'Relation'

  has_many :related_organizations,
           :through => :related_organizations_association,
           :source => :related_organization,
           dependent: :destroy

  class Error < Exception

  end

  # fail if relation already exists but with different type
  def self.create_relation_or_fail(new_rels, org, relative_org, type)
    found = Relation.where(organization: org,
                           related_organization: relative_org).first

    if found && found.relation_type != type.to_s
      raise Error.new('two organizations cannot have two different types of relations')
    end

    unless found
      new_rels.push Relation.create!(
                        organization: org,
                        related_organization: relative_org,
                        relation_type: type)
    end
  end

  def self.create_one_from_json(new_orgs, new_rels, json)
    name = json['org_name']

    unless name
      raise Error.new('org_name required')
    end

    existed = Organization.exists?(name: name)
    org = Organization.where(name: name).first_or_create!

    unless existed
      new_orgs.push org
    end

    daughters = json['daughters']
    relatives = json['relatives']

    if daughters
      daughters.each do |rel_json|
        related_org = Organization.create_one_from_json(new_orgs, new_rels, rel_json)
        Organization.create_relation_or_fail(new_rels, org, related_org, :daughter)
      end
    end

    if relatives
      relatives.each do |rel_json|
        related_org = Organization.create_one_from_json(new_orgs, new_rels, rel_json)
        Organization.create_relation_or_fail(new_rels, org, related_org, :relative)
      end
    end

    org
  end

  def self.create_from_json(json)
    new_orgs = []
    new_rels = []

    ActiveRecord::Base.transaction do
      Organization.create_one_from_json(new_orgs, new_rels, json)
    end

    return new_orgs, new_rels
  end
end
