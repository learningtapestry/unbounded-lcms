ready(function() {
  if ($('#admcur-edt').length > 0) {
    var childItems = $('#cur-edit-items');
    var addChildModal = $('.admcur-edt-child-modal');

    var renderPicker = function() {
      var selectedType = $('#curriculum_curriculum_type_id option:selected').text();
      var picker;

      if (selectedType === 'unit') {
        picker = React.createElement(ResourcePickerWindow, {
          onSelectResource: function(resource) {
            childItems.append($(`
              <li>
                <span class="cur-edit-item-curtype">lesson</span>
                <span class="cur-edit-item-title">${resource.title}</span>
                <span class="cur-edit-item-btn"><button type="button" class="small button remove">Remove</button></span>
                <input type="hidden" name="curriculum[child_ids][]" value="${resource.id}">
              </li>
            `));
            addChildModal.foundation('close');
            childItems.sortable();
          }
        }, null);
      } else {
        picker = React.createElement(CurriculumPickerWindow, {
          onSelectResource: function(curriculum) {
            childItems.append($(`
              <li>
                <span class="cur-edit-item-curtype">${curriculum.curriculum_type}</span>
                <span class="cur-edit-item-title">${curriculum.title}</span>
                <span class="cur-edit-item-btn"><button type="button" class="small button remove">Remove</button></span>
                <input type="hidden" name="curriculum[child_ids][]" value="${curriculum.id}">
              </li>
            `));
            addChildModal.foundation('close');
            childItems.sortable();
          }
        }, null);
      }

      ReactDOM.render(picker, addChildModal[0]);
    };

    new Foundation.Reveal(addChildModal);

    $('.admcur-edt-child-btn').click(function(e) {
      renderPicker();
      addChildModal.foundation('open');
    });


    $(document).on('click', 'button.remove', function(e) {
      $(this).parents('li').remove();
    });

    childItems.sortable();
  }
});
