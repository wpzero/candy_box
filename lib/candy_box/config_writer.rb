module CandyBox
  class ConfigWriter
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def call(base)
      candy_config = base.candy_config
      case config
      when Hash
        candy_config.merge!(config)
      when Module
        candy_config.add_scope(config)
      when Proc
        candy_config.eval_config &config
      else
        raise 'Not support type config For ConfigWriter'
      end
    end
  end
end
