require 'json'
require 'test_helper'

class ApiControllerTest < ControllerTestCase
  def test_show_alignments
    get 'show_alignments'
    expected_names = Lobject.all.map(&:alignments).flatten.uniq.map(&:name)
    actual_names = @json_response.map { |a| a['alignment']['name'] }
    assert_same_elements expected_names, actual_names
  end

  def test_show_alignments_resource_count
    get 'show_alignments'
    expected_counts = Alignment.all
      .map { |a| LobjectAlignment.where(alignment: a).size }
      .select { |c| c != 0 }
    actual_counts = @json_response.map { |a| a['resource_count'].to_i }
    assert_same_elements expected_counts, actual_counts
  end

  def test_show_alignments_search_name
    get 'show_alignments', name: 'CCSS.Math.Practice.MP1'
    assert_equal 'CCSS.Math.Practice.MP1', @json_response[0]['alignment']['name']
    assert_equal 1, @json_response.size
  end

  def test_show_alignments_search_framework
    get 'show_alignments', framework: 'Common Core State Standards for Mathematics'

    assert_equal 'Common Core State Standards for Mathematics', @json_response[0]['alignment']['framework']

    expected_count = Lobject
    .all.map(&:alignments).flatten.uniq
    .select { |a| a.framework == 'Common Core State Standards for Mathematics' }
    .size

    assert_equal expected_count, @json_response.size
  end

  def test_show_alignments_search_framework_url
    get 'show_alignments', framework_url: 'http://asn.jesandco.org/resources/S2366906'
    assert_equal 'http://asn.jesandco.org/resources/S2366906', @json_response[0]['alignment']['framework_url']
    assert_equal 1, @json_response.size
  end

  def test_show_alignments_pagination
    get 'show_alignments', page: 1, limit: 1
    assert_equal 1, @json_response.size

    get 'show_alignments', page: 2, limit: 1
    assert_equal 1, @json_response.size
  end

  def test_show_alignments_header
    get 'show_alignments'
    expected_count = Lobject.all.map(&:alignments).flatten.uniq.size
    assert_equal expected_count, @response.headers['x-total-count'].to_i
  end

  def get(*args, &block)
    super(*args, &block)
    @json_response = JSON.parse(@response.body)
  end
end
