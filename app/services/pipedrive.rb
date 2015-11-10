class Pipedrive
  include HTTParty
  base_uri 'https://api.pipedrive.com'
  default_params api_token: Rails.configuration.pipedrive_api_token

  format :json

  logger ::Logger.new('log/pipedrive.log'), :debug, :curl

  def delete_organizations(ids)
    self.class.delete("/v1/organizations", body: {ids: ids})
  end

  def create_organization(name)
    res = self.class.post("/v1/organizations", body: {name: name})

    if res['success']
      res['data']['id']
    else
      raise res['error']
    end
  end

  def create_relation(org_id, rel_org_id, type)
    res = self.class.post(
        "/v1/organizationRelationships",
        body: {
            rel_owner_org_id: org_id,
            rel_linked_org_id: rel_org_id,
            type: type.to_s == 'daughter' ? 'parent' : 'related'
        })
    if res['success']
      res['data']['id']
    else
      raise res['error']
    end
  end
end
