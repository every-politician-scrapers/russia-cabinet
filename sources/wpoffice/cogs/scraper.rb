#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Изображение'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[name img rank start end].freeze
    end

    # not alway the first link, as there's sometimes a model
    def name_link
      name_cell.css('a').last
    end

    def item
      name_link.attr('wikidata')
    end

    def itemLabel
      name_link.text
    end

    def empty?
      startDate < '1992-01-01'
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
