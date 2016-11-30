class PDFProxy < Rack::Proxy
  def rewrite_env(env)
    env['HTTP_HOST'] = "#{ENV['AWS_S3_BUCKET_NAME']}.s3.amazonaws.com"
    env['REQUEST_PATH'] = env['REQUEST_PATH'].gsub('/pdf_proxy', '')
    env['SERVER_PORT'] = 80 if Rails.env.development?
    env['SCRIPT_NAME'] = nil
    #env['HTTP_X_FORWARDED_PORT'] = nil
    env
  end

  def call(env)
    @streaming = true
    super
  end

  def rewrite_response(triplet)
    _status, headers, _body = triplet
    headers['Content-Disposition'] = 'inline'
    triplet
  end
end
