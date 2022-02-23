#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Комментарии'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[dates name].freeze
    end

    def raw_combo_date
      super.gsub('по', '').tidy
    end

    def empty?
      raw_combo_date[/(\d{4})/, 1].to_i < 1991
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
