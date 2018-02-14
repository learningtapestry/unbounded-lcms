# frozen_string_literal: true

module DocTemplate
  class XpathFunctions
    def case_insensitive_equals(node_set, str_to_match)
      node_set.find_all { |node| node.to_s.casecmp(str_to_match).zero? }
    end

    def case_insensitive_contains(node_set, str_to_match)
      node_set.find_all { |node| node.to_s.downcase.include?(str_to_match.to_s.downcase) }
    end

    def case_regular(node_set, re_to_match)
      node_set.to_s =~ Regexp.new(re_to_match, true) ? node_set : []
    end
  end
end
