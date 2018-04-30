# frozen_string_literal: true

require "thor"
require_relative "../yorozuya_exporter"

module YorozuyaExporter
  class CLI < ::Thor
    package_name "YorozuyaExporter"

    desc "payslips", "Export all payslips to CSV"
    def payslips
      csv_generator = ::YorozuyaExporter::CSVGenerator::Payslips.new

      http_client.payslips.each do |payslip|
        csv_generator.add_data(payslip)
      end

      out.puts(csv_generator.call)
    end

    private

    def http_client
      ::YorozuyaExporter::HTTPClient.new(
        company_id: ENV["YOROZUYA_COMPANY_ID"],
        user_id: ENV["YOROZUYA_USER_ID"],
        password: ENV["YOROZUYA_USER_PASSWORD"]
      )
    end

    # TODO: Enable to specify filepath
    def out
      $stdout
    end
  end
end
