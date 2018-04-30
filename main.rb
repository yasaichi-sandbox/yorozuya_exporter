# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:default)

YOROZUYA_COMPANY_ID = ENV["YOROZUYA_COMPANY_ID"]
YOROZUYA_USER_ID = ENV["YOROZUYA_USER_ID"]
YOROZUYA_USER_PASSWORD = ENV["YOROZUYA_USER_PASSWORD"]
YOROZUYA_ROOT_URL = "https://www.4628.jp"

Capybara.register_driver :selenium_chrome_ja do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(
      prefs: {
        "intl.accept_languages": "ja"
      }
    )
  )
end

Capybara::Session.new(:selenium_chrome_ja).instance_exec do
  visit YOROZUYA_ROOT_URL

  # ログイン画面
  fill_in "y_companycd", with: YOROZUYA_COMPANY_ID
  fill_in "y_logincd", with: YOROZUYA_USER_ID
  fill_in "password", with: YOROZUYA_USER_PASSWORD
  click_button "ログイン"

  # トップページ
  click_link "給与明細書", match: :first

  # 給与明細書一覧
  first('select[name="StartDate_Year"] option').select_option
  select "01", from: "StartDate_Month"
  select "01", from: "StartDate_Day"
  click_button "検索"
  find('input[type="image"][alt="閲覧"]', match: :first).click

  # 給与明細書
  loop do
    basename = all("td.bgcolor_white")[2].text
    File.write(File.expand_path("payslips/#{basename}.html", __dir__), html)

    break unless has_button?("次の支給日")
    click_button "次の支給日"
  end
end
