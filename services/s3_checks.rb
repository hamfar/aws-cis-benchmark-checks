require 'aws-sdk-s3'
require_relative 'bucket'

class S3Checks 
    attr_reader :buckets

    def initialize(client)
        @client = client
        @buckets = list_buckets.map { |name| Bucket.new(name, @client)}
    end

    def list_buckets 
        @client.list_buckets.buckets.map(&:name)
    end

    def run_checks 
        @buckets.each do |bucket|
            bucket.check_encryption
            bucket.check_versioning
            bucket.check_block_public_access
        end
        @buckets.map(&:to_hash)
    end

end
