require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  # This is an action / the 'method' that is only accessed when there is an HTTP request for it
  def score
    @word_given = params[:word].capitalize
    @letters = params[:letters]
    # Scenarious:

    # The word can't be built out of the original grid
    # message to return "Sorry but #{@word_given} can't be built out of #{@letter}" ! iterrate and print array?

    # The word is valid according to the grid, but is not a valid English word
    # message to return "Sorry but #{@word_given} does not seem to be a valid English word..."

    # The word is valid according to the grid and is an English word
    # message to return "Congratulations! #{@word_given} is a valid English word!"
    @message =
      if !@include
        "Sorry but #{@word_given} can't be built out of #{@letters}"
      elsif @include && !english_word
        "Sorry but #{@word_given} does not seem to be a valid English word..."
      elsif valid && english_word
        "Congratulations! #{@word_given} is a valid English word!"
      end
  end

  private

  def inlude
    @word_given.all? { |letter| @word_given.length <= @letters.length }
  end

  def english_word?
    response = open("https://wagon-dictionary.herokuapp.com/#{@word_given}")
    json = JSON.parse(response.read)
    @english = json['found']
  end
end
