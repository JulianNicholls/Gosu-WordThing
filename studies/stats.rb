# Collect the statistics on a set of words
class WordsStatistics
  def initialize(filename)
    @words = []
    File.foreach(filename) { |line| @words << line.chomp }
  end

  def raw_by_alpha
    @counts ||= count_letters

    @counts.keys.sort.each { |k| puts "#{k}: #{@counts[k]}" }
  end

  def raw_by_count(order = :ascending)
    @counts ||= count_letters

    counts = @counts.sort_by { |_, v| v }
    counts = counts.reverse if order == :descending

    counts.each { |k, v| puts "#{k}: #{v}" }
  end

  def vowel_counts
    @counts ||= count_letters

    vowels, _cons = @counts.keys.partition { |ltr| 'AEIOU'.include? ltr }

    type_counts(vowels.sort)
  end

  def consonant_counts
    @counts ||= count_letters

    _vows, consonants = @counts.keys.partition { |ltr| 'AEIOU'.include? ltr }

    type_counts(consonants.sort)
  end

  def initials
    counts = Hash.new(0)

    @words.each { |w| counts[w[0]] += 1 }

    type_counts(counts.keys.sort)
  end

  private

  def count_letters
    counts = Hash.new(0)

    @words.each do |word|
      word.each_char { |ltr| counts[ltr] += 1 }
    end

    counts
  end

  def type_counts(keys)
    total = keys.reduce(0) { |acc, elem| acc + @counts[elem] }

    puts "Total: #{total}"

    keys.each do |k|
      count = @counts[k]
      printf("%s: %5d - %6.2f%%\n",
             k, count, ((count * 100.0) / total).round(2))
    end
  end
end

filename = '../wtwords.txt'

puts 'Loading...'
stats = WordsStatistics.new(filename)

puts "\nRaw Letters Alphabetically..."
stats.raw_by_alpha

puts "\nRaw Letters by Count..."
stats.raw_by_count(:descending)

puts "\nVowel Count..."
stats.vowel_counts

puts "\nConsonant Count..."
stats.consonant_counts

puts "\nInitials"
stats.initials
