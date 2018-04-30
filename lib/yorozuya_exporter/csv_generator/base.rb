# frozen_string_literal: true

require "csv"

module YorozuyaExporter
  module CSVGenerator
    class Base
      def initialize
        @data = []
      end

      def add_data(*objects)
        @data.push(*objects)
      end

      def call
        raise ::NotImplementedError.new("You must implement #{self.class}##{__method__}")
      end
    end
  end
end
