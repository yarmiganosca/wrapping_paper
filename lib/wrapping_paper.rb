require "wrapping_paper/version"

module WrappingPaper
  attr_reader :wrapped

  def initialize(gift, extras = {})
    @wrapped = gift

    self.class.wraps_a(gift.class.name.downcase.split('::').last.to_sym)

    extras.each_pair do |key, value|
      self.class.send(:attr_reader, key) unless self.respond_to?(key)
      self.instance_variable_set("@#{key}", value)
    end
  end

  def method_missing(sym, *args, &blk)
    if wrapped.respond_to? sym
      wrapped.send(sym, *args, &blk)
    else
      super
    end
  end

  module Helper
    def wraps_a(sym)
      self.send(:alias_method, sym, :wrapped)
    end
  end

  def self.included(other)
    other.send(:extend, Helper)
  end
end
