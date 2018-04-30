# frozen_string_literal: true

require "set"
require "yorozuya_exporter/csv_generator/base"

module YorozuyaExporter
  module CSVGenerator
    class Payslips < Base
      def call
        item_names = [
          *payment_item_names,
          *deduction_item_names,
          *net_payment_item_names
        ]

        ::CSV.generate do |csv|
          csv << ["明細書分類", *item_names]

          @data.each do |payslip|
            csv << [
              payslip.name,
              *item_names.reduce([]) { |a, n| a << payslip.amount_of(n) }
            ]
          end
        end
      end

      private

      def deduction_item_names
        @data.reduce(::Set.new) { |set, payslip| set.merge(payslip.deduction.names) }
      end

      def net_payment_item_names
        @data.reduce(::Set.new) { |set, payslip| set.merge(payslip.net_payment.names) }
      end

      def payment_item_names
        @data.reduce(::Set.new) { |set, payslip| set.merge(payslip.payment.names) }
      end
    end
  end
end
