require 'aws-sdk-s3'

class Bucket 
    attr_reader :name
    attr_accessor :encryption

    def initialize(name, client)
        @name = name
        @client = client 
        @encryption = false
    end

    def check_encryption 
        resp = @client.get_bucket_encryption(bucket: @name)
        if !resp.server_side_encryption_configuration.nil?
            @encryption = true
        end
    rescue Aws::S3::Errors::ServerSideEncryptionConfigurationNotFoundError
        puts "Bucket #{@name} does not have encryption enabled."
    end

    def check_block_public_access
        resp = @client.get_bucket_public_access_block(bucket: @name)
        block_public_access = resp.public_access_block_configuration

        if block_public_access.block_public_acls && block_public_access.ignore_public_acls && 
            block_public_access.block_public_policy && block_public_access.restrict_public_buckets 
            puts "Bucket #{@name} is configured with 'Block public access (bucket settings)'."
        else
            puts "Bucket #{@name} is NOT configured with 'Block public access (bucket settings)'."
        end
    rescue Aws::S3::Errors::NoSuchPublicAccessBlockConfiguration
        puts "Bucket #{@name} does not have 'Block public access (bucket settings)' configured."
    end

end
