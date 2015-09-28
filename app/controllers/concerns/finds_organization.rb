require 'content/models'

module FindsOrganization
  def find_organization(organization_reader)
    @organization = Content::Models::Organization.send(organization_reader)
  end
end
