# frozen_string_literal: true

module Reimportable
  extend ActiveSupport::Concern

  def import_status_for(job_class)
    params.fetch(:jids, []).each_with_object({}) do |jid, obj|
      status = job_class.status(jid)
      obj[jid] = {
        status: status,
        result: (status == :done ? job_class.fetch_result(jid) : nil)
      }.compact
    end
  end
end
