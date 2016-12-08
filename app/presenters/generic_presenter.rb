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
    return '' unless grades.any?
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
    grade_strs = []
    idx = prev_gidx = next_gidx = 0
    while idx < grades_size
      next_gidx = GRADES.index(grade_list[idx])
      current_grade_str = grade_number(grade_list[idx])
      idx += 1
      while idx < grades_size
        prev_gidx = next_gidx
        next_gidx = GRADES.index(grade_list[idx])
        if prev_gidx + 1 == next_gidx
          current_grade_str = "#{current_grade_str[/\w+/]}-#{grade_number(grade_list[idx])}"
          idx += 1
        else
          break
        end
      end
      grade_strs << current_grade_str
    end
    grade_strs
  end

  def grade_number(g)
    return 'K' if g == 'kindergarten'
    return 'PK' if g == 'prekindergarten'
    g[/\d+/].try(:to_s)
  end
end
