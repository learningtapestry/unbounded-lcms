module Content
  module Models
    class UserOrganization < ActiveRecord::Base
      belongs_to :user
      belongs_to :organization
    end
  end
end
