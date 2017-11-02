# frozen_string_literal: true

module ResqueJob
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    def find(job_id)
      find_in_queue(job_id) || find_in_working(job_id)
    end

    def find_in_queue(job_id)
      Resque.peek(queue_name, 0, 0)
        .map { |job| job['args'].first }
        .detect { |job| job['job_id'] == job_id }
    end

    def find_in_working(job_id)
      Resque::Worker.working.map(&:job).detect do |job|
        if job.is_a?(Hash) && (args = job.dig 'payload', 'args').is_a?(Array)
          args.detect { |x| x['job_id'] == job_id }
        end
      end
    end

    def fetch_result(job_id)
      res = Resque.redis.multi do
        key = result_key(job_id)
        Resque.redis.get key
        Resque.redis.del key
      end.first
      JSON.parse(res) rescue res
    end

    def result_key(job_id)
      [Resque.redis.namespace, 'result', name.underscore, job_id].join(':')
    end

    def status(job_id)
      if find_in_queue(job_id)
        :waiting
      elsif find_in_working(job_id)
        :running
      else
        :done
      end
    end
  end

  def result_key
    @result_key ||= self.class.result_key(job_id)
  end

  def store_result(res)
    Resque.redis.set result_key, res.to_json, ex: 1.hour.to_i
  end
end
