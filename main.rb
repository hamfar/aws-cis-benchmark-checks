require 'aws-sdk'
require_relative 'services/s3_checks'


def create_client(profile)
    Aws::S3::Client.new(profile: profile)
end

def run_checks_for_profile(profile)
    s3_client = create_client(profile)
    s3_checks = S3Checks.new(s3_client)
    s3_checks.run_checks
end

    
profiles = ['default']

results = profiles.flat_map do |profile|
    run_checks_for_profile(profile)
end

puts results.to_json