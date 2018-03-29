require 'json'
require_relative 'utils'

stats = JSON.parse(File.read('stats.json'), symbolize_names: true)

def analyze(stats, gender)
  puts "Analyzing #{gender}"
  stats = stats.values.map { |v| v[gender] if v[gender][:members_count] > 20 }.compact

  members_with_fails_count = stats.map { |v| v[:members_with_fails_count] }.sum
  members_count = stats.map { |v| v[:members_count] }.sum
  puts "  (members with fails) / members: #{members_with_fails_count} / #{members_count} = #{members_with_fails_count / members_count.to_f}"

  fails_count = stats.map { |v| v[:fails_count] }.sum
  tries_count = (stats.map { |v| v[:members_count] }.sum * 3)
  puts "  (failed tries) / tries: #{fails_count} / #{tries_count} = #{fails_count / tries_count.to_f}"
end

puts "Analyzed #{stats.keys.length} weightlifting events."
analyze(stats, :men)
analyze(stats, :women)
