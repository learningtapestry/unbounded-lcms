module Content
  module Models
    class Organization < ActiveRecord::Base
      has_many :lobjects, dependent: :destroy
      has_many :user_organizations, dependent: :destroy
      has_many :user_roles, dependent: :destroy
      has_many :users, through: :user_organizations

      def self.unbounded
        find_or_create_by!(name: 'UnboundEd')
      end

      def self.lr
        find_or_create_by!(name: 'LearningRegistry')
      end

      def self.lt
        find_or_create_by!(name: 'LearningTapestry')
      end

      def self.easol
        find_or_create_by!(name: 'EASOL')
      end
    end
  end
end
