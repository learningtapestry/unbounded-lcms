# frozen_string_literal: true

# Referring to issue #953

SUBJECTS = %w(ela math).freeze

task = Rake::Task['resources:json_import']

SUBJECTS.each do |sub|
  Grades::GRADES.each do |grade|
    task.invoke "#{sub}/#{grade}"
    task.reenable
  end
end
