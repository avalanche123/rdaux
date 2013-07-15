module RDaux
  class LoggingListener
    def initialize(logger)
      @logger = logger
    end

    def creating_application(path)
      @logger.debug("Creating application for: #{path}")
    end

    def adding_file(path)
      @logger.debug("Adding file: #{path}")
    end

    def adding_directory(path)
      @logger.debug("Adding directory: #{path}")
    end
  end
end
