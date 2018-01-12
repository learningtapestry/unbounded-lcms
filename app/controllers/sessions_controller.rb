# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  include HeapNotifyable

  def create
    super
    heap_notify 'Login'
  end

  def destroy
    heap_notify 'Logout'
    super
  end
end
