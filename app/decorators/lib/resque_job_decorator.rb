# frozen_string_literal: true

ResqueJob.module_eval do
  def store_result(res)
    Resque.redis.set result_key, res.to_json, ex: 1.hour.to_i
  end
end