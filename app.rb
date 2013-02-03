before do
  @db = CouchRest.database("https://app11538999.heroku:PYxf8SG0lcRpTOW0YcdBw2Ts@app11538999.heroku.cloudant.com/fashion-deck-dev")
  @tumblr_key = "2ezRZGpa2EZo691nC8YXgLFXfOUze8GytqKW6jHhj2exe7aeBB"
  @tumblr_secret = "BXyaIdbH2alYndsv1Tf1ON4cM7oZo3dEpFEbFCfH7iXCXTE7hG"
end

get '/' do
  erb :index
end

post '/' do

  response = @db.save_doc(params) 

  if response['ok']
    redirect to('/page/' + response['id'])
  else
    erb :index, :locals => {:debug_response => response}
  end
end

get '/page/:key' do

  key = params[:key]

  doc = @db.get(key)

  @data = doc.to_hash

  if @data["tumblr_blog"]

    tumblr_request = "http://api.tumblr.com/v2/blog/" +
      @data["tumblr_blog"].to_s +
      "/posts" +
      "?api_key=" + @tumblr_key 

      tumblr_repsonse = RestClient.get tumblr_request, {:params => {}, :accept => :json}
      @tumblr_posts = JSON.parse tumblr_repsonse
  end
  
  erb :page
end
