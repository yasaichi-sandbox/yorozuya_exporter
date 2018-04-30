# frozen_string_literal: true

require "nokogiri"

module YorozuyaExporter
  module HTMLReader
    class Base
      def initialize(html)
        @doc = ::Nokogiri::HTML(html)
      end

      def call
        raise ::NotImplementedError.new("You must implement #{self.class}##{__method__}")
      end
    end
  end
end
