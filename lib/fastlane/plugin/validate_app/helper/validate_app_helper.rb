require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class ValidateAppHelper
      # class methods that you define here become available in your action
      # as `Helper::ValidateAppHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the validate_app plugin helper!")
      end
    end
  end
end
