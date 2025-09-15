module FaspClient
  module DataSharing
    module Lifecycle
      extend ActiveSupport::Concern

      class_methods do
        def fasp_share_lifecycle(category:, uri_method:, queue: "default", only_if: :present?)
          self.fasp_uri_method = uri_method
          self.fasp_category = category
          self.fasp_job_queue = queue
          self.fasp_only_if_method = only_if
        end
      end

      included do
        cattr_accessor :fasp_category
        cattr_accessor :fasp_uri_method
        cattr_accessor :fasp_job_queue
        cattr_accessor :fasp_only_if_method

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
        return unless send(fasp_only_if_method)
        LifecycleAnnouncementJob.set(queue: fasp_job_queue).perform_later(event_type: event_type, category: fasp_category, uri: fasp_object_uri)
      end
    end
  end
end
