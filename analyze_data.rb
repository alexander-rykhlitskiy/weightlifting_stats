require 'json'

stats = JSON.parse(File.read('stats.json'), symbolize_names: true)

def analyze(stats, gender)
  willpower = stats.values.map { |v| v[gender][:willpower] }.compact
  puts "#{gender.to_s.capitalize} average willpower: #{willpower.sum / willpower.length}"
end

analyze(stats, :men)
analyze(stats, :women)
