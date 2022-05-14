#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderNonTable < OfficeholderListBase::OfficeholderBase
  def empty?
    too_early?
  end

  def combo_date?
    true
  end

  def raw_combo_date
    raise 'need to define a raw_combo_date'
  end

  def name_node
    raise 'need to define a name_node'
  end

  def too_early?
    start_year < ignore_before
  end
end


class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  # decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  # TODO: make this easier to override
  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'Министры')]]//following-sibling::ul[1]//li")
  end

  class Officeholder < OfficeholderNonTable
    def raw_combo_date
      noko.text.gsub('года', '').scan(/\(.*?(\d.*?)\)/).flatten.last.tidy
    end

    def name_node
      noko.css('a').first
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
