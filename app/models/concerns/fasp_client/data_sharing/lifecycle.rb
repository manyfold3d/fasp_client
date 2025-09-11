module FaspClient
  module DataSharing
    module Lifecycle
      extend ActiveSupport::Concern

      cattr_accessor :fasp_category
      cattr_accessor :fasp_uri_method
      cattr_accessor :fasp_job_queue

      class_methods do
        def fasp_share_lifecycle(category:, uri_method:, queue: "default")
          @@fasp_uri_method = uri_method
          @@fasp_category = category
          @@fasp_job_queue = queue
        end
      end

      included do
        after_commit -> { fasp_emit_lifecycle_announcement "new" }, on: :create
        after_commit -> { fasp_emit_lifecycle_announcement "update" }, on: :update
        before_destroy -> { fasp_emit_lifecycle_announcement "delete" }
      end

      private

      def fasp_object_uri
        raise NotImplementedError("set object URI method using `fasp_share_lifecycle`") unless respond_to?(fasp_uri_method)
        send(fasp_uri_method)
      end

      def fasp_emit_lifecycle_announcement(event_type)
        LifecycleAnnouncementJob.set(queue: fasp_job_queue).perform_later(event_type: event_type, category: fasp_category, uri: fasp_object_uri)
      end
    end
  end
end
