module Content
  module Models
    class Organization < ActiveRecord::Base
      has_many :lobjects, dependent: :destroy
      has_many :user_organizations, dependent: :destroy
      has_many :user_roles, dependent: :destroy

      def self.unbounded
        find_or_create_by!(name: 'UnboundEd')
      end

      def self.lt
        find_or_create_by!(name: 'LearningTapestry')
      end
    end
  end
end
