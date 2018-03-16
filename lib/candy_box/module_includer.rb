require 'byebug'
module CandyBox
  class ModuleIncluder
    attr_reader :method, :only, :unwanted_methods, :mod, :dup_mod

    def initialize(mod, options = {})
      @mod = mod
      @method = options[:method] || :include
      @only = options[:only] || []
      @unwanted_methods = if @only.empty?
                            []
                          else
                            @mod.instance_methods(false) - Array(@only)
                          end
      @dup_mod = new_dup_mod
    end

    def call(base)
      base.send(method, dup_mod)
      base.add_candy_list(mod, { only: only, method: method })
    end

    def new_dup_mod
      if unwanted_methods.empty?
        @mod
      else
        new_mod = @mod.dup
        unwanted_methods.each do |method_name|
          new_mod.send :remove_method, method_name
        end
        new_mod
      end
    end
  end
end
