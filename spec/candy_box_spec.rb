require 'spec_helper'

describe CandyBox do
  let(:mod) do
    module HiMixin
      include CandyBox

      write_candy_config do
        version 0.1
        word 'hello world'
      end

      def say_hi
        "say: #{candy_config.word}"
      end

      def version
        candy_config.version
      end
    end
    HiMixin
  end

  it 'has a version number' do
    expect(CandyBox::VERSION).not_to be nil
  end

  context 'include HiMixin' do
    let(:klass) {
      klass = Class.new
      klass.include(mod)
      klass
    }

    it 'class has these candy box config' do
      expect(klass.candy_config.word).to eq('hello world')
      expect(klass.candy_config.version).to eq(0.1)
    end

    it 'instance of this class can get candy box config' do
      a = klass.new
      expect(a.say_hi).to eq('say: hello world')
      expect(a.version).to eq(0.1)
    end
  end

  context 'extend HiMixin' do
    let(:klass) {
      klass = Class.new
      klass.include(mod)
      klass
    }

    it 'class has these candy box config' do
      expect(klass.candy_config.word).to eq('hello world')
      expect(klass.candy_config.version).to eq(0.1)
    end
  end

  context 'add_candy' do
    let(:klass) {
      klass = Class.new
      klass.include(CandyBox)
      klass
    }

    context 'add_candy and rewrite candy configuration' do
      it 'should work successfully' do
        klass.add_candy(mod, { version: 0.2 })
        expect(klass.candy_config.version).to eq(0.2)
        a = klass.new
        expect(a.version).to eq(0.2)
        expect(a.say_hi).to eq('say: hello world')
      end
    end

    context 'add_candy and only include say_hi method' do
      it 'should work successfully' do
        klass.add_candy(mod, { only: [:say_hi], version: 0.3 })
        expect(klass.candy_config.version).to eq(0.3)
        a = klass.new
        expect(a.say_hi).to eq('say: hello world')
        expect(a.candy_config.version).to eq(0.3)
        expect(a.respond_to?(:version)).to eq(false)
      end
    end
  end
end
