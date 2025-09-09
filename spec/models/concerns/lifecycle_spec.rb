describe FaspClient::DataSharing::Lifecycle do
  context "when announcing account lifecycle" do
    it "emits lifecycle new announcement on creation" do
      expect { Account.create }.to have_enqueued_job(FaspClient::LifecycleAnnouncementJob).with(
        event_type: "new", category: "account", uri: "https://example.com/accounts/1"
      )
    end

    it "emits lifecycle update announcement on update" do
      account = Account.create
      expect { account.touch }.to have_enqueued_job(FaspClient::LifecycleAnnouncementJob).with(
        event_type: "update", category: "account", uri: "https://example.com/accounts/1"
      )
    end

    it "emits lifecycle delete announcement on destroy" do
      account = Account.create
      expect { account.destroy! }.to have_enqueued_job(FaspClient::LifecycleAnnouncementJob).with(
        event_type: "delete", category: "account", uri: "https://example.com/accounts/1"
      )
    end
  end

  context "when announcing content lifecycle" do
    it "emits lifecycle new announcement on creation" do
      expect { Content.create }.to have_enqueued_job(FaspClient::LifecycleAnnouncementJob).with(
        event_type: "new", category: "content", uri: "https://example.com/contents/1"
      )
    end

    it "emits lifecycle update announcement on update" do
      content = Content.create
      expect { content.touch }.to have_enqueued_job(FaspClient::LifecycleAnnouncementJob).with(
        event_type: "update", category: "content", uri: "https://example.com/contents/1"
      )
    end

    it "emits lifecycle delete announcement on destroy" do
      content = Content.create
      expect { content.destroy! }.to have_enqueued_job(FaspClient::LifecycleAnnouncementJob).with(
        event_type: "delete", category: "content", uri: "https://example.com/contents/1"
      )
    end
  end
end
