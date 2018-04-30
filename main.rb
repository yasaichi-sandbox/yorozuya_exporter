# frozen_string_literal: true

require "bundler/setup"
require "csv"
require_relative "lib/yorozuya_exporter"

headers = nil
csv_table = nil
client = YorozuyaExporter::HTTPClient.new(
  company_id: ENV["YOROZUYA_COMPANY_ID"],
  user_id: ENV["YOROZUYA_USER_ID"],
  password: ENV["YOROZUYA_USER_PASSWORD"]
)

client.payslips.each_with_index do |payslip, i|

  if i.zero?
    headers = [
      *payslip.payment.names,
      *payslip.deduction.names,
      *payslip.net_payment.names
    ]

    values = [
      payslip.name,
      *headers.reduce([]) { |a, h| a << payslip.amount_of(h) }
    ]

    csv_table = CSV.new(
      "#{['明細書分類', *headers].join(',')}\n#{values.join(',')}",
      headers: true
    ).read
  else
    csv_table << [
      payslip.name,
      *headers.reduce([]) { |a, h| a << payslip.amount_of(h) }
    ]
  end
end

File.write("result.csv", csv_table.to_csv)
