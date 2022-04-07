#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderNonTable < OfficeholderListBase::OfficeholderBase
  def empty?
    false
  end

  def combo_date?
    true
  end

  def combo_date
    raise 'need to define a combo_date'
  end

  def name_node
    raise 'need to define a name_node'
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'Выбывшие депутаты')]]/following::*").remove
    noko.xpath("//h2[.//span[contains(.,'Текущий список')]][last()]//following::ol//li[a]")
  end

  class Officeholder < OfficeholderNonTable
    def name_node
      noko.css('a')
    end

    def combo_date
      ['', '']
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
