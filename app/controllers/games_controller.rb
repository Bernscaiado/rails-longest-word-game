require 'date'
require 'open-uri'

class GamesController < ApplicationController
  def new
    charset = Array('A'..'Z')
    @letters = Array.new(10) { charset.sample }
  end

  def score
    start_time = DateTime.now
    end_time = DateTime.now
    attempt = params[:word]
    grid = params[:letters]
    url = 'https://wagon-dictionary.herokuapp.com/' + attempt.to_s
    words_serialized = open(url).read
    words = JSON.parse(words_serialized)
    attempt_array = attempt.split(//)
    total_time = end_time - start_time
    if words['found'] && attempt_array.all? { |char| grid.count(char.upcase) >= attempt_array.count(char) }
      total_score = (attempt.length * 100) - total_time
      @result = { time: total_time, score: total_score, message: 'Well done!' }
    elsif !attempt_array.all? { |char| grid.count(char.upcase) >= attempt_array.count(char) }
      @result = { time: total_time, score: 0, message: 'Not in the grid' }
    elsif !words['found']
      @result = { time: total_time, score: 0, message: 'Not an english word' }
    else
      @result = { time: total_time, score: 0, message: 'Not in the grid' }
    end
    @result
  end
end
