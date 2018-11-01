# frozen_string_literal: true

User.class_eval do
  validate :access_code_valid?, on: :create
end
