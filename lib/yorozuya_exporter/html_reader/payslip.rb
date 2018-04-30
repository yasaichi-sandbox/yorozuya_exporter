# frozen_string_literal: true

require "yorozuya_exporter/html_reader/base"
require "yorozuya_exporter/payslip"

module YorozuyaExporter
  module HTMLReader
    class Payslip < Base
      SPACE = /\p{Space}/

      def call
        tables = @doc.css(".txt_12")

        ::YorozuyaExporter::Payslip.new(
          name: @doc.css("td.bgcolor_white")[2].text.strip,
          payment: extract_all_items(tables[3]),
          deduction: extract_all_items(tables[4]),
          net_payment: extract_all_items(tables[5])
        )
      end

      private

      def extract_all_items(table)
        headers = table.css(".bgcolor_table_head")
        bodies = table.css(".bgcolor_white")

        headers.zip(bodies).reduce({}) do |hash, (header, body)|
          keys = header.css("td").map { |td| td.text.strip }
          values = body.css("td").map(&:text)

          hash.merge!(normalize(keys.zip(values).to_h))
        end
      end

      def normalize(hash)
        hash.reduce({}) do |new_hash, (key, value)|
          new_key = key.gsub(SPACE, "")
          new_value = value.tr(",", "").gsub(SPACE, "").to_i

          new_key == "" ? new_hash : new_hash.merge!(new_key => new_value)
        end
      end
    end
  end
end
