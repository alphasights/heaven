module Heaven
  module Jobs
    # A deployment status handler
    class DeploymentStatus
      @queue = :deployment_statuses

      def self.perform(payload)
        Heaven::Notifier.for(payload).each do |notifier|
          notifier.post!
        end
      end
    end
  end
end
