module Unbounded::BrowseHelper
  def add_to_search(more_params)
    corrected_params = {}
    more_params.each do |k,v|
      corrected_params[path_to_param(k)] = v
    end
    current_search.merge(corrected_params)
  end

  def current_search
    valid_params = [
      'active', 'resource_type', 'grade',
      'topic', 'subject', 'alignment', 'query'
    ]

    params.slice(*valid_params)
  end

  def search_up_to(up_to_k)
    new_search = {}
    current_search.except(:query).each do |k,v|
      new_search[k] = v
      break if k == up_to_k
    end
    if params[:query]
      new_search[:query] = params[:query]
    end
    new_search
  end

  def path_to_param(path)
    {
      'sources.engageny' => 'active',
      'resource_types' => 'resource_type',
      'grades' => 'grade',
      'topics' => 'topic',
      'subjects' => 'subject',
      'alignments' => 'alignment'
    }[path]
  end
end
