module Unbounded
  module LobjectRestrictions
    def restrict_lobjects
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

      (9..12).each do |g|
        should do
          nested do
            path 'grades'
            filter do
              term 'grades.grade.raw' => "grade #{g}"
            end
          end
        end
      end
    end
  end
end
