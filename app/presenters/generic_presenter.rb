class GenericPresenter < ResourcePresenter
  GRADES = ['prekindergarten', 'kindergarten', 'grade 1', 'grade 2', 'grade 3',
            'grade 4', 'grade 5', 'grade 6', 'grade 7', 'grade 8', 'grade 9',
            'grade 10', 'grade 11', 'grade 12'].freeze

  def generic_title
    "#{subject.try(:upcase)} #{grades_to_str}"
  end

  def type_name
    resource_type.humanize.titleize
  end

  def preview?
    downloads.any? { |d| d.main? && d.attachment_content_type == 'pdf' && RestClient.head(d.attachment_url) }
  rescue RestClient::ExceptionWithResponse
    false
  end

  def pdf_preview_download
    resource_downloads.find { |d| d.download.main? && d.download.attachment_content_type == 'pdf' }
  end

  def grades_to_str
    return '' unless grades.present?
    "Grade #{grade_numbers.join(', ')}"
  end

  private

  def sorted_grade_list
    (grades.map { |g| g.name.downcase } & GRADES)
      .sort_by { |g| GRADES.index(g) }
  end

  def grade_numbers
    grade_list = sorted_grade_list
    grades_size = grade_list.size
    return [grade_number(grade_list.first)] if grades_size == 1
    s_grades = []
    idx = prev_gidx = 0
    loop do
      break unless idx < grades_size
      s_grades << grade_number(grade_list[idx])
      next_gidx = GRADES.index(grade_list[idx])
      loop do
        idx += 1
        break unless idx < grades_size
        prev_gidx = next_gidx
        next_gidx = GRADES.index(grade_list[idx])
        break unless prev_gidx + 1 == next_gidx
        s_grades[-1] = "#{s_grades[-1][/\w+/]}-#{grade_number(grade_list[idx])}"
      end
    end
    s_grades
  end

  def grade_number(g)
    return 'K' if g == 'kindergarten'
    return 'PK' if g == 'prekindergarten'
    g[/\d+/].try(:to_s)
  end
end
