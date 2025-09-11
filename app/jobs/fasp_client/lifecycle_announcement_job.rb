class FaspClient::LifecycleAnnouncementJob < ::ApplicationJob
  def perform(event_type:, category:, uri:)
    FaspClient::EventSubscription.where(category: category, subscription_type: "lifecycle").find_each do |sub|
      sub.announce_lifecycle event_type: event_type, uri: uri
    end
  end
end
