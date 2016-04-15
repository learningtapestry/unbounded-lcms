require 'will_paginate/array'


class EnhanceInstructionController < ApplicationController
  include Filterbar
  include Pagination

  before_action :set_index_props, only: [:index]

  def index
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end

  private

  def find_instructions
    ContentGuide.where_subject(subject_params)
                .where_grade(grade_params)
                .paginate(pagination_params.slice(:page, :per_page))
  end

  def find_videos
    queryset = Resource.where(nil)

    unless search_term.blank?
      search_ids = Resource.search(search_term, limit: 100).results.map {|r| r.id.to_i }
      queryset = queryset.where(id: search_ids).order_as_specified(id: search_ids)
    end

    queryset.where(resource_type: accepted_resource_types)
            .where_subject(subject_params)
            .where_grade(grade_params)
            .paginate(pagination_params.slice(:page, :per_page))
  end

  def accepted_resource_types
    [
      Resource.resource_types[:video],
      Resource.resource_types[:podcast]
    ]
  end

  def set_index_props
    @instructions = find_instructions
    @props = serialize_with_pagination(@instructions,
      pagination: pagination_params,
      each_serializer: InstructionSerializer
    )
    videos = serialize_with_pagination(find_videos,
      pagination: pagination_params,
      each_serializer: VideoInstructionSerializer
    )[:results]
    @props.merge!(filterbar_props)
    @props.merge!(videos: videos)
  end

end
