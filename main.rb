require 'aws-sdk'
require_relative 'services/s3_checks'


s3_client = Aws::S3::Client.new
s3_checks = S3Checks.new(s3_client)


puts s3_checks.run_checks 
