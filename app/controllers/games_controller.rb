require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # to_a returns each 10 letters from the range A..Z from the array
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    # another way of doing it:
    # @letters = Array.new(5) { VOWELS.sample }
    # @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    # @letters.shuffle!
  end

  def score
    # 1. the letters given in the new view are stored in params - use split to create an array
    @letters = params[:letters].split
    # 2. the letters given by the user are stored in params (name="word" from input tag)
    # we transformed them into upcase letter (like @letters)
    @word_given = (params[:word] || '').upcase
    # 3. call method included? with both letters and word_given as arguments
    # this will check if the letters given by the user are in the array of the letters provided
    @included = included?(@word_given, @letters)
    # 4. check if the word_given is an english word by calling the method english_word?
    @english_word = english_word?(@word_given)
  end

  private

  def included?(word_given, letters)
    # chars returns an array of characters from a string
    # all? returns true if all the objects in the enumerable satisfies the given condition
    # count the letters in word_given and letters to see if the amount is the same
    word_given.chars.all? { |letter| word_given.count(letter) <= letters.count(letter) }
  end

  def english_word?(word_given)
    # parse the dictionary url with the word_given
    response = open("https://wagon-dictionary.herokuapp.com/#{word_given}")
    # open and read the file
    json = JSON.parse(response.read)
    # return the json found key which return true or false, if the word is english or not
    json['found']
  end
end
