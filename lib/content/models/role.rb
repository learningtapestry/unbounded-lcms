module Content
  module Models
    class Role < ActiveRecord::Base
      has_many :user_roles

      def self.named(name)
        find_by(name: name.to_s)
      end
    end
  end
end
