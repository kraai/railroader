require 'railroader/checks/base_check'

class Railroader::CheckSymbolDoSCVE < Railroader::BaseCheck
  Railroader::Checks.add self

  @description = "Checks for versions with ActiveRecord symbol denial of service vulnerability"

  def run_check
    fix_version = case
      when version_between?('2.0.0', '2.3.17')
        '2.3.18'
      when version_between?('3.1.0', '3.1.11')
        '3.1.12'
      when version_between?('3.2.0', '3.2.12')
        '3.2.13'
      else
        nil
      end

    if fix_version && active_record_models.any?
      warn :warning_type => "Denial of Service",
        :warning_code => :CVE_2013_1854,
        :message => "Rails #{rails_version} has a denial of service vulnerability in ActiveRecord: upgrade to #{fix_version} or patch",
        :confidence => :medium,
        :gem_info => gemfile_or_environment,
        :link => "https://groups.google.com/d/msg/rubyonrails-security/jgJ4cjjS8FE/BGbHRxnDRTIJ"
    end
  end
end
