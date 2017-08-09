# frozen_string_literal: true

class AddConfirmationToExistingUsers < ActiveRecord::Migration
  def data
    User.find_each(&:confirm)
  end
end
