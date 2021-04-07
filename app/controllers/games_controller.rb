require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    # @letters = Array.new(5) { VOWELS.sample }
    # @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    # @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word_given = (params[:word] || '').upcase
    @included = included?(@word_given, @letters)
    @english_word = english_word?(@word_given)
    # @message =
    #   if !@include
    #     "Sorry but #{@word_given} can't be built out of #{@letters}"
    #   elsif @include && !english_word
    #     "Sorry but #{@word_given} does not seem to be a valid English word..."
    #   elsif valid && english_word
    #     "Congratulations! #{@word_given} is a valid English word!"
    #   end
  end

  private

  def inluded?(word_given, letters)
    word_given.chars.all? { |letter| word_given.count(letter) <= letters.count(letter) }
  end

  def english_word?(word_given)
    response = open("https://wagon-dictionary.herokuapp.com/#{word_given}")
    json = JSON.parse(response.read)
    json['found']
  end
end
