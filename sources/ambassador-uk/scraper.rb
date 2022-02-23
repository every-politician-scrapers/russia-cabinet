#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class String
  def zeropad
    rjust(2, '0')
  end
end

class DottedDMY < WikipediaDate
  def to_s
    date_en.to_s.split('.').reverse.map(&:zeropad).join('-')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'пребывания'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[dates name].freeze
    end

    def raw_combo_date
      super.gsub('с ', '')
    end

    def empty?
      raw_combo_date[/(\d{4})/, 1].to_i < 1991
    end

    def date_class
      DottedDMY
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
