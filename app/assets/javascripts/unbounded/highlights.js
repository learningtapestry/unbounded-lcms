Unbounded.highlights = {
  _highlights: [],
  fetchHighlights: function(options, callback) {
    var that = this;

    $('.lesson-active').find('use').attr('xlink:href', '');
    $('.lesson-active').removeClass('lesson-active');

    $.ajax({
      dataType: 'json',
      url: Routes.unbounded_curriculum_highlights_path(),
      data: {
        subject: options.subject,
        grade: options.grade,
        standards: options.standards
      },
      success: function(data) {
        that._highlights = data;
        callback(data);
      }
    });
  },
  findHighlights: function(lobjectId) {
    return _.filter(this._highlights, function(alignment) {
      return _.some(alignment.highlights, function(highlightedId) {
        return highlightedId == lobjectId;
      });
    });
  },
  getHighlights: function() {
    return this._highlights;
  }
};
