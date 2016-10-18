class RemoveSession
  SET_COOKIE = 'Set-Cookie'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    path = env['PATH_INFO']
    user_key = env['rack.session'].try(:[], 'warden.user.user.key')

    # Don't delete the session cookie if:
    #   - We're in the process of logging in (breaks CSRF for sign in form)
    #   - We're logged in (needed for Devise)
    skip_delete = (
      path =~ /^\/users/ ||
      user_key.present? ||
      headers[SET_COOKIE].blank?
    )

    signing_out = path =~ /^\/users\/sign_out$/

    unless skip_delete
      # Delete ONLY the session cookie.
      headers[SET_COOKIE] = without_session_cookie(headers[SET_COOKIE])
    end

    if signing_out
      # Clear out the session cookie so the browser won't send it again.
      Rack::Utils.delete_cookie_header!(headers, '_content_session')
    end

    [status, headers, body]
  end

  def without_session_cookie(header)
    case header
    when nil, ''
      cookies = []
    when String
      cookies = header.split("\n")
    when Array
      cookies = header
    end

    cookies.reject! { |c| c =~ /_content_session/ }

    cookies.join('\n')
  end
end
