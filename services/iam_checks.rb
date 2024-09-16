require 'aws-sdk-iam'
require_relative 'root_iam'

class Iam_checks
    def initialize(client)
            @client = client
            
    end

    def run_checks
      root_iam_checks = Root_iam.new(@client)
      root_iam_checks.run_checks

    end

end