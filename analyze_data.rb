require 'json'
require_relative 'utils'

stats = JSON.parse(File.read('stats.json'), symbolize_names: true)

def analyze(stats, gender)
  willpowers = stats.values.map { |v| v[gender][:willpower] if v[gender][:members_count] > 20 }.compact
  puts "#{gender.to_s.capitalize} average willpower: #{willpowers.sum / willpowers.length}"
  puts "#{gender.to_s.capitalize} median willpower: #{median(willpowers)}"
end

analyze(stats, :men)
analyze(stats, :women)
