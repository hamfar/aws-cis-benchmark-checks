require 'aws-sdk'
require_relative 'services/s3_checks'
require_relative 'services/iam_checks'
require 'aws-sdk-iam'

def run_checks_for_profile(profile)
    s3_client = Aws::S3::Client.new(profile: profile)
    s3_checks = S3Checks.new(s3_client)
    iam_client = Aws::IAM::Client.new
    iam_checks = Iam_checks.new(iam_client)
    iam_checks.run_checks
    s3_checks.run_checks
end

    
profiles = ['default']

results = profiles.flat_map do |profile|
    run_checks_for_profile(profile)
end

puts results.to_json