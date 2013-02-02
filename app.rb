before do
  @db = CouchRest.database("https://app11538999.heroku:PYxf8SG0lcRpTOW0YcdBw2Ts@app11538999.heroku.cloudant.com/fashion-deck-dev")
end

get '/' do
  erb :index
end

post '/' do
  response = @db.save_doc({
    :title => params[:title]
  })
  redirect to('/page/' + response['id'])
end

get '/page/:key' do
  key = params[:key]
  doc = @db.get(key)
  @data = doc.to_json
end
