require "wrapping_paper/version"

class WrappingPaper
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


  def self.wraps_a(sym)
    # WrappingPaper.wraps_a would pollute all WrappingPaper subclasses, so no dice.
    if self == WrappingPaper
      raise "That's a really bad idea; it would affect *every* WrappingPaper subclass."
    end
    
    self.send(:alias_method, sym, :wrapped)
  end
end
