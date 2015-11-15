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

      def self.create_for_organization(organization, role, params)
        @user = new(params)
        
        transaction do
          @user.add_to_organization(organization)
          @user.add_role(organization, Role.named(role))

          unless @user.password
            @user.password = Devise.friendly_token.first(20)
            @user.send_reset_password_instructions rescue nil
          end

          @user.save!
        end rescue ActiveRecord::RecordInvalid
        @user.persisted? # Prevents bug in Rails. See https://github.com/rails/rails/issues/22066

        @user
      end

      def roles(org)
        Role.joins(:user_roles).where(user_roles: { organization: org, user: self })
      end

      def add_role(org, role)
        user_roles.build(organization: org, role: role) unless has_role?(org, role)
      end

      def remove_role(org, role)
        !user_roles.where(organization: org, role: role).destroy_all.empty?
      end

      def has_org?(org)
        !user_organizations.where(organization: org).empty?
      end

      def has_role?(org, role)
        !user_roles.where(organization: org, role: role).empty?
      end

      def add_to_organization(org)
        user_organizations.build(organization: org) unless has_org?(org)
      end

      def remove_from_organization(org)
        User.transaction do
          user_roles.where(organization: org).destroy_all
          !user_organizations.where(organization: org).destroy_all.empty?
        end
      end
    end
  end
end
