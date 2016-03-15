require 'will_paginate/array'

class Instruction
  include ActiveModel::Serialization

  attr_accessor :id, :title, :short_title, :img, :path

  def initialize(attributes = {})
    assign_attributes(attributes)
  end

  def assign_attributes(values)
    values.each do |k, v|
      send("#{k}=", v)
    end
  end
end

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

  def dummy_instructions
    instructions = []
    50.times do |i|
      instructions << Instruction.new(id: i,
                                      path: '#',
                                      short_title: "ST #{i} Content Guide",
                                      title: "Full Title for #{i} Content Guide")
    end
    instructions
  end

  def set_index_props
    @instructions = dummy_instructions.paginate(pagination_params.slice(:page, :per_page))
    @props = serialize_with_pagination(@instructions,
      pagination: pagination_params,
      each_serializer: InstructionSerializer
    )
    @props.merge!(filterbar_props)
  end

end
