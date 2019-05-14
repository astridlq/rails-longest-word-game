require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(guess, grid)
    # byebug
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def score
    @word = params[:word]
    @letters = params[:grid]

    if params[:word]

      if english_word?(@word)
        if included?(@word, @letters)
          return @answer = "CONGRATULATIONS!"
        else
          return @answer = "Sorry but #{@word} cannot be built out of #{@letters}"
        end
      else
        return @answer = "Sorry but #{@word} doesn't seem to be valid English word"
      end
    end
  end
end
