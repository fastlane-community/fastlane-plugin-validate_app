require 'fastlane/action'
require_relative '../helper/validate_app_helper'

module Fastlane
  module Actions
    class ValidateAppAction < Action
      def self.run(params)
        require 'plist'

        ENV["VALIDATE_APP_PASSWORD"] = ENV["ALTOOL_2FA_PASSWORD"] || ENV["FASTLANE_PASSWORD"] || ENV["DELIVER_PASSWORD"] || self.fetch_password_from_keychain

        ipa = params[:ipa].to_s.shellescape
        username = params[:username]
        password = "@env:VALIDATE_APP_PASSWORD"

        UI.message("Validating #{ipa}. This may take a while.")

        command = ["xcrun", "altool"]
        command << "--validate-app"
        command << "--file"
        command << ipa
        command << "--username"
        command << username
        command << "--password"
        command << password
        command << "--output-format xml"

        result = Actions.sh(command.join(' '))
        plist = Plist.parse_xml(result)
        errors = plist["product-errors"]

        if errors.nil?
          UI.success(plist["success-message"])
          return nil
        end

        errors.each do |error|
          UI.error(error["message"])
        end

        errors
      end

      def self.description
        "Validate your ipa file"
      end

      def self.authors
        ["Thi"]
      end

      def self.return_value
        "Returns nil if build is valid, and an array of error objects if build is invalid"
      end

      def self.details
        [
          "Validate your ipa file using altool before upload to ensure only",
          "valid builds are uploaded and processed by iTunes Connect.",
          "More information: https://github.com/thii/fastlane-plugin-validate_app"
        ].join(' ')
      end

      def self.fetch_password_from_keychain
        require 'credentials_manager/account_manager'

        keychain_entry = CredentialsManager::AccountManager.new(user: @user)
        keychain_entry.password
      end

      def self.available_options
        require 'credentials_manager/appfile_config'

        @user = CredentialsManager::AppfileConfig.try_fetch_value(:itunes_connect_id)
        @user ||= CredentialsManager::AppfileConfig.try_fetch_value(:apple_id)

        [
          FastlaneCore::ConfigItem.new(key: :ipa,
                                       env_name: "VALIDATE_APP_IPA",
                                       description: "Path to the ipa file to validate",
                                       is_string: true,
                                       default_value: Dir["*.ipa"].sort_by { |x| File.mtime(x) }.last,
                                       optional: true,
                                       verify_block: proc do |value|
                                         value = File.expand_path(value)
                                         UI.user_error!("could not find ipa file at path '#{value}'") unless File.exist?(value)
                                         UI.user_error!("'#{value}' doesn't seem to be an ipa file") unless value.end_with?(".ipa")
                                       end),

          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "VALIDATE_APP_USERNAME",
                                       description: "Your Apple ID username",
                                       is_string: true,
                                       default_value: @user,
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac, :appletvos].include?(platform)
      end
    end
  end
end
