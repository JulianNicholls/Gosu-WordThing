#----------------------------------------------------------------------------
# Hold a list of words.
#
# It is held as a hash of arrays, indexed by the initial letter, so that
# searching for candidate words from a set of letters only has to search
# through the set of words that start with each unique letter.
class WordList
  # Initialise the array from a word list file, defaulting to wtwords.txt
  # using magic hash key array creation thing learnt from Ruby Koans

  def initialize( filename = 'wtwords.txt' )
    @words = Hash.new { |hash, key| hash[key] = [] }

    File.foreach( filename ) do |line|
      @words[line[0]] << line.chomp
    end
  end

  def include?( word )
    @words[word[0]].include? word
  end
  
  # Show the number of words in each letter section of the hash.

  def debug
    @words.each_key { |ltr| printf "%c: %5d\n", ltr.upcase, @words[ltr].length }
  end
end
