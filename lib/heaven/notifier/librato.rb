module Heaven
  module Notifier
    class Librato < Default
      def deliver(message)
        # We're not tracking start/end time of deploy's in librato for
        # now so pending doesn't do anything for us.
        return if pending?

        librato_client.annotation(:deployments, "Deploy #{number}: #{state}", {
          source: [repo_name, environment].join("."),
          description: message,
          links: [repo_url, commitish_url, target_url]
        })
      end

      def default_message
        return if pending?

        message_completion_map = {
          "success" => "is done",
          "failure" => "failed",
          "error"   => "has errors",
        }

        "#{chat_user}'s deployment of #{repo_name} (#{sha}) #{message_completion_map[state]}."
      end

      private

      def librato_client
        @librato_client ||= ::Librato::Metrics.authenticate(ENV["LIBRATO_EMAIL"], ENV["LIBRATO_API_KEY"])
      end

      def commitish_url
        repo_url("commit/#{sha}")
      end
    end
  end
end
