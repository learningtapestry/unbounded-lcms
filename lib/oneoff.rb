module Oneoff
  def self.fix(issue_num)
    require_relative "./oneoff/issue_#{issue_num}"

    issue_fixer_class = "Oneoff::Issue#{issue_num}".constantize
    issue_fixer_class.new.run
  end
end
