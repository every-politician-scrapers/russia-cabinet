#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Photo'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no img name _ party dates].freeze
    end

    def raw_combo_date
      noko.css('i').remove
      super.gsub('from ', '')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
