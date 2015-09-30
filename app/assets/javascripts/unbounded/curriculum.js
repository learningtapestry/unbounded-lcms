Unbounded = {
  linkToLesson: function(id) {
    return Routes.unbounded_show_path(id);
  }
};

(function() {
  var curriculumViewModel = {
    ela: {
      curriculumType: 'ela',
      items: ko.observableArray()
    },
    math: {
      curriculumType: 'math',
      items: ko.observableArray()
    },
    highlights: ko.observableArray(),
    isHighlighted: function(id) {
      return this.findHighlights(id).length > 0;
    },
    findHighlights: function(id) {
      return _.filter(this.highlights(), function(alignment) {
        return _.some(alignment.highlights, function(lobjectId) {
          return lobjectId == id;
        });
      });
    },
    interval: function(from, to) {
      var interval = [];
      for (; from < to; from++) {
        interval.push(from);
      }
      return interval;
    },
    moduleTitle: function(curriculumType, $data) {
      var tKey = 'unbounded.curriculum.' + curriculumType + '_module_label';
      return t(tKey) + ' ' + ($data.position+1);
    },
    moduleDescription: function(curriculumType, $data) {
      return $data.title;
    },
    moduleUiLength: function($data, chunkSize) {
      return _.reduce($data.children, function(result, val, key) {
        var sum = val.children.length ? Math.ceil(val.children.length / chunkSize) : 1;
        return result + sum;
      }, 0);
    },
    unitTitle: function(curriculumType, $data) {
      var tKey = 'unbounded.curriculum.' + curriculumType + '_unit_label';
      return t(tKey) + ' ' + ($data.position+1);
    },
    openResourcePreview: function($data, e) {
      e.stopPropagation();
      var $context = ko.contextFor(e.target);
      var $elm = $(e.target).parents('a');
      initializePopover($elm);

      if ('description' in $data) {
        openPopover($elm, $context);
      }
      else {
        $.ajax({
          dataType: 'json',
          url: Routes.unbounded_resource_preview_path(),
          data: { id: $data.id },
          success: function(data) {
            _.extend($data, data.lobject_preview);

            if ($elm.is(':hover')) {
              openPopover($elm, $context);
            }
          }
        });
      }
    },
    closeResourcePreview: function($data, e) {
      e.stopPropagation();
      var $elm = $(e.target).parents('a');
      setTimeout(function () {
        if (!$('.popover:hover').length) { 
          $elm.popover('hide');
        }
      }, 50);
    },
    computeId: function(prefix, $data) {
      return prefix + "-" + $data.id;
    },
    chunked: function($data, size) {
      var chunks = _.chunk($data.children, size);
      var newDatas = [];
      for (var i = 0; i < chunks.length; i++) {
        var newData = _.omit($data, 'children');
        newData.children = chunks[i];
        newData.chunk = i;
        newData.chunks = chunks.length;
        newDatas.push(newData);
      }
      return newDatas;
    },
    alignmentDescription: function(alignmentId) {
      return _.result(_.find(this.alignments, function(alignment) {
        return alignment.value == alignmentId;
      }), 'text');
    },
    findAlignmentDescriptions: function(id) {
      var that = this;
      return _.map(this.findHighlights(id), function(highlight) {
        return that.alignmentDescription(parseInt(highlight.alignment));
      }).join(', ');
    }
  };

  function initializePopover($elm) {
    $('.popover').popover('hide');
    var popover = $elm.data('bs.popover');
    if (!popover) {
      $elm.popover({
        html: true,
        content: 'Loading',
        template: $('#popover-template').html()
      }).popover('show');
    }
  }

  function openPopover($elm, $context) {
    var popover = $elm.data('bs.popover');
    var rendered = $('<div />');
    ko.renderTemplate(
      'resource-preview-template',
      $context,
      null,
      rendered[0],
      'replaceChildren'
    );
    popover.options.content = rendered.html();
    popover.options.title = $context.$data.title;
    popover.show();
  }

  function dropdowns(dropdownClass) {
    if (dropdownClass) {
      return $('select.curriculum-filter-' + dropdownClass);
    }
    return $('select.curriculum-filter');
  }

  function formState() {
    return $('.curriculum-search-form').serialize();
  }

  function updateCurriculums(data) {
    var c = data.curriculums;
    curriculumViewModel.ela.items(c.curriculums.ela);
    curriculumViewModel.math.items(c.curriculums.math);
    curriculumViewModel.highlights(c.highlights);
    curriculumViewModel.alignments = data.dropdown_options.alignment;
  }

  function updateDropdown(promise, dropdownClass) {
    var dropdown = dropdowns(dropdownClass)[0].selectize;
    var oldValue = dropdown.getValue();
    dropdown.disable();

    dropdown.load(function(callback) {
      promise.done(function(data) {
        dropdown.clearOptions();
        callback(data.dropdown_options[dropdownClass]);
        dropdown.enable();
        dropdown.setValue(oldValue, true);
      });
    });
  }

  function fetchCurriculums() {
    return $.ajax({
      dataType: 'json',
      url: Routes.unbounded_search_curriculum_path(),
      data: formState()
    });
  }

  function onDropdownChange(value) {
    var isMultiple = _.isArray(this.getValue());

    if (!value && isMultiple) {
      value = ['all'];
    }

    if (!value.length) return;

    if (value === 'all') {
      this.setValue('', true);
    }

    if (isMultiple && _.includes(value, 'all')) {
      this.setValue([], true);
      this.close();
      this.open();
    }

    var fetchingCurriculums = fetchCurriculums();

    fetchingCurriculums.done(updateCurriculums);

    var toBeUpdated = ['alignment'];
    var currentDropdown = this;

    $.each(toBeUpdated, function(i, dropdownClass) {
      if (dropdowns(dropdownClass)[0].selectize === currentDropdown) {
        return;
      }
      updateDropdown(fetchingCurriculums, dropdownClass);
    });
  }

  function initializeDropdowns() {
    var fetchingCurriculums = fetchCurriculums();
    fetchingCurriculums.done(updateCurriculums);
    var toBeUpdated = ['alignment', 'grade', 'curriculum'];
    $.each(toBeUpdated, function(i, dropdownClass) {
      updateDropdown(fetchingCurriculums, dropdownClass);
    });
  }

  function initializeCurriculum() {
    dropdowns().each(function(i, elm) {
      elm.selectize.on('change', onDropdownChange);
    });

    initializeDropdowns();

    $(document).on('mouseleave', '.popover', function () {
      $('.popover').popover('hide');
    });

    ko.applyBindings(curriculumViewModel, $('#curriculum-resources')[0]);
  }

  window.initializeCurriculum = function() {
    if ($('.curriculum-page').length > 0) {
      initializeCurriculum();
    }
  };

})(window);
