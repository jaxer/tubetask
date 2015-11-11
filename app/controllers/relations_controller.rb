class RelationsController < ApplicationController
  api :GET, '/relations/:id', "Get a list of relations for specified organization."
  description "Returns an array of relations and related organizations."
  param :id, :number, required: true
  example <<-EOS
{
    "success": true,
    "data": [
        {
            "id": 4,
            "relation_type": "daughter",
            "external_id": 66,
            "organization_id": 1,
            "related_organization_id": 2,
            "sync_started_at": "2015-11-11T01:34:52.000Z",
            "sync_finished_at": "2015-11-11T01:34:53.000Z",
            "created_at": "2015-11-11T01:34:50.000Z",
            "updated_at": "2015-11-11T01:34:53.000Z"
        },
        {
            "id": 5,
            "relation_type": "relative",
            "external_id": 64,
            "organization_id": 1,
            "related_organization_id": 6,
            "sync_started_at": "2015-11-11T01:34:52.000Z",
            "sync_finished_at": "2015-11-11T01:34:53.000Z",
            "created_at": "2015-11-11T01:34:50.000Z",
            "updated_at": "2015-11-11T01:34:53.000Z"
        }
    ],
    "related_objects": {
        "organization": [
            {
                "id": 1,
                "name": "Paradise Island",
                "external_id": 304,
                "sync_started_at": "2015-11-11T01:34:50.000Z",
                "sync_finished_at": "2015-11-11T01:34:51.000Z",
                "created_at": "2015-11-11T01:34:50.000Z",
                "updated_at": "2015-11-11T01:34:51.000Z"
            },
            {
                "id": 2,
                "name": "Banana tree",
                "external_id": 303,
                "sync_started_at": "2015-11-11T01:34:50.000Z",
                "sync_finished_at": "2015-11-11T01:34:51.000Z",
                "created_at": "2015-11-11T01:34:50.000Z",
                "updated_at": "2015-11-11T01:34:51.000Z"
            },
            {
                "id": 6,
                "name": "hawaii333a",
                "external_id": 308,
                "sync_started_at": "2015-11-11T01:34:50.000Z",
                "sync_finished_at": "2015-11-11T01:34:52.000Z",
                "created_at": "2015-11-11T01:34:50.000Z",
                "updated_at": "2015-11-11T01:34:52.000Z"
            }
        ]
    }
}
  EOS
  def index
    org = Organization.find(params['id'])
    @relations = Relation.where('organization_id = ? OR related_organization_id = ?', org, org)

    org_ids = [].to_set
    @relations.each do |rel|
      org_ids.add rel.organization_id
      org_ids.add rel.related_organization_id
    end

    @organizations = Organization.find(org_ids.to_a)

    render json: {
               success: true,
               data: @relations,
               related_objects: {
                   organization: @organizations
               }}
  rescue ActiveRecord::RecordNotFound => e
    render json: {success: false, error: e.message}

  end
end
