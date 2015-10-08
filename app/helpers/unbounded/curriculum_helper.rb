module Unbounded
  module CurriculumHelper
    def cache_key_for_curriculum
      subject = params[:subject] || 'all'
      grade = params[:grade] || 'all'
      standards = params[:standards] || 'all'
      "curriculum/#{subject}/#{grade}/#{standards}"
    end
  end
end
