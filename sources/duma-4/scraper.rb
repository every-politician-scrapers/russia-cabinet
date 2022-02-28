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

  class Officeholder < OfficeholderBase
    def columns
      %w[name start].freeze
    end

    def endDate
      '2007-12-24'
    end

    def date_class
      DottedDMY
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
