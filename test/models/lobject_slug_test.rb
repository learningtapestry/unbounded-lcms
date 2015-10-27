require 'test_helper'

class LobjectSlugTestCase < TestCase
  uses_integration_database

  def setup
    super
    LobjectSlug.delete_all
  end

  def test_algebra_ii
    col = find_lobject_by_title('Algebra II').lobject_collections.first
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/algebra-ii/module-4/topic-3/lesson-9', find_lobject_by_title('Algebra II Module 4, Topic C, Lesson 20').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-4/lesson-3', find_lobject_by_title('Algebra II Module 3, Topic D, Lesson 25').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-4', find_lobject_by_title('Algebra II Module 1, Topic A, Lesson 4').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-4/topic-3', find_lobject_by_title('Algebra II Module 4, Topic C, Overview').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-2/lesson-7', find_lobject_by_title('Algebra II Module 2, Topic B, Lesson 17').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-2/lesson-4', find_lobject_by_title('Algebra II Module 1, Topic B, Lesson 15').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-1/lesson-3', find_lobject_by_title('Algebra II Module 2, Topic A, Lesson 3').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-2/lesson-3', find_lobject_by_title('Algebra II Module 1, Topic B, Lesson 14').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-3/lesson-6', find_lobject_by_title('Algebra II Module 3, Topic C, Lesson 21').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-4/lesson-4', find_lobject_by_title('Algebra II Module 3, Topic D, Lesson 26').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-8', find_lobject_by_title('Algebra II Module 1, Topic A, Lesson 8').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-3/lesson-2', find_lobject_by_title('Algebra II Module 3, Topic C, Lesson 17').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-3/lesson-9', find_lobject_by_title('Algebra II Module 1, Topic C, Lesson 30').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-5/lesson-4', find_lobject_by_title('Algebra II Module 3, Topic E, Lesson 32').slug_for_collection(col)
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-5', find_lobject_by_title('Algebra II Module 1, Topic A, Lesson 5').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-2/lesson-7', find_lobject_by_title('Algebra II Module 3, Topic B, Lesson 13').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-6', find_lobject_by_title('Algebra II Module 1, Topic A, Lesson 6').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-3/lesson-13', find_lobject_by_title('Algebra II Module 1, Topic C, Lesson 34').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-1/lesson-5', find_lobject_by_title('Algebra II Module 2, Topic A, Lesson 5').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-3/lesson-5', find_lobject_by_title('Algebra II Module 1, Topic C, Lesson 26').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-3/lesson-1', find_lobject_by_title('Algebra II Module 3, Topic C, Lesson 16').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-4/topic-1/lesson-7', find_lobject_by_title('Algebra II Module 4, Topic A, Lesson 7').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-3/lesson-11', find_lobject_by_title('Algebra II Module 1, Topic C, Lesson 32').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-10', find_lobject_by_title('Algebra II Module 1, Topic A, Lesson 10').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-1/lesson-3', find_lobject_by_title('Algebra II Module 2, Topic A, Lesson 3').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-1/lesson-2', find_lobject_by_title('Algebra II Module 3, Topic A, Lesson 2').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-5/lesson-4', find_lobject_by_title('Algebra II Module 3, Topic E, Lesson 32').slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-1', find_lobject_by_title('Algebra II Module 2, Topic A, Overview').slug_for_collection(col)
  end

  def test_grade_12_english_language_arts
    col = find_lobject_by_title('Grade 12 English Language Arts').lobject_collections.first
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'ela/grade-12/module-1/unit-2/lesson-2', find_lobject_by_title('Grade 12 ELA Module 1, Unit 2, Lesson 2').slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-15', find_lobject_by_title('Grade 12 ELA Module 1, Unit 1, Lesson 15').slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-18', find_lobject_by_title('Grade 12 ELA Module 1, Unit 1, Lesson 18').slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-7', find_lobject_by_title('Grade 12 ELA Module 1, Unit 1, Lesson 7').slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-1', find_lobject_by_title('Grade 12 ELA Module 1, Unit 1, Lesson 1').slug_for_collection(col)
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-7', find_lobject_by_title('Grade 12 ELA Module 1, Unit 1, Lesson 7').slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-1', find_lobject_by_title('Grade 12 ELA Module 1, Unit 1, Lesson 1').slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-3/lesson-5', find_lobject_by_title('Grade 12 ELA Module 1, Unit 3, Lesson 5').slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1', find_lobject_by_title('Grade 12  ELA Module 1').slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-3/lesson-6', find_lobject_by_title('Grade 12 ELA Module 1, Unit 3, Lesson 6').slug_for_collection(col)
  end

  def test_grade_5_mathematics
    col = find_lobject_by_title('Grade 5 Mathematics').lobject_collections.first
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/grade-5/module-6/topic-6/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 6, Topic F, Lesson 28').slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-2/lesson-5', find_lobject_by_title('Grade 5 Mathematics Module 5, Topic B, Lesson 8').slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-8/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 4, Topic H, Lesson 33').slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-3/lesson-5', find_lobject_by_title('Grade 5 Mathematics Module 5, Topic C, Lesson 14').slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-1/lesson-1', find_lobject_by_title('Grade 5 Mathematics Module 6, Topic A, Lesson 1').slug_for_collection(col)
    assert_equal 'math/grade-5/module-1/topic-2/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 1, Topic B, Lesson 6').slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-2/lesson-5', find_lobject_by_title('Grade 5 Mathematics Module 6, Topic B, Lesson 11').slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-1/lesson-1', find_lobject_by_title(' Grade 5 Mathematics Module 4, Topic A, Lesson 1').slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-5/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 2, Topic E, Lesson 17').slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-8', find_lobject_by_title('Grade 5 Mathematics Module 2, Topic H Overview').slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-6/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 2, Topic F, Lesson 20').slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-3/lesson-3', find_lobject_by_title('Grade 5 Mathematics Module 2, Topic C, Lesson 12').slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-3/lesson-1', find_lobject_by_title('Grade 5 Mathematics Module 4, Topic C, Lesson 6').slug_for_collection(col)
    assert_equal 'math/grade-5/module-1/topic-6', find_lobject_by_title('Grade 5 Mathematics Module 1, Topic F Overview').slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-5', find_lobject_by_title('Grade 5 Mathematics Module 4, Topic E Overview').slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-4/lesson-3', find_lobject_by_title('Grade 5 Mathematics Module 4, Topic D, Lesson 12').slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-4/lesson-6', find_lobject_by_title('Grade 5 Mathematics Module 5, Topic D, Lesson 21').slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-7/lesson-4', find_lobject_by_title('Grade 5 Mathematics Module 4, Topic G, Lesson 28').slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-5/lesson-6', find_lobject_by_title(' Grade 5 Mathematics Module 6, Topic F, Lesson 26').slug_for_collection(col)
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/grade-5/module-5/topic-1/lesson-1', find_lobject_by_title('Grade 5 Mathematics Module 5, Topic A, Lesson 1').slug_for_collection(col)
    assert_equal 'math/grade-5/module-3/topic-4/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 3, Topic D, Lesson 14').slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-7/lesson-1', find_lobject_by_title('Grade 5 Mathematics Module 2, Topic G, Lesson 24').slug_for_collection(col)
    assert_equal 'math/grade-5/module-1', find_lobject_by_title('Grade 5 Mathematics Module 1').slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-1/lesson-1', find_lobject_by_title('Grade 5 Mathematics Module 2, Topic A, Lesson 1').slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-6', find_lobject_by_title('Grade 5 Mathematics Module 4, Topic F Overview').slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-5/lesson-1', find_lobject_by_title('Grade 5 Mathematics Module 6, Topic E, Lesson 21').slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-8/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 2, Topic H, Lesson 29').slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-4/lesson-1', find_lobject_by_title('Grade 5 Mathematics Module 6, Topic D, Lesson 18').slug_for_collection(col)
    assert_equal 'math/grade-5/module-1/topic-5', find_lobject_by_title('Grade 5 Mathematics Module 1, Topic E Overview').slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-2', find_lobject_by_title('Grade 5 Mathematics Module 6, Topic B Overview').slug_for_collection(col)
    assert_equal 'math/grade-5/module-1/topic-5/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 1, Topic E, Lesson 12').slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-2/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 5, Topic B, Lesson 5').slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-4/lesson-6', find_lobject_by_title('Grade 5 Mathematics Module 5, Topic D, Lesson 21').slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-5/lesson-3', find_lobject_by_title('Grade 5 Mathematics Module 6, Topic E, Lesson 23').slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-6/lesson-1', find_lobject_by_title('Grade 5 Mathematics Module 4, Topic F, Lesson 21').slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-5/lesson-1', find_lobject_by_title('Grade 5 Mathematics Module 2, Topic E, Lesson 16').slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-5/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 6, Topic E, Lesson 22').slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-5/lesson-2', find_lobject_by_title('Grade 5 Mathematics Module 4, Topic E, Lesson 14').slug_for_collection(col)
  end

  def test_prekindergarten_mathematics
    col = find_lobject_by_title('Prekindergarten Mathematics').lobject_collections.first
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/prekindergarten/module-4/topic-1/lesson-1', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic A, Lesson 1').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-2/topic-1/lesson-3', find_lobject_by_title('Prekindergarten Mathematics, Module 2, Topic A, Lesson 3').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-5/lesson-4', find_lobject_by_title('Prekindergarten Mathematics Module 1, Topic E, Lesson 18').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-2', find_lobject_by_title('Prekindergarten Mathematics, Module 1, Topic B Overview').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-5/lesson-2', find_lobject_by_title('Prekindergarten Mathematics Module 5, Topic E, Lesson 21').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-7/lesson-4', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic G, Lesson 27').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-3/lesson-2', find_lobject_by_title('Prekindergarten Mathematics, Module 1, Topic C, Lesson 9').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-3/lesson-5', find_lobject_by_title('Prekindergarten Mathematics Module 5, Topic C, Lesson 15').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-2/lesson-3', find_lobject_by_title('Prekindergarten Mathematics, Module 3, Topic B, Lesson 8').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-8/lesson-5', find_lobject_by_title('Prekindergarten Mathematics Module 3, Topic H, Lesson 39').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-7/lesson-1', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic G, Lesson 24').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-6/lesson-2', find_lobject_by_title('Prekindergarten Mathematics Module 3, Topic F, Lesson 27').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-2/lesson-1', find_lobject_by_title('PreKindergarten Mathematics, Module 1, Topic B, Lesson 5').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-1', find_lobject_by_title('Prekindergarten Mathematics Module 5, Topic A').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-3/lesson-2', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic C, Lesson 10').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-6/lesson-3', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic F, Lesson 21').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-4/lesson-1', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic D, Lesson 13').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-2/lesson-2', find_lobject_by_title('Prekindergarten Mathematics, Module 3, Topic B, Lesson 7').slug_for_collection(col)
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/prekindergarten/module-1/topic-7/lesson-1', find_lobject_by_title('Prekindergarten Mathematics Module 1, Topic G, Lesson 28').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-4', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic D').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-5/lesson-1', find_lobject_by_title('Prekindergarten Mathematics Module 3, Topic E, Lesson 21').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-4/lesson-1', find_lobject_by_title('Prekindergarten Mathematics Module 3, Topic D, Lesson 16').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-4/lesson-2', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic D, Lesson 14').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-6/lesson-2', find_lobject_by_title('Prekindergarten Mathematics Module 5, Topic F, Lesson 25').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-2/topic-3', find_lobject_by_title('Prekindergarten Mathematics Module 2, Topic C Overview').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-2/lesson-3', find_lobject_by_title('Prekindergarten Mathematics Module 5, Topic B, Lesson 8').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-2', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic B').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-6/lesson-4', find_lobject_by_title('Prekindergarten Mathematics Module 3, Topic F, Lesson 29').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-2/topic-3/lesson-4', find_lobject_by_title('Prekindergarten Mathematics Module 2, Topic C, Lesson 12').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-5/lesson-3', find_lobject_by_title('Prekindergarten Mathematics Module 3, Topic E, Lesson 23').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-8/lesson-5', find_lobject_by_title('Prekindergarten Mathematics Module 3, Topic H, Lesson 39').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-5/lesson-2', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic E, Lesson 17').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-5/lesson-1', find_lobject_by_title('Prekindergarten Mathematics Module 4, Topic E, Lesson 16').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-2/topic-3/lesson-3', find_lobject_by_title('Prekindergarten Mathematics Module 2, Topic C, Lesson 11').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-6/lesson-1', find_lobject_by_title('Prekindergarten Mathematics Module 1, Topic F, Lesson 21').slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-2/lesson-5', find_lobject_by_title('Prekindergarten Mathematics, Module 3, Topic B, Lesson 10').slug_for_collection(col)
  end

  def find_lobject_by_title(title)
    LobjectTitle.find_by(title: title).lobject
  end
end
