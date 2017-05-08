module DocTemplate
  class DocumentTOC
    REGISTERED_SUBJECTS = {
      'ela'  => :agenda,
      'math' => :activity
    }.freeze

    def self.parse(opts = {})
      subject = opts[:metadata].subject.try(:downcase)
      return TOCMetadata.new unless REGISTERED_SUBJECTS.key?(subject)
      TOCMetadata.new(opts[REGISTERED_SUBJECTS[subject]])
    end
  end
end
