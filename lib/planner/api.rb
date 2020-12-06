class API

    URL = "https://api.spoonacular.com/mealplanner/generate"
    
    def call
        extention = "?apiKey=#{ENV['API_KEY']}"
        url = URL + extention
        uri = URI(url)
        response = Net::HTTP.get(uri)
        formatted_resp = JSON.parse(response)
        #resp_2 = HTTParty.get(url)
        
        binding.pry

    end

end
