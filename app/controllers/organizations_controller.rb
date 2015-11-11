class OrganizationsController < ApplicationController

  api! "Get a list of all organizations created."
  description "Returns an array of objects with each organization name and ids."

  def index
    @organizations = Organization.all

    render json: @organizations
  end

  api! "Create organization and its children."
  description <<-EOS
  Creates a list of organizations and relations between them.

  NOTE: Method will create local records immediately and start a background job to
  create corresponding records in pipedrive API (the later part might take some time to conclude).
  EOS

  example <<-EOS
  POST payload:

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

  def create
    json = JSON.parse request.body.read
    Organization.create_from_json(json)

    SyncJob.perform_later

    render json: {success: true}
  rescue Organization::Error => e
    render :json => {success: false, error: e.message}, :status => :unprocessable_entity
  end

  api :DELETE, '/organizations', "Delete ALL organizations and relations."
  description "Destroy all organizations and corresponding relations."

  def destroy_all
    ids = Organization.where.not(external_id: nil).pluck 'external_id'

    unless ids.empty?
      DeleteAllJob.perform_later ids
    end

    Organization.destroy_all

    render :json => {success: true}
  end

end
