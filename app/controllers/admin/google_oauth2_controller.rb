module Admin
  class GoogleOauth2Controller < AdminController
    def callback
      target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
      redirect_to target_url
    end
  end
end
