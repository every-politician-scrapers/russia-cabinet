#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Фотография'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name photo dates].freeze
    end

    def raw_combo_date
      super.gsub(/\(.*?\)/, '').gsub(/^с (.*)/, '\1 - Incumbent').tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
