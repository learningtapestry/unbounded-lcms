module Content
  module Models
    class Organization < ActiveRecord::Base
      has_many :user_organizations, dependent: :destroy
      has_many :user_roles, dependent: :destroy
    end
  end
end
