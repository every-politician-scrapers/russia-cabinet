#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class DottedDMY < WikipediaDate
  def to_s
    date_en.to_s.split('.').reverse.join('-')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'ФИО'
  end

  def table_number
    "position()<5"
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name dob start].freeze
    end


    def startDate
      return '2011-12-21' if tds.count == 4 || super.to_s.empty?

      super
    end

    def endDate
      '2016-10-05'
    end

    def date_class
      DottedDMY
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
