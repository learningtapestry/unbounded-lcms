require 'test_helper'

class Admin::StandardsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:admin)
  end

  def standards
    @controller.instance_variable_get(:@standards)
  end

  def test_list_standards
    get 'index'
    assert_response :success
  end

  def test_filter_by_bilingual_stds
    get 'index'
    assert standards.count == 4

    Standard.create(name: 'Bilingual Std',
                    grades:['grade 11'],
                    subject: 'ela',
                    alt_names: ['bilingual-std'],
                    is_language_progression_standard: true)

    get 'index', q: {is_language_progression_standard: '1'}
    assert standards.count == 1
  end

  def test_search_by_name
    get 'index', q: {name: 'mp2'}
    assert standards.count == 1
    assert standards.first.name == 'CCSS.Math.Practice.MP2'
  end

  def test_edit
    get 'edit', id: Standard.first.id
    assert_response :success
  end

  def test_standard_params_when_adding_a_language_progression_file
    ctrl = Admin::StandardsController.new
    file_mock = File.open Rails.root.join('README.md') # open any file instance
    ctrl.params = {
      standard: {
        description: 'blabla',
        language_progression_file: file_mock
      }
    }
    assert ctrl.send(:standard_params)[:is_language_progression_standard] == true
  end

  def test_standard_params_when_removing_language_file
    ctrl = Admin::StandardsController.new
    ctrl.params = {
      standard: {
        description: 'blabla',
        remove_language_progression_file: '1'
      }
    }
    assert ctrl.send(:standard_params)[:is_language_progression_standard] == false
  end
end
