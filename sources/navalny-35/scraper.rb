#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'imposition'
  end

  def table_number
    'position()>=1'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[_ name].freeze
    end

    def raw_start
      tds.last.text.match(/(\w+ \d+, \d{4})/)&.captures&.first
    end

    def endDate
      nil
    end
  end
end

url = "https://en.wikipedia.org/wiki/Navalny_35"
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
