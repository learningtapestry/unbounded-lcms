require 'test_helper'
require 'content/models'

class Unbounded::BrowseControllerTest < ControllerTestCase
  uses_integration_database

  def test_index_ela_curriculum
    get :index
    assert_select '.ela_curriculum_facet li', 14
  end

  def test_index_ela_curriculum_content
    get :index
    assert_select '.ela_curriculum_facet > li:first > a', 'Prekindergarten English Language Arts'
  end

  def test_index_math_curriculum
    get :index
    assert_select '.math_curriculum_facet li', 14
  end

  def test_index_resource_types_facet
    get :index
    assert_select '.resource_type_facet > li:first > a', 'lesson plan'
  end

  def test_index_grades_facet
    get :index
    assert_select '.grade_facet > li:first > a', 'elementary'
  end

  def test_index_topics_facet
    get :index
    assert_select '.topic_facet > li:first > a', 'common core learning standards'
  end

  def test_index_subject_facet
    get :index
    assert_select '.subject_facet > li:first > a', 'english language arts'
  end

  def test_index_alignments_facet
    get :index
    assert_select '.alignment_facet > li:first > a', 'CCLS - ELA.RI.5.1'
  end

  def test_index_status_facet
    get :index
    assert_select '.active_facet > li:first > a', 'active'
  end

end
