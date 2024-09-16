require 'aws-sdk-iam'

class Root_iam
  def initialize(client)
    @client = client
  end 

  def run_checks()
    account_summary = @client.get_account_summary.summary_map
    root_access_keys_count = account_summary['AccountAccessKeysPresent']
    root_mfa_enabled = account_summary['AccountMFAEnabled']
    puts "Root account has access keys #{ root_access_keys_count > 0 }"
    puts "Root account has MFA enabled #{ root_mfa_enabled != 0 }"
  end
    
end