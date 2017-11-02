# frozen_string_literal: true

module Admin
  class BatchReimportsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: %i(new create)

    def import_status
      jid = params[:jid]
      job_class = job_for params[:type]
      data = { status: job_class.status(jid) }
      data[:result] = job_class.fetch_result(jid) if data[:status] == :done
      render json: data, status: :ok
    end

    def new
      @query = OpenStruct.new(params[:query])
    end

    def create
      @query = OpenStruct.new(params[:query])
      entries = @query.type == 'materials' ? materials(@query) : documents(@query)
      bulk_import entries.map(&:file_url), @query.type
      render :import
    end

    private

    def documents(q)
      qset = Document.actives

      qset = qset.filter_by_subject(q.subject) if q.subject.present?
      qset = qset.filter_by_grade(q.grade) if q.grade.present?
      qset = qset.filter_by_module(q.module) if q.module.present?
      qset = qset.filter_by_unit(q.unit) if q.unit.present?
      qset
    end

    def materials(q)
      qset = Material.all

      qset = qset.where_metadata_like(:subject, q.subject) if q.subject.present?
      %i(grade module unit).each do |key|
        qset = qset.joins(:documents).where('documents.metadata @> hstore(?, ?)', key, q[key]) if q[key].present?
      end

      qset.uniq
    end

    def bulk_import(files, type)
      google_auth_id = GoogleAuthService.new(self).user_id
      jobs = {}
      job_class = job_for(type)
      files.each do |url|
        job_id = job_class.perform_later(url, google_auth_id).job_id
        jobs[job_id] = { link: url, status: 'waiting' }
      end
      @props = { jobs: jobs, type: type }
    end

    def job_for(type)
      type == 'materials' ? MaterialParseJob : DocumentParseJob
    end
  end
end
