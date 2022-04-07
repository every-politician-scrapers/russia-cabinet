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

  def table_number
    1
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[dates name].freeze
    end

    def empty?
      super || (startDate[0...4].to_i < 1990)
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
