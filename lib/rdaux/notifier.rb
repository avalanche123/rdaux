module RDaux
  module Notifier
    def notifier_initialize
      @__listeners__ = []
    end

    def add_listener(listener)
      @__listeners__ << listener
    end

    def broadcast(event, *args)
      @__listeners__.each do |listener|
        listener.__send__(event, *args) if listener.respond_to?(event)
      end
    end
  end
end
