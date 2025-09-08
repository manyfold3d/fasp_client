FactoryBot.define do
  factory :event_subscription, class: 'FaspClient::EventSubscription' do
    trait :account_lifecycle do
      category { "account" }
      subscription_type { "lifecycle" }
    end
    trait :content_lifecycle do
      category { "content" }
      subscription_type { "lifecycle" }
    end
    trait :content_trends do
      category { "content" }
      subscription_type { "trends" }
    end
  end
end
