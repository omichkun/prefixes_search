class MainController < ApplicationController
  def main
  end

  def search
    search_string = params[:search_string]
    queries = QueryBuilder::Builder.build(search_string)
    result_query = Prefix.select('id, comment, value').where(queries.first[:query], queries.first[:value])
    if queries.length > 1
      1.upto(queries.length - 1) do |index|
        result_query = result_query.send('or', Prefix.select('id, comment, value').where(queries[index][:query], queries[index][:value]))
      end
    end
    result_query = result_query.order(value: :desc).uniq
    render plain: result_query.to_json
  end


end
