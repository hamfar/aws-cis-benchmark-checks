require 'aws-sdk-s3'

class Bucket 
    attr_reader :name
    attr_accessor :encryption, :versioning, :mfa_delete, :block_public_access

    def initialize(name, client)
        @name = name
        @client = client 
        @encryption = false
        @versioning = false
        @mfa_delete = false 
        @block_public_access = false
    end

    def check_encryption 
        resp = @client.get_bucket_encryption(bucket: @name)
        @encryption = !resp.server_side_encryption_configuration.nil?
    rescue Aws::S3::Errors::ServerSideEncryptionConfigurationNotFoundError
        puts "Bucket #{@name} does not have encryption enabled."
    end

    def check_versioning
        resp = @client.get_bucket_versioning(bucket: @name)
        @versioning = resp.status
        @mfa_delete = resp.mfa_delete
    end

    def check_block_public_access
        resp = @client.get_public_access_block(bucket: @name)
        public_access_conf = resp.public_access_block_configuration

        @block_public_access = public_access_conf.block_public_acls &&
                                public_access_conf.ignore_public_acls &&
                                public_access_conf.block_public_policy &&
                                public_access_conf.restrict_public_buckets
    rescue Aws::S3::Errors::NoSuchPublicAccessBlockConfiguration
        puts "Bucket #{@name} does not have 'Block public access (bucket settings)' configured."
    end
    
    def to_hash 
        {
            name: @name,
            encryption_enabled: @encryption, 
            versioning: @versioning, 
            mfa_on_delete: @mfa_delete,
            block_public_access: @block_public_access
        }
    end

end
