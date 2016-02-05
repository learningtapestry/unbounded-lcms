module ResourceRestrictions
  def restrict_resources
    must { term 'hidden' => false }
    must { term 'has_engageny_source' => true }

    [
      'teacher/leader effectiveness',
      'professional development',
      'data driven instruction'
    ].each do |topic|
      must_not do
        nested do
          path 'topics'
          filter do
            term 'topics.name.raw' => topic
          end
        end
      end
    end

    must do
      nested do
        path 'grades'
        filter do
          terms 'grades.grade.raw' => ['grade 9', 'grade 10', 'grade 11', 'grade 12']
        end
      end
    end
  end
end
