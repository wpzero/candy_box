require 'candy_box/version'
require 'candy_box/config_writer'
require 'candy_box/module_includer'
require 'candy_box/config'

module CandyBox
  def self.included(base)
    base.extend(ClassMethods)
    super
  end

  def candy_config
    self.class.candy_config
  end

  module ClassMethods
    def included(base)
      return if base == self
      base.include(CandyBox) unless base.respond_to?(:write_candy_config)
      base.write_candy_config(self) if respond_to?(:candy_config)
      super
    end

    def extended(base)
      base.include(CandyBox) unless base.respond_to?(:write_candy_config)
      base.write_candy_config(self)
      super
    end

    def inherited(base)
      base.write_candy_config(self)
      super
    end

    def add_candy(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      args.each do |mod|
        ModuleIncluder.new(mod, only: options.delete(:only), method: options.delete(:method)).call(self)
      end
      write_candy_config(options) unless options.empty?
      write_candy_config(&block) if block_given?
    end

    def write_candy_config(*args, &block)
      args.each do |config|
        ConfigWriter.new(config).call(self)
      end
      if block_given?
        ConfigWriter.new(block).call(self)
      end
    end

    def candy_config
      return @candy_config if instance_variable_defined?(:@candy_config)
      @candy_config = Config.new(self)
    end

    def add_candy_list(mod, options)
      candy_config.add_mod_list(mod, options)
    end
  end
end
