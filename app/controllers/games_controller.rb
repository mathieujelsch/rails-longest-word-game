require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters]

    if included_in_letters?(@word, @letters)
      if english_word?(@word)
        @results = "Congratulations! #{@word} is a valid word"
      else
        @results = "Sorry but #{@word} does not seem to be a valid English word.."
      end
    else
      @results = "Sorry but #{@word} can't be build ouf of #{@letters}"
    end
  end

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    JSON.parse(response)["found"]
  end

  def included_in_letters?(word, letters)
    # Iterate on the letters of the submitted word and check if they are present in the letters array
    word.chars.each do |letter|
      if letters.include?(letter)
        letters.delete_at(letters.index(letter))
      else
        return false
      end
    end
    return true
  end

end
