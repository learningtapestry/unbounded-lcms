module Content
  module Models
    class User < ActiveRecord::Base
      # Include default devise modules. Others available are:
      # :confirmable, :lockable, :timeoutable and :omniauthable
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :trackable, :validatable

      has_many :user_organizations, dependent: :destroy
      has_many :user_roles, dependent: :destroy

      has_many :organizations, through: :user_organizations

      def roles(org, roles = nil)
        if roles
          user_roles.destroy_all
          roles.each { |role| add_role(org, role) }
        else
          user_roles.joins(:role).where(organization: org).map(&:role)
        end
      end

      def add_role(org, role)
        UserRole.find_or_create_by!(user: self, organization: org, role: role)
      end

      def remove_role(org, role)
        user_roles.where(organization: org, role: role).destroy_all
      end

      def has_role?(org, role)
        !user_roles.where(organization: org, role: role).empty?
      end

      def add_to_organization(org)
        UserOrganization.find_or_create_by!(user: self, organization: org)
      end

      def remove_from_organization(org)
        User.transaction do
          user_roles.where(organization: org).destroy_all
          user_organizations.where(organization: org).destroy_all
        end
      end
    end
  end
end
