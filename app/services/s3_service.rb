class S3Service
  def self.upload(key, data)
    object = Aws::S3::Resource
               .new(region: ENV.fetch('AWS_REGION'))
               .bucket(ENV.fetch('AWS_S3_BUCKET_NAME'))
               .object(key)

    object.put(body: data)
    object.public_url
  end
end
