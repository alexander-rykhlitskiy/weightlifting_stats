require 'date'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'fileutils'
require 'pry'

YEARS = (1998..Date.today.year).freeze
EVENTS_URL = 'http://www.iwf.net/results/results-by-events/?event_year=%<year>s'.freeze

def events_urls
  events_urls_file = 'events_urls.json'
  return JSON.parse(File.read(events_urls_file)) if File.file?(events_urls_file)

  result = {}
  YEARS.each do |year|
    url = EVENTS_URL % { year: year }
    doc = Nokogiri::HTML(open(url))
    result[year] =
      doc.css('#events_table td:nth-child(2) a').map do |a|
        a[:href].match?(/\Awww|\Ahttp/) ? a[:href] : URI.join('http://www.iwf.net/', a[:href]).to_s
      end.uniq
  end

  File.write(events_urls_file, result.to_json)
  result
end

def event_doc(event_url)
  htmls_directory = 'events_htmls'
  FileUtils.mkdir_p(htmls_directory)
  html_file_path = "#{htmls_directory}/#{event_url[/\d+/]}.html"

  if File.file?(html_file_path)
    html = File.read(html_file_path)
    puts "read #{event_url}"
  else
    html = open(event_url)
    File.write(html_file_path, html.read)
    puts "write #{event_url}"
  end

  Nokogiri::HTML(html)
end

stats = {}
sections_with_fails = { men: '#men_snatchjerk', women: '#women_snatchjerk' }
events_urls.values.flatten.uniq.each do |event_url|
  doc = event_doc(event_url)
  stats[event_url] = {}

  sections_with_fails.each do |(gender, section_with_fails)|
    section = doc.css(section_with_fails)
    tables = section.css('h2:contains("Clean&Jerk") + table, h2:contains("Snatch") + table')

    stat = stats[event_url][gender] = {}
    stat[:members_count] = tables.css('tbody tr').length
    stat[:fails_count] =   tables.css('td strike').length
    stat[:members_with_fails_count] = tables.css('tr:has(td strike)').length
  end
end

p stats
File.write('stats.json', JSON.pretty_generate(stats))
