require "heaven/notifier/default"
require "heaven/notifier/campfire"
require "heaven/notifier/hipchat"
require "heaven/notifier/flowdock"
require "heaven/notifier/slack"
require "heaven/notifier/librato"

module Heaven
  # The Notifier module
  module Notifier
    def self.for(payload)
      %i(flowdock librato slack hipchat campfire).map { |notifier|
        "::Heaven::Notifier::#{notifier.capitalize}".constantize.new(payload) if send("#{notifier}?")
      }.compact
    end

    def self.slack?
      !ENV["SLACK_WEBHOOK_URL"].nil?
    end

    def self.hipchat?
      !ENV["HIPCHAT_TOKEN"].nil?
    end

    def self.flowdock?
      !ENV["FLOWDOCK_USER_API_TOKEN"].nil?
    end

    def self.librato?
      !ENV["LIBRATO_EMAIL"].nil?
    end

    def self.campfire?
      !ENV["CAMPFIRE_TOKEN"].nil?
    end
  end
end
