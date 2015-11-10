class RelationsController < ApplicationController
  api :GET, '/relations/:id', "Get a list of relations for specified organization."
  description "Returns an array of relations and related organizations."
  param :id, :number, required: true

  def index
    org = Organization.find(params['id'])
    @relations = Relation.where('organization_id = ? OR related_organization_id = ?', org, org)

    org_ids = [].to_set
    @relations.each do |rel|
      org_ids.add rel.organization_id
      org_ids.add rel.related_organization_id
    end

    render json: {
               success: true,
               data: @relations,
               related_objects: {
                   organization: Organization.find(org_ids.to_a)
               }}
  rescue ActiveRecord::RecordNotFound => e
    render json: {success: false, error: e.message}

  end
end
