require 'test_helper'

module Unbounded
  class LobjectCollectionsTestCase < IntegrationTestCase
    def setup
      super

      @admin           = users(:admin)
      @collection_type = lobject_collection_types(:curriculum_map)
      @lobject         = lobjects(:unbounded)

      login_as @admin
    end

    def test_new_lobject_collection
      visit '/admin/collections'
      click_link 'Add Learning Objects Collection'
      click_button 'Save'
      assert_equal find('.form-group.content_models_lobject_collection_lobject.has-error .help-block').text, "can't be blank"

      select @collection_type.name, from: 'Collection Type'
      select @lobject.title,        from: 'Root Learning Object'
      click_button 'Save'
      collection = LobjectCollection.last
      assert_equal collection.lobject_collection_type, @collection_type
      assert_equal collection.lobject, @lobject
      assert_equal current_path, "/admin/collections/#{collection.id}/edit"
      assert_equal find('.alert.alert-success').text, '× Learning Objects Collection created successfully.'
    end

    def test_edit_collection
      collection = lobject_collections(:easol)

      visit '/admin'
      click_link 'Collections'
      within "#collection_#{collection.id}" do
        click_link 'Edit'
      end
      assert_equal current_path, "/admin/collections/#{collection.id}/edit"
      select @collection_type.name, from: 'Collection Type'
      click_button 'Save'
      collection.reload
      assert_equal collection.lobject_collection_type, @collection_type
      assert_equal current_path, "/admin/collections/#{collection.id}"
    end

    def test_delete_collection_from_index_page
      collection = lobject_collections(:easol)
      visit '/admin/collections'
      within "#collection_#{collection.id}" do
        click_button 'Delete'
      end
      assert_nil LobjectCollection.find_by_id(collection.id)
      assert_equal current_path, '/admin/collections'
      assert_equal find('.alert.alert-success').text, "× Learning Objects Collection ##{collection.id} was deleted successfully."
    end

    def test_delete_collection_from_show_page
      collection = lobject_collections(:unbounded)
      visit '/admin/collections'
      click_link collection.lobject.title
      assert_equal current_path, "/admin/collections/#{collection.id}"
      click_button 'Delete'
      assert_nil LobjectCollection.find_by_id(collection.id)
      assert_equal current_path, '/admin/collections'
      assert_equal find('.alert.alert-success').text, "× Learning Objects Collection ##{collection.id} was deleted successfully."
    end
  end
end
