require 'json'
require_relative 'utils'

stats = JSON.parse(File.read('stats.json'), symbolize_names: true)

def analyze(stats, gender)
  stats = stats.values.map { |v| v[gender] if v[gender][:members_count] > 20 }.compact

  puts "#{gender.to_s.capitalize} (members with fails) / members: #{stats.map { |v| v[:members_with_fails_count] }.sum / stats.map { |v| v[:members_count] }.sum.to_f}"

  fails_count = stats.map { |v| v[:fails_count] }.sum
  tries_count = (stats.map { |v| v[:members_count] }.sum * 3).to_f
  puts "#{gender.to_s.capitalize} (failed tries) / tries: #{fails_count / tries_count}"
end

analyze(stats, :men)
analyze(stats, :women)
