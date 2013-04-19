require_relative 'spec_helper'
require 'wrapping_paper'

describe "a class that includes WrappingPaper" do
  class Presenter
    include WrappingPaper
  end

  describe "#wrapped" do
    it "returns the wrapped object" do
      Presenter.new(:shiny_present).wrapped.should == :shiny_present
    end
  end

  describe ".wraps_a" do
    before { Presenter.wraps_a :shiny_present }
    after { Presenter.send(:remove_method, :shiny_present) }

    it "defines an alias for #wrapped" do
      presenter = Presenter.new :toy

      presenter.shiny_present.should == presenter.wrapped
    end

    it "doesn't exist on WrappingPaper" do
      ->() { WrappingPaper.wraps_a }.should raise_error(NoMethodError)
    end
  end

  describe "#initialize" do
    it "defines an alias for #wrapped based on gift's class name" do
      module Gifts; Present = Struct.new(:toy); end

      presenter = Presenter.new(Gifts::Present.new(:robot))

      presenter.present.should == presenter.wrapped
    end

    class PresenterWithReceipt
      include WrappingPaper
    end

    context "with a nonempty extras hash" do
      let(:extras) { {receipt: Struct.new(:store).new(:that_place)} }
      let(:presenter) { PresenterWithReceipt.new(:shiny_present, extras) }

      it "defines on the wrapper class, for each (key, value) pair, a getter method (named key) for value" do
        presenter.receipt.store.should == :that_place
      end
    end

    context "after the first instance is initialized" do
      let(:extras) { {receipt: Struct.new(:store).new(:the_other_place)} }

      it "doesn't need to define getter methods if they already exist" do
        PresenterWithReceipt.new(:shiny_present).should respond_to(:receipt)
      end

      it "ensures the getter methods return values from the correct extras hash" do
        PresenterWithReceipt.new(:shiny_present).receipt.should be_nil
        PresenterWithReceipt.new(:shiny_present, extras).receipt.store.should == :the_other_place
      end
    end
  end

  describe "#method_missing" do
    class Toy
      def really_shiny?
        true
      end

      def all_the_args?(first, *rest, &others)
        first && !rest.empty? && block_given?
      end
    end

    let(:toy) { Toy.new }
    let(:gift) { Presenter.new(toy) }

    context "if @wrapped responds to the method" do
      it "delegates the call to @wrapped" do
        toy.should_receive(:really_shiny?)

        gift.really_shiny?
      end

      it "passes all the arguments" do
        gift.all_the_args?(:this, :and) { :that }.should be_true
      end
    end

    context "if neither @wrapped nor the wrapper responds to the method" do
      it "allow an ancestor to raise a NoMethorError" do
        ->() { gift.not_a_method_name }.should raise_error(NoMethodError)
      end
    end
  end
end
