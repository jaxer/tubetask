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
              "org_name:": "Hawaii Island"
          }
      ]
  }
  EOS

  def create
    json = JSON.parse request.body.read
    (new_organizations, new_relations) = Organization.create_from_json(json)

    new_organizations.each do |organization|
      OrganizationCreateJob.perform_later organization
    end

    new_relations.each do |rel|
      RelationCreateJob.perform_later(rel.organization, rel.related_organization)
    end

    render json: {new_organizations: new_organizations, new_relations: new_relations}
  rescue Organization::Error => e
    render :json => {:error => e.message}, :status => :unprocessable_entity
  end

  api :DELETE, '/organizations', "Delete ALL organizations and relations."
  description "Destroy all organizations and corresponding relations."

  def destroy_all
    Organization.destroy_all

    head :no_content
  end

end
