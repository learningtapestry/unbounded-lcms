# frozen_string_literal: true

module PagesHelper
  def standardsinstitutes_link
    @standardsinstitutes_link ||= link_to('Register Now',
      'http://www.standardsinstitutes.org/institute/winter-2017-standards-institute',
      class: 'o-btn o-btn--register o-btn--xs-full u-margin-bottom--zero', target: '_blank')
  end
end
