class EventsFormatter
  THRESHOLD = 0.65

  attr_accessor :events

  def initialize(events)
    @events = events
  end

  def relevant_to(query)
    if query.present?
      @events = @events
        .map { |e| { event: e, relevance: e.relevance_to(query) } }
        .select { |p| p[:relevance] >= THRESHOLD }
        .sort_by { |p| -p[:relevance] }
        .map { |p| puts ">>#{p}"; p[:event] }
    end

    self
  end

  def grouped_by(field)
    if field.present? && Event.method_defined?(field.to_sym)
      @events = @events
        .group_by { |e| e.send field.to_sym }
        .map { |k, vs| vs.first.group = k; vs }
        .flatten
    end

    self
  end
end
