require 'aws-sdk-s3'

class S3Uploader
  def self.client
    client ||= Aws::S3::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      endpoint: ENV['S3_ENDPOINT'],
      force_path_style: true
    )
  end

  def self.upload(file, key)
    self.client.put_object(
      bucket: ENV['S3_BUCKET'],
      key: key,
      body: file.read
    )
  end

  def self.download(key)
    client.get_object(bucket: ENV['S3_BUCKET'], key: key).body.read
  end
end
