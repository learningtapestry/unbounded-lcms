module DocTemplate
  class XpathFunctions
    def case_insensitive_equals(node_set, str_to_match)
      node_set.find_all { |node| node.to_s.casecmp(str_to_match) == 0 }
    end

    def case_insensitive_contains(node_set, str_to_match)
      node_set.find_all { |node| node.to_s.downcase.include?(str_to_match.to_s.downcase) }
    end
  end
end
