before do
  @db = CouchRest.database("https://app11538999.heroku:PYxf8SG0lcRpTOW0YcdBw2Ts@app11538999.heroku.cloudant.com/fashion-deck-dev")
  @tumblr_key = "2ezRZGpa2EZo691nC8YXgLFXfOUze8GytqKW6jHhj2exe7aeBB"
  @tumblr_secret = "BXyaIdbH2alYndsv1Tf1ON4cM7oZo3dEpFEbFCfH7iXCXTE7hG"
  @etsy_key = "4m8b59u9y7fzyyxqtpbmnw39"
  @instagram_key = ""
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

  # *** TUMBLR ***
  if @data["tumblr_blog"] != ""

    tumblr_request = "http://api.tumblr.com/v2/blog/" +
      @data["tumblr_blog"].to_s +
      "/posts" +
      "?api_key=" + @tumblr_key 

    begin
      tumblr_repsonse = RestClient.get tumblr_request, {:params => {}, :accept => :json}
    rescue Error => e
      puts e
    end

    @tumblr_posts = JSON.parse tumblr_repsonse
  end

  # *** VIMEO ***
  if @data["vimeo_username"] != ""
    vimeo_request = "http://vimeo.com/api/v2/" + @data["vimeo_username"] + "/videos.json"

    begin
    vimeo_response = RestClient.get vimeo_request, {:params => {}, :accept => :json}
    rescue Error => e
      puts e
    end
    @vimeo_videos = JSON.parse vimeo_response
  end

  # *** ETSY ***
  if @data["etsy_shop_id"] != ""
    etsy_request = "http://openapi.etsy.com/v2/shops/" + @data["etsy_shop_id"] + "/listings/active.json"

    begin
      etsy_response = RestClient.get etsy_request, {:params => { :api_key => @etsy_key, :includes => "MainImage" }, :accept => :json}
    rescue Error => e
      puts e
    end
    
    puts etsy_response
    @etsy_products = JSON.parse etsy_response
      
  end

  if @data["spotify_playlist"] != ""

  end
  
  erb :page
end
