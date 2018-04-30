# YorozuyaExporter

YorozuyaExporter enables you to export data of [万屋一家](https://www.4628.jp/) to CSV.

## Requirements

YorozuyaExporter requires [Google Chrome](https://www.google.co.jp/chrome/) and
[Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/).
If you use macOS, you can install them with [Homebrew](http://brew.sh/index.html):

```sh
$ brew cask install google-chrome
$ brew cask install chromedriver
```

## Installation

Put this in your Gemfile:

```ruby
gem "yorozuya_exporter", github: "yasaichi-sandbox/yorozuya_exporter"
```

And then execute:

```
$ bundle install
```

## Usage

You can get all payslips as:

```
$ YOROZUYA_COMPANY_ID='keyakizaka' \
  YOROZUYA_USER_ID='46' \
  YOROZUYA_USER_PASSWORD='silent_majority'  \
  bundle exec yorozuya_exporter payslips > ./payslips.csv
```

## Contributing

You should follow the steps below:

1.  [Fork the repository](https://help.github.com/articles/fork-a-repo/)
2.  Create a feature branch: `git checkout -b add-new-feature`
3.  Commit your changes: `git commit -am 'add new feature'`
4.  Push the branch: `git push origin add-new-feature`
5.  [Send us a pull request](https://help.github.com/articles/about-pull-requests/)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
