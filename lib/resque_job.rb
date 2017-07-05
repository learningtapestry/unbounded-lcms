# frozen_string_literal: true

module ResqueJob
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
end
