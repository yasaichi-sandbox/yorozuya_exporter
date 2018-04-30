# frozen_string_literal: true

require "capybara"
require "selenium/webdriver"
require_relative "html_reader/payslip"

Capybara.register_driver :selenium_chrome_headless_ja do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(
      args: [
        "headless",
        "disable-gpu"
      ],
      prefs: {
        "intl.accept_languages": "ja"
      }
    )
  )
end

module YorozuyaExporter
  class HTTPClient
    ROOT_URL = "https://www.4628.jp"

    def initialize(company_id:, user_id:, password:)
      @company_id = company_id
      @user_id = user_id
      @password = password
      @session = ::Capybara::Session.new(:selenium_chrome_headless_ja)
    end

    def payslips
      ::Enumerator.new do |yielder|
        within_session do
          click_link "給与明細書", match: :first

          # payslips list
          first('select[name="StartDate_Year"] option').select_option
          select "01", from: "StartDate_Month"
          select "01", from: "StartDate_Day"
          click_button "検索"
          find('input[type="image"][alt="閲覧"]', match: :first).click

          # payslip detail
          loop do
            reader = ::YorozuyaExporter::HTMLReader::Payslip.new(html)
            yielder.yield(reader.call)

            break unless has_button?("次の支給日")
            click_button "次の支給日"
          end
        end
      end
    end

    private

    ::Capybara::Session::DSL_METHODS.each do |name|
      define_method(name) do |*args, &block|
        @session.public_send(name, *args, &block)
      end
    end

    def within_session
      visit ROOT_URL

      fill_in "y_companycd", with: @company_id
      fill_in "y_logincd", with: @user_id
      fill_in "password", with: @password
      click_button "ログイン"

      yield
    ensure
      reset_session!
    end
  end
end
