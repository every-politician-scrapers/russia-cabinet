#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Portrait'
  end

  # collapse consecutive mandates
  def members
    super.group_by { |row| row.values_at(:item, :itemLabel) }.map do |person, mandates|
      mandates.flat_map { |mem| [mem[:startDate], mem[:endDate]] }.group_by(&:itself).select { |date, seen| seen.count == 1 }.keys.each_slice(2).map do |sd, ed|
        { item: person.first, itemLabel: person.last, startDate: sd, endDate: ed }
      end
    end.flatten
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no img name dates].freeze
    end

    def empty?
      super || (startDate < '2008-01-01')
    end

    def raw_combo_date
      super.gsub('since ', '').gsub('Acting governor', '').tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
