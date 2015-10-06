require 'test_helper'

class LobjectSlugTestCase < TestCase
  uses_integration_database

  def setup
    super
    LobjectSlug.delete_all
  end

  def test_algebra_ii
    col = LobjectCollection.find 715
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/algebra-ii/module-4/topic-3/lesson-9', Lobject.find(6188).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-4/lesson-3', Lobject.find(6106).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-4', Lobject.find(5762).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-4/topic-3', Lobject.find(6179).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-2/lesson-7', Lobject.find(5997).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-2/lesson-4', Lobject.find(5774).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-1/lesson-3', Lobject.find(5914).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-2/lesson-3', Lobject.find(5773).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-3/lesson-6', Lobject.find(6101).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-4/lesson-4', Lobject.find(6107).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-8', Lobject.find(5766).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-3/lesson-2', Lobject.find(6097).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-3/lesson-9', Lobject.find(5790).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-5/lesson-4', Lobject.find(6115).slug_for_collection(col)
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-5', Lobject.find(5763).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-2/lesson-7', Lobject.find(6091).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-6', Lobject.find(5764).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-3/lesson-13', Lobject.find(5794).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-1/lesson-5', Lobject.find(5918).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-3/lesson-5', Lobject.find(5786).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-3/lesson-1', Lobject.find(6095).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-4/topic-1/lesson-7', Lobject.find(6144).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-3/lesson-11', Lobject.find(5792).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-1/topic-1/lesson-10', Lobject.find(5768).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-1/lesson-3', Lobject.find(5914).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-1/lesson-2', Lobject.find(6073).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-3/topic-5/lesson-4', Lobject.find(6115).slug_for_collection(col)
    assert_equal 'math/algebra-ii/module-2/topic-1', Lobject.find(5951).slug_for_collection(col)
  end

  def test_grade_12_english_language_arts
    col = LobjectCollection.find 729
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'ela/grade-12/module-1/unit-2/lesson-2', Lobject.find(6494).slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-15', Lobject.find(6395).slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-18', Lobject.find(6398).slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-7', Lobject.find(6383).slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-1', Lobject.find(6377).slug_for_collection(col)
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-7', Lobject.find(6383).slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-1/lesson-1', Lobject.find(6377).slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-3/lesson-5', Lobject.find(6503).slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1', Lobject.find(6211).slug_for_collection(col)
    assert_equal 'ela/grade-12/module-1/unit-3/lesson-6', Lobject.find(6504).slug_for_collection(col)
  end

  def test_grade_5_mathematics
    col = LobjectCollection.find 710
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/grade-5/module-6/topic-6/lesson-2', Lobject.find(4407).slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-2/lesson-5', Lobject.find(4075).slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-8/lesson-2', Lobject.find(4065).slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-3/lesson-5', Lobject.find(4148).slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-1/lesson-1', Lobject.find(4175).slug_for_collection(col)
    assert_equal 'math/grade-5/module-1/topic-2/lesson-2', Lobject.find(2677).slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-2/lesson-5', Lobject.find(4186).slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-1/lesson-1', Lobject.find(3221).slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-5/lesson-2', Lobject.find(3152).slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-8', Lobject.find(4487).slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-6/lesson-2', Lobject.find(3164).slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-3/lesson-3', Lobject.find(3128).slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-3/lesson-1', Lobject.find(3259).slug_for_collection(col)
    assert_equal 'math/grade-5/module-1/topic-6', Lobject.find(4470).slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-5', Lobject.find(4132).slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-4/lesson-3', Lobject.find(3295).slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-4/lesson-6', Lobject.find(4173).slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-7/lesson-4', Lobject.find(4041).slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-5/lesson-6', Lobject.find(4404).slug_for_collection(col)
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/grade-5/module-5/topic-1/lesson-1', Lobject.find(4067).slug_for_collection(col)
    assert_equal 'math/grade-5/module-3/topic-4/lesson-2', Lobject.find(3216).slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-7/lesson-1', Lobject.find(3184).slug_for_collection(col)
    assert_equal 'math/grade-5/module-1', Lobject.find(931).slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-1/lesson-1', Lobject.find(2846).slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-6', Lobject.find(4133).slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-5/lesson-1', Lobject.find(4392).slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-8/lesson-2', Lobject.find(3194).slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-4/lesson-1', Lobject.find(4250).slug_for_collection(col)
    assert_equal 'math/grade-5/module-1/topic-5', Lobject.find(4469).slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-2', Lobject.find(4181).slug_for_collection(col)
    assert_equal 'math/grade-5/module-1/topic-5/lesson-2', Lobject.find(2687).slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-2/lesson-2', Lobject.find(4071).slug_for_collection(col)
    assert_equal 'math/grade-5/module-5/topic-4/lesson-6', Lobject.find(4173).slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-5/lesson-3', Lobject.find(4395).slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-6/lesson-1', Lobject.find(4031).slug_for_collection(col)
    assert_equal 'math/grade-5/module-2/topic-5/lesson-1', Lobject.find(3148).slug_for_collection(col)
    assert_equal 'math/grade-5/module-6/topic-5/lesson-2', Lobject.find(4393).slug_for_collection(col)
    assert_equal 'math/grade-5/module-4/topic-5/lesson-2', Lobject.find(3502).slug_for_collection(col)
  end

  def test_prekindergarten_mathematics
    col = LobjectCollection.find 741
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/prekindergarten/module-4/topic-1/lesson-1', Lobject.find(6301).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-2/topic-1/lesson-3', Lobject.find(5691).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-5/lesson-4', Lobject.find(5618).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-2', Lobject.find(5596).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-5/lesson-2', Lobject.find(6363).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-7/lesson-4', Lobject.find(6335).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-3/lesson-2', Lobject.find(5605).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-3/lesson-5', Lobject.find(6355).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-2/lesson-3', Lobject.find(5931).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-8/lesson-5', Lobject.find(6047).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-7/lesson-1', Lobject.find(6332).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-6/lesson-2', Lobject.find(6031).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-2/lesson-1', Lobject.find(5597).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-1', Lobject.find(6336).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-3/lesson-2', Lobject.find(6312).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-6/lesson-3', Lobject.find(6328).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-4/lesson-1', Lobject.find(6316).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-2/lesson-2', Lobject.find(5929).slug_for_collection(col)
    col.save
    assert_equal col.tree.size, LobjectSlug.count
    assert_equal 'math/prekindergarten/module-1/topic-7/lesson-1', Lobject.find(5630).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-4', Lobject.find(6315).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-5/lesson-1', Lobject.find(6019).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-4/lesson-1', Lobject.find(6009).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-4/lesson-2', Lobject.find(6317).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-6/lesson-2', Lobject.find(6368).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-2/topic-3', Lobject.find(5698).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-5/topic-2/lesson-3', Lobject.find(6347).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-2', Lobject.find(6306).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-6/lesson-4', Lobject.find(6033).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-2/topic-3/lesson-4', Lobject.find(5702).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-5/lesson-3', Lobject.find(6021).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-8/lesson-5', Lobject.find(6047).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-5/lesson-2', Lobject.find(6321).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-4/topic-5/lesson-1', Lobject.find(6320).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-2/topic-3/lesson-3', Lobject.find(5701).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-1/topic-6/lesson-1', Lobject.find(5622).slug_for_collection(col)
    assert_equal 'math/prekindergarten/module-3/topic-2/lesson-5', Lobject.find(5933).slug_for_collection(col)
  end
end
