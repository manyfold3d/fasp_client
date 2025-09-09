class FaspClient::LifecycleAnnouncementJob < ::ApplicationJob
  def perform(event_type:, category:, uri:)
    Rails.logger.debug("Announcing lifecycle event: #{event_type} #{category} #{uri}")
  end
end
