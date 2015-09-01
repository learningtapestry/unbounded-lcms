module Content
  module Models
    class UserRole < ActiveRecord::Base
      belongs_to :user
      belongs_to :role
      belongs_to :organization
    end
  end
end
