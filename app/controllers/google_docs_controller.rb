class GoogleDocsController < ApplicationController
  def show
    @contents = [
      { title: 'Part I: What Do the Standards Say?', level: 0 },
      { title: 'Ratio and rate: essential concepts', level: 1 },
      { title: 'Problem Solving with Ratios and Rates: Essential Tools', level: 1 },
      { title: 'Ratio tables', level: 1 },
      { title: 'Application of Ratios and Rates: Examples', level: 1 },
      { title: 'Part II: How do ratios relate to other parts of Grade 6?', level: 0 },
      { title: 'Expressions and equations: reasoning about one-variable equations', level: 1 },
      { title: 'Expressions and equations: representing relationships between two variables', level: 1 },
      { title: 'Operations with decimals', level: 1 },
      { title: 'Part III: Where did ratios come from, and where are they going?', level: 0 },
      { title: 'Grades 3-5: arithmetic patterns', level: 1 },
      { title: 'Grades 7-8: proportional relationships, linear equations, and functions', level: 1 },
      { title: 'Youtube Video Demo', level: 1 },
      { title: 'Link to another guide', level: 1 },
      { title: 'Links to non-existent documents', level: 1 },
      { title: 'SoundCloud link', level: 1 },
      { title: 'Testing H3 Before second SC link', level: 2 }]
  end
end
