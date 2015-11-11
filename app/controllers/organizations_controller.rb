class OrganizationsController < ApplicationController

  api! "Get a list of all organizations created."
  description "Returns an array of objects with each organization name and ids."
  example <<-EOS
{
    "success": true,
    "data": [
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
            "id": 3,
            "name": "Yellow Banana",
            "external_id": 305,
            "sync_started_at": "2015-11-11T01:34:50.000Z",
            "sync_finished_at": "2015-11-11T01:34:51.000Z",
            "created_at": "2015-11-11T01:34:50.000Z",
            "updated_at": "2015-11-11T01:34:51.000Z"
        },
        {
            "id": 4,
            "name": "Brown Banana",
            "external_id": 307,
            "sync_started_at": "2015-11-11T01:34:50.000Z",
            "sync_finished_at": "2015-11-11T01:34:51.000Z",
            "created_at": "2015-11-11T01:34:50.000Z",
            "updated_at": "2015-11-11T01:34:51.000Z"
        },
        {
            "id": 5,
            "name": "Green Banana",
            "external_id": 306,
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
  EOS

  def index
    @organizations = Organization.all

    render json: {success: true, data: @organizations}
  end

  api! "Create organization and its children."
  description <<-EOS
  Creates a list of organizations and relations between them.

  NOTE: Method will create local records immediately and start a background job to
  create corresponding records in pipedrive API (the later part might take some time to conclude).
  EOS

  example <<-EOS
  Request:

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

  Response:

  {
      "success": true
  }

  Error:

  {
      "success": false,
      "error": "org_name required"
  }
  EOS

  def create
    json = JSON.parse request.body.read
    Organization.create_from_json(json)

    SyncJob.perform_later

    render json: {success: true}
  rescue Organization::Error => e
    render :json => {success: false, error: e.message}, :status => :unprocessable_entity
  end

  api :DELETE, '/organizations', "Delete ALL organizations and relations."
  description <<-EOS
  Destroy all organizations and corresponding relations.

  NOTE: Method will destroy local records immediately and start a background job to
  destroy records on pipedrive.com.
  EOS

  example <<-EOS
  {
      "success": true
  }
  EOS

  def destroy_all
    ids = Organization.where.not(external_id: nil).pluck 'external_id'

    unless ids.empty?
      DeleteAllJob.perform_later ids
    end

    Organization.destroy_all

    render :json => {success: true}
  end

end
