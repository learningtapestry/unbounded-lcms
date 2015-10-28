require 'test_helper'

class SearchResultsTestCase < IntegrationDatabaseTestCase
  RANGE = (1..3)

  def setup
    super
    visit '/search'
  end

  def test_492
    test_search(492, 'Grade 10 ELA, Making Evidence-Based Claims Unit: Martin Luther King, Barack Obama', 'grade 10 ela making evidence-based claims unit: martin luther king barack obama')
  end

  def test_493
    test_search(493, 'Grade 11 ELA, Making Evidence-Based Claims Unit: W. E. B. Du Bois', 'grade 11 ela making evidence-based claims unit: w. e. b. du bois')
  end

  def test_881
    test_search(881, 'Grade 10 ELA Module 1', 'grade 10 ela module 1')
  end

  def test_903
    test_search(903, 'Algebra I Module 2', 'algebra i module 2')
  end

  def test_3182
    test_search(3182, 'Algebra I Module 1, Topic B, Lesson 8', 'algebra i module 1 topic b lesson 8')
  end

  def test_3200
    test_search(3200, 'Algebra I Module 1, Topic C, Lesson 17', 'algebra i module 1 topic c lesson 17')
  end

  def test_3204
    test_search(3204, 'Algebra I Module 1, Topic C, Lesson 18', 'algebra i module 1 topic c lesson 18')
  end

  def test_3229
    test_search(3229, 'Algebra I Module 1, Topic C, Lesson 23', 'algebra i module 1 topic c lesson 23')
  end

  def test_3236
    test_search(3236, 'Algebra I Module 2, Topic A, Lesson 2', 'algebra i module 2 topic a lesson 2')
  end

  def test_3243
    test_search(3243, 'Algebra I Module 2, Topic C, Lesson 9', 'algebra i module 2 topic c lesson 9')
  end

  def test_3244
    test_search(3244, 'Algebra I Module 2, Topic C, Lesson 10', 'algebra i module 2 topic c lesson 10')
  end

  def test_3246
    test_search(3246, 'Algebra I Module 2, Topic D, Lesson 12', 'algebra i module 2 topic d lesson 12')
  end

  def test_3262
    test_search(3262, 'Algebra I Module 2, Topic D, Lesson 16', 'algebra i module 2 topic d lesson 16')
  end

  def test_3372
    test_search(3372, 'Algebra I Module 4, Topic A, Lesson 10', 'algebra i module 4 topic a lesson 10')
  end

  def test_3514
    test_search(3514, 'Geometry Module 1, Topic B, Lesson 9', 'geometry module 1 topic b lesson 9')
  end

  def test_3518
    test_search(3518, 'Geometry Module 1, Topic C, Lesson 13', 'geometry module 1 topic c lesson 13')
  end

  def test_3578
    test_search(3578, 'Geometry Module 1, Topic D, Lesson 26', 'geometry module 1 topic d lesson 26')
  end

  def test_3594
    test_search(3594, 'Geometry Module 1, Topic E, Lesson 30', 'geometry module 1 topic e lesson 30')
  end

  def test_3599
    test_search(3599, 'Geometry Module 1, Topic G, Lesson 33', 'geometry module 1 topic g lesson 33')
  end

  def test_3865
    test_search(3865, 'Geometry Module 1, Topic B, Overview', 'geometry module 1 topic b overview')
  end

  def test_3885
    test_search(3885, 'Algebra I Module 1, Topic B, Overview', 'algebra i module 1 topic b overview')
  end

  def test_4576
    test_search(4576, 'Grade 9 ELA Module 1, Unit 3, Lesson 11', 'grade 9 ela module 1 unit 3 lesson 11')
  end

  def test_4667
    test_search(4667, 'Grade 9 ELA Module 1, Unit 3, Lesson 15', 'grade 9 ela module 1 unit 3 lesson 15')
  end

  def test_4683
    test_search(4683, 'Grade 9 ELA Module 1, Unit 3, Lesson 19', 'grade 9 ela module 1 unit 3 lesson 19')
  end

  def test_4715
    test_search(4715, 'Grade 9 ELA Module 2, Unit 1, Lesson 3', 'grade 9 ela module 2 unit 1 lesson 3')
  end

  def test_4723
    test_search(4723, 'Grade 9 ELA Module 2, Unit 1, Lesson 10', 'grade 9 ela module 2 unit 1 lesson 10')
  end

  def test_4746
    test_search(4746, 'Grade 9 ELA Module 2, Unit 2, Lesson 15', 'grade 9 ela module 2 unit 2 lesson 15')
  end

  def test_4757
    test_search(4757, 'Grade 9 ELA Module 2, Unit 3, Lesson 4', 'grade 9 ela module 2 unit 3 lesson 4')
  end

  def test_4777
    test_search(4777, 'Grade 9 ELA Module 3, Unit 1, Lesson 8', 'grade 9 ela module 3 unit 1 lesson 8')
  end

  def test_4782
    test_search(4782, 'Grade 9 ELA Module 3, Unit 2, Lesson 1', 'grade 9 ela module 3 unit 2 lesson 1')
  end

  def test_4785
    test_search(4785, 'Grade 9 ELA Module 3, Unit 2, Lesson 4', 'grade 9 ela module 3 unit 2 lesson 4')
  end

  def test_4790
    test_search(4790, 'Grade 9 ELA Module 3, Unit 2, Lesson 9', 'grade 9 ela module 3 unit 2 lesson 9')
  end

  def test_4810
    test_search(4810, 'Grade 9 ELA Module 4, Unit 1, Lesson 7', 'grade 9 ela module 4 unit 1 lesson 7')
  end

  def test_4834
    test_search(4834, 'Grade 9 ELA Module 4, Unit 1, Lesson 26', 'grade 9 ela module 4 unit 1 lesson 26')
  end

  def test_4844
    test_search(4844, 'Grade 10 ELA Module 1, Lesson 6', 'grade 10 ela module 1 lesson 6')
  end

  def test_4849
    test_search(4849, 'Grade 10 ELA Module 1, Unit 2, Lesson 3', 'grade 10 ela module 1 unit 2 lesson 3')
  end

  def test_4852
    test_search(4852, 'Grade 10 ELA Module 1, Unit 2, Lesson 6', 'grade 10 ela module 1 unit 2 lesson 6')
  end

  def test_4868
    test_search(4868, 'Grade 10 ELA Module 1, Unit 3, Lesson 5', 'grade 10 ela module 1 unit 3 lesson 5')
  end

  def test_4874
    test_search(4874, 'Grade 10 ELA Module 1, Unit 3, Lesson 11', 'grade 10 ela module 1 unit 3 lesson 11')
  end

  def test_4934
    test_search(4934, 'Grade 10 ELA Module 2, Unit 2, Lesson 5', 'grade 10 ela module 2 unit 2 lesson 5')
  end

  def test_4935
    test_search(4935, 'Grade 10 ELA Module 2, Unit 2, Lesson 6', 'grade 10 ela module 2 unit 2 lesson 6')
  end

  def test_4945
    test_search(4945, 'Grade 10 ELA Module 2, Unit 3, Lesson 3', 'grade 10 ela module 2 unit 3 lesson 3')
  end

  def test_4982
    test_search(4982, 'Grade 10 ELA Module 3, Unit 2, Lesson 1', 'grade 10 ela module 3 unit 2 lesson 1')
  end

  def test_4996
    test_search(4996, 'Grade 10 ELA Module 3, Unit 2, Lesson 11', 'grade 10 ela module 3 unit 2 lesson 11')
  end

  def test_5011
    test_search(5011, 'Grade 10 ELA Module 3, Unit 3, Lesson 9', 'grade 10 ela module 3 unit 3 lesson 9')
  end

  def test_5015
    test_search(5015, 'Grade 11 ELA Module 1, Unit 1', 'grade 11 ela module 1 unit 1')
  end

  def test_5018
    test_search(5018, 'Grade 11 ELA Module 1, Unit 1, Lesson 2', 'grade 11 ela module 1 unit 1 lesson 2')
  end

  def test_5031
    test_search(5031, 'Grade 11 ELA Module 1, Unit 1, Lesson 5', 'grade 11 ela module 1 unit 1 lesson 5')
  end

  def test_5050
    test_search(5050, 'Grade 11 ELA Module 1, Unit 2, Lesson 11', 'grade 11 ela module 1 unit 2 lesson 11')
  end

  def test_5057
    test_search(5057, 'Grade 11 ELA Module 1, Unit 2, Lesson 16', 'grade 11 ela module 1 unit 2 lesson 16')
  end

  def test_5062
    test_search(5062, 'Grade 11 ELA Module 1, Unit 2, Lesson 20', 'grade 11 ela module 1 unit 2 lesson 20')
  end

  def test_5074
    test_search(5074, 'Grade 11 ELA Module 1, Unit 3, Lesson 2', 'grade 11 ela module 1 unit 3 lesson 2')
  end

  def test_5094
    test_search(5094, 'Grade 9 English Language Arts', 'grade 9 english language arts')
  end

  def test_5105
    test_search(5105, 'Grade 10 English Language Arts', 'grade 10 english language arts')
  end

  def test_5107
    test_search(5107, 'Algebra I', 'algebra i')
  end

  def test_5108
    test_search(5108, 'Geometry', 'geometry')
  end

  def test_5149
    test_search(5149, 'Grade 11 English Language Arts', 'grade 11 english language arts')
  end

  def test_5251
    test_search(5251, 'Algebra II', 'algebra ii')
  end

  def test_5252
    test_search(5252, 'Precalculus and Advanced Topics', 'precalculus and advanced topics')
  end

  def test_5393
    test_search(5393, 'Grade 12 English Language Arts', 'grade 12 english language arts')
  end

  def test_5645
    test_search(5645, 'Grade 10 ELA Module 4, Unit 1, Lesson 4', 'grade 10 ela module 4 unit 1 lesson 4')
  end

  def test_5669
    test_search(5669, 'Grade 10 ELA Module 4, Unit 2, Lesson 19', 'grade 10 ela module 4 unit 2 lesson 19')
  end

  def test_5679
    test_search(5679, 'Grade 10 ELA Module 4, Unit 3', 'grade 10 ela module 4 unit 3')
  end

  def test_5758
    test_search(5758, 'Algebra II Module 1, Topic A, Overview', 'algebra ii module 1 topic a overview')
  end

  def test_5774
    test_search(5774, 'Algebra II Module 1, Topic B, Lesson 15', 'algebra ii module 1 topic b lesson 15')
  end

  def test_5782
    test_search(5782, 'Algebra II Module 1, Topic C, Lesson 22', 'algebra ii module 1 topic c lesson 22')
  end

  def test_5792
    test_search(5792, 'Algebra II Module 1, Topic C, Lesson 32', 'algebra ii module 1 topic c lesson 32')
  end

  def test_5806
    test_search(5806, 'Algebra II Module 1, Topic D, Lesson 40', 'algebra ii module 1 topic d lesson 40')
  end

  def test_5909
    test_search(5909, 'Algebra II Module 2', 'algebra ii module 2')
  end

  def test_5918
    test_search(5918, 'Algebra II Module 2, Topic A, Lesson 5', 'algebra ii module 2 topic a lesson 5')
  end

  def test_5943
    test_search(5943, 'Algebra II Module 2, Topic B, Overview', 'algebra ii module 2 topic b overview')
  end

  def test_5962
    test_search(5962, 'Geometry Module 4, Topic A, Lesson 2', 'geometry module 4 topic a lesson 2')
  end

  def test_6080
    test_search(6080, 'Algebra II Module 3, Topic A, Lesson 5', 'algebra ii module 3 topic a lesson 5')
  end

  def test_6100
    test_search(6100, 'Algebra II Module 3, Topic C, Lesson 20', 'algebra ii module 3 topic c lesson 20')
  end

  def test_6101
    test_search(6101, 'Algebra II Module 3, Topic C, Lesson 21', 'algebra ii module 3 topic c lesson 21')
  end

  def test_6127
    test_search(6127, 'Algebra II Module 4, Topic A, Lesson 2', 'algebra ii module 4 topic a lesson 2')
  end

  def test_6176
    test_search(6176, 'Algebra II Module 4, Topic B, Lesson 9', 'algebra ii module 4 topic b lesson 9')
  end

  def test_6180
    test_search(6180, 'Algebra II Module 4, Topic C, Lesson 12', 'algebra ii module 4 topic c lesson 12')
  end

  def test_6182
    test_search(6182, 'Algebra II Module 4, Topic C, Lesson 14', 'algebra ii module 4 topic c lesson 14')
  end

  def test_6187
    test_search(6187, 'Algebra II Module 4, Topic C, Lesson 19', 'algebra ii module 4 topic c lesson 19')
  end

  def test_6192
    test_search(6192, 'Algebra II Module 4, Topic D, Lesson 23', 'algebra ii module 4 topic d lesson 23')
  end

  def test_6204
    test_search(6204, 'Algebra II Module 4, Topic D, Lesson 29', 'algebra ii module 4 topic d lesson 29')
  end

  def test_6230
    test_search(6230, 'Geometry Module 2, Topic A, Lesson 2', 'geometry module 2 topic a lesson 2')
  end

  def test_6269
    test_search(6269, 'Geometry Module 2, Topic E, Lesson 26', 'geometry module 2 topic e lesson 26')
  end

  def test_6272
    test_search(6272, 'Geometry Module 2, Topic E, Lesson 29', 'geometry module 2 topic e lesson 29')
  end

  def test_6277
    test_search(6277, 'Geometry Module 2, Topic E, Lesson 34', 'geometry module 2 topic e lesson 34')
  end

  def test_6378
    test_search(6378, 'Grade 12 ELA Module 1, Unit 1, Lesson 2', 'grade 12 ela module 1 unit 1 lesson 2')
  end

  def test_6394
    test_search(6394, 'Grade 12 ELA Module 1, Unit 1, Lesson 14', 'grade 12 ela module 1 unit 1 lesson 14')
  end

  def test_6397
    test_search(6397, 'Grade 12 ELA Module 1, Unit 1, Lesson 17', 'grade 12 ela module 1 unit 1 lesson 17')
  end

  def test_6540
    test_search(6540, 'Grade 11 ELA Module 2, Unit 2, Lesson 3', 'grade 11 ela module 2 unit 2 lesson 3')
  end

  def test_6548
    test_search(6548, 'Grade 11 ELA Module 2, Unit 2, Lesson 9', 'grade 11 ela module 2 unit 2 lesson 9')
  end

  def test_6552
    test_search(6552, 'Grade 11 ELA Module 2, Unit 2, Lesson 13', 'grade 11 ela module 2 unit 2 lesson 13')
  end

  def test_6590
    test_search(6590, 'Precalculus and Advanced Topics Module 1, Topic C, Lesson 21', 'precalculus and advanced topics module 1 topic c lesson 21')
  end

  def test_6600
    test_search(6600, 'Precalculus and Advanced Topics Module 2, Topic A, Overview', 'precalculus and advanced topics module 2 topic a overview')
  end

  def test_6603
    test_search(6603, 'Precalculus and Advanced Topics Module 4', 'precalculus and advanced topics module 4')
  end

  def test_6618
    test_search(6618, 'Precalculus and Advanced Topics Module 2, Topic C, Lesson 14', 'precalculus and advanced topics module 2 topic c lesson 14')
  end

  def test_6624
    test_search(6624, 'Precalculus and Advanced Topics Module 2, Topic D, Overview', 'precalculus and advanced topics module 2 topic d overview')
  end

  def test_6631
    test_search(6631, 'Precalculus and Advanced Topics Module 2, Topic D, Lesson 22', 'precalculus and advanced topics module 2 topic d lesson 22')
  end

  def test_6653
    test_search(6653, 'Precalculus and Advanced Topics Module 5', 'precalculus and advanced topics module 5')
  end

  def test_6730
    test_search(6730, 'Geometry Module 5, Topic A, Lesson 2', 'geometry module 5 topic a lesson 2')
  end

  def test_6731
    test_search(6731, 'Geometry Module 5, Topic A, Lesson 3', 'geometry module 5 topic a lesson 3')
  end

  def test_6742
    test_search(6742, 'Geometry Module 5, Topic C, Lesson 11', 'geometry module 5 topic c lesson 11')
  end

  def test_6748
    test_search(6748, 'Geometry Module 5, Topic D Overview', 'geometry module 5 topic d overview')
  end

  def test_6758
    test_search(6758, 'Precalculus and Advanced Topics Module 3, Topic A, Lesson 3', 'precalculus and advanced topics module 3 topic a lesson 3')
  end

  def test_6762
    test_search(6762, 'Precalculus and Advanced Topics Module 3, Topic A, Lesson 7', 'precalculus and advanced topics module 3 topic a lesson 7')
  end

  def test_6773
    test_search(6773, 'Precalculus and Advanced Topics Module 3, Topic B, Lesson 16', 'precalculus and advanced topics module 3 topic b lesson 16')
  end

  def test_6802
    test_search(6802, 'Precalculus and Advanced Topics Module 4, Topic B, Lesson 9', 'precalculus and advanced topics module 4 topic b lesson 9')
  end

  def test_6804
    test_search(6804, 'Precalculus and Advanced Topics, Module 4, Topic C Overview', 'precalculus and advanced topics module 4 topic c overview')
  end

  def test_6809
    test_search(6809, 'Precalculus and Advanced Topics Module 5 Topic A', 'precalculus and advanced topics module 5 topic a')
  end

  def test_6821
    test_search(6821, 'Precalculus and Advanced Topics Module 5, Topic B, Lesson 8', 'precalculus and advanced topics module 5 topic b lesson 8')
  end

  def test_6822
    test_search(6822, 'Precalculus and Advanced Topics Module 5, Topic B, Lesson 9', 'precalculus and advanced topics module 5 topic b lesson 9')
  end

  def test_6824
    test_search(6824, 'Precalculus and Advanced Topics Module 5, Topic B, Lesson 11', 'precalculus and advanced topics module 5 topic b lesson 11')
  end

  private
    def generate_test(lobject)
      id = lobject.id
      title = lobject.title.strip.gsub("'", "\'")
      search_term = title.gsub(',', '').gsub("'", '').strip.downcase

      if title =~ /Mathematics/
        "def test_#{id}\n" <<
        "  test_search(#{id}, '#{title}', '#{search_term}')\n" <<
        "  test_search(#{id}, '#{title}', '#{search_term.gsub('mathematics', 'math')}')\n" <<
        "end\n\n"
      else
        "def test_#{id}\n" <<
        "  test_search(#{id}, '#{title}', '#{search_term}')\n" <<
        "end\n\n"
      end
    end

    def generate_tests
      root_ids =
        Lobject.
          select('DISTINCT lobjects.id').
          joins('INNER JOIN lobject_collections ON lobject_collections.lobject_id = lobjects.id').
          where(lobject_collections: { id: LobjectCollection.curriculum_maps }).
          pluck(:id)

      children_ids =
        Lobject.
          select('DISTINCT lobjects.id').
          joins('INNER JOIN lobject_children ON lobject_children.child_id = lobjects.id').
          where(lobject_children: { lobject_collection: LobjectCollection.curriculum_maps }).
          pluck(:id)

      lobjects =
        Lobject.
          joins(:grades).
          where(grades: { grade: ['grade 9', 'grade 10', 'grade 11', 'grade 12'] }).
          where(lobjects: { id: root_ids + children_ids.sample(children_ids.size / 10) }).
          includes(:lobject_titles)
      
      lobjects.map { |lobject| generate_test(lobject) }
    end

    def test_search(id, title, search_term)
      resource = Lobject.find(id)
      assert_equal title, resource.title.strip

      within '#form-search' do
        fill_in 'query', with: search_term
        click_button 'Search'
      end

      result_titles = find_all('.search-results h5 a').map(&:text)
      position = (result_titles.index(title) + 1) rescue nil

      message = "When searching for '#{search_term}', '#{title}' is expected to be within first #{RANGE.last} results, but actually is " + (position ? "at #{position.ordinalize} position" : 'missing')

      assert RANGE.include?(position), message
    end
end
