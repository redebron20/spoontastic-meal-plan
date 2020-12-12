
class SpoontasticMealPlan::API

    def self.get_mealplan_day(search_hash)
        parsed_params = parse_search(search_hash)
        url = "https://api.spoonacular.com/mealplanner/generate?timeFrame=day&diet=#{parsed_params[:diet]}&intolerances=#{parsed_params[:intolerance]}&instructionsRequired=true&apiKey=#{ENV['API_KEY']}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        mealplan = JSON.parse(response)

        mealplan["meals"].each do |meals_hash|
            SpoontasticMealPlan::Meal.new({id: meals_hash["id"].to_i, title: meals_hash["title"], servings: meals_hash["servings"], readyinMinutes: meals_hash["readyInMinutes"]})
        end
    end

    def self.parse_search(search_hash)
        search_hash.transform_values! { |input_arr| input_arr.join("&").downcase.gsub(" ", "&") }
        search_hash
    end

    def self.get_recipe_instruction(id)
        uri = URI("https://api.spoonacular.com/recipes/#{id}/analyzedInstructions?apiKey=#{ENV['API_KEY']}")
        response = Net::HTTP.get(uri)
        instruction = JSON.parse(response)[0]
        instruction["steps"].map do |step_hash|
            step_hash.values_at("step")
        end
    end

    def self.get_recipe_ingredient(id)
        uri = URI("https://api.spoonacular.com/recipes/#{id}/information?includeNutrition=false&apiKey=#{ENV['API_KEY']}")
        #uri = URI(url)
        response = Net::HTTP.get(uri)
        ingredient = JSON.parse(response)
        ingredient["extendedIngredients"].map do |ingredient_hash|
            ingredient_hash.select { |k, v| k == "name" || k == "amount" || k == "unit"}
        end
    end

end
