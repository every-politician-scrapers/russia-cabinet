#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Текущий список'
  end

  # TODO: make this easier to override
  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'Выбывшие депутаты')]]/following::*").remove
    noko.xpath("//h2[.//span[contains(.,'#{header_column}')]][last()]//following::ol//li[a]")
  end

  class Officeholder < OfficeholderBase
    def name_cell
      noko.css('a')
    end

    def name_link_text
      name_cell.text.tidy
    end

    def startDate
      '2021-10-12'
    end

    def endDate
      nil
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
