class LobjectTree
  attr_reader :reference_lobject, :collections

  def initialize(lobject)
    @reference_lobject = lobject
    @collections = find_collections
  end



  class LobjectCollectionNode
    attr_reader  :node, :is_current

    def initialize(node, is_current)
      @node = node
      @is_current = is_current
    end
  end
end
