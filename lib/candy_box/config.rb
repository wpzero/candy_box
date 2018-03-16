require 'ostruct'

module CandyBox
  class Config
    attr_reader :base_config, :base

    def initialize(base)
      @base = base
      @base_config = OpenStruct.new(mod_list: [],
                                    scope_list: [])
    end

    def merge!(config)
      config.each do |key, val|
        @base_config.send(:"#{key}=", val)
      end
    end

    def eval_config(&block)
      EvalSpace.new(base_config).call(block)
    end

    def add_scope(scope)
      scope_list << scope
      scope.candy_config.to_h.each do |key, val|
        base_config.send(:"#{key}=", val) unless base_config.respond_to?(key)
      end
    end

    def add_mod_list(mod, options)
      mod_list << { mod: mod, options: options }
    end

    def scope_list
      @base_config.scope_list
    end

    def mod_list
      @base_config.mod_list
    end

    def method_missing(name, *args, &block)
      if base_config.respond_to?(name) && args.length == 0
        base_config.send(name)
      else
        super
      end
    end

    class EvalSpace
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def call(block)
        instance_eval &block
      end

      def method_missing(name, *args, &block)
        if args.length == 1
          config.send(:"#{name}=", args.first)
        elsif args.length == 0
          config.send(name)
        else
          super
        end
      end
    end
  end
end
