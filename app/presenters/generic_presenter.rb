class GenericPresenter < ResourcePresenter
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
    return '' unless grade_list.any?
    "Grade #{grade_numbers.join(', ')}"
  end

  private

  def sorted_grade_list
    (grade_list & GradeListHelper::GRADES).sort_by { |g| GradeListHelper::GRADES.index(g) }
  end

  def grade_numbers
    grades_sorted = sorted_grade_list
    grades_size = grades_sorted.size
    grade_strs = []
    idx = prev_gidx = next_gidx = 0
    while idx < grades_size
      next_gidx = GradeListHelper::GRADES.index(grades_sorted[idx])
      current_grade_str = grade_number(grades_sorted[idx])
      idx += 1
      while idx < grades_size
        prev_gidx = next_gidx
        next_gidx = GradeListHelper::GRADES.index(grades_sorted[idx])
        if prev_gidx + 1 == next_gidx
          current_grade_str = "#{current_grade_str[/\w+/]}-#{grade_number(grades_sorted[idx])}"
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
