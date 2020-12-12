
class SpoontasticMealPlan::CLI

    attr_accessor :user_diet, :user_intolerance, :timeframe

    def call
        puts ""
        puts "Hello! Welcome to Spoontastic Meal Plan."
        puts ""

        get_diet
        get_intolerance

        get_mealplan_day
        display_mealplan_day
        select_recipe   
    end

    def get_diet
        diet_list = SpoontasticMealPlan::MealScraper.diets
        puts ""
        puts "Please select your diet from the below list. Use a comma to separate multiple choices (e.g., '3, 5'). Press 'n' if you'd like to skip."
        puts ""
        list_results(diet_list)

        diet_input = gets.strip.split(", ")
        unless input_validation(diet_input, diet_list)
            puts ""
            puts "Invalid input. Let's try again."
            puts ""
            get_diet
        end

        @user_diet = select_search_word(diet_input, diet_list)
    end

    def get_intolerance
        intolerance_list = SpoontasticMealPlan::MealScraper.intolerances
        puts ""
        puts "Please select intolerance/s from the below list. Use a comma to separate multiple choices (e.g., '3, 5'). Press 'n' if none."
        puts ""
        list_results(intolerance_list)

        intolerance_input = gets.strip.split(", ")
        unless input_validation(intolerance_input, intolerance_list)
            puts ""
            puts "Invalid input. Let's try again."
            get_intolerance
        end
        
        @user_intolerance = select_search_word(intolerance_input, intolerance_list)
    end

    def list_results(array)
        array.each.with_index(1) do |element, index|
            puts "#{index}. #{element}"
        end
    end

    def input_validation(input_arr, data)
        input_arr.all? do |input|
          (1..data.length).include?(input.to_i) || input.downcase == "n"
        end   
    end

    def select_search_word(input_arr, data)
        input_arr.map do |input|
          input.downcase == "n" ? "" : data[input.to_i - 1]
        end 
    end

    def search_hash
        @search_hash = {
          diet: user_diet,
          intolerance: user_intolerance,
          #timeframe: timeframe
        }
    end

#Mealplan Controller
    def get_mealplan_day 
        puts ""       
        puts "Here's your curated meal plan for the day."

        SpoontasticMealPlan::API.get_mealplan_day(search_hash)
    end

    def display_mealplan_day
        SpoontasticMealPlan::Meal.all.each.with_index(1) do |recipe_obj, i|
            puts ""
            puts "#{i}. #{recipe_obj.title}"
            puts "ReadyInMinutes #{recipe_obj.readyinMinutes}"
            puts "Servings #{recipe_obj.servings}"
            puts ""
        end 
    end

    def get_new_mealplan_list
        SpoontasticMealPlan::Meal.reset
        get_mealplan_day
        print_mealplan_day
    end

    def select_recipe
        puts "Type a number to see the recipe, or enter 'new' to generate a new meal plan."
        #or 'x' to quit the program.

        input = gets.strip.downcase
    
        unless selection_validation(input)
            puts "Invalid input. Let's try again."
            select_recipe
        end
    
        if input == "new"
            get_new_mealplan_list
            select_recipe
        # elsif input == "x" || "exit"
        #     goodbye
        elsif
            get_recipe(input)
        end 
    end
    
    def selection_validation(input)
        (1..SpoontasticMealPlan::Meal.all.length).include?(input.to_i) || input == "new"
    end

    def get_recipe(input)
        index = input.to_i - 1
        selected_recipe = SpoontasticMealPlan::Meal.all[index]
        add_recipe_details(selected_recipe)
    end

    def add_recipe_details(recipe)
        
        recipe_instruction = SpoontasticMealPlan::API.get_recipe_instruction(recipe.id)
        recipe.add_instruction(recipe_instruction.flatten)
    
        recipe_ingredient = SpoontasticMealPlan::API.get_recipe_ingredient(recipe.id)
        recipe.add_ingredient(recipe_ingredient)
               
        # recipe_serving = SpoontasticMealPlan::API.get_serving(recipe.id)
        # recipe.add_serving(recipe_serving)
      
        display_recipe(recipe)
    end 

    def display_recipe(recipe)
        puts "Title: #{recipe.title}"
        puts "Cook Time: #{recipe.readyinMinutes} minutes"
        puts "Serves: #{recipe.servings}"
        puts ""
        puts "Steps:"
        recipe.instruction.each.with_index(1) { |step, i| puts "#{i}. #{step}" }
        puts ""
        puts "Ingredients:"
        recipe.ingredient.each do |ingredient_hash|
            parsed_amount = parse_ingredient_amount(ingredient_hash["amount"])
            puts "#{parsed_amount} #{ingredient_hash['unit']} #{ingredient_hash['name']}"
        end

        shopping_list(recipe)
    end

    def parse_ingredient_amount(amount)
        amount_arr = amount.to_s.split(".")
        if amount_arr[1] == "0"
            amount_arr[0]
        else
            amount = amount.to_r.rationalize(0.05)
            amount_as_integer = amount.to_i
            if (amount_as_integer != amount.to_f) && (amount_as_integer > 0)
            fraction = amount - amount_as_integer
            "#{amount_as_integer} #{fraction}"
            else
                amount.to_s
            end
        end
    end

    def shopping_list(recipe)
        puts "Would you like to add ingredients to your shopping list? (y/n)"
        input = gets.strip.downcase
        unless input_validation(input)
          puts "Invalid input. Let's try again."
          shopping_list(recipe)
        end
    
        if input == "y"
          update_servings(recipe)
          display_shopping_list
        else 
          display_mealplan_day
          select_recipe
        end
      end 

      def planner_input_validation(input)
        input == "y" || input == "n"
      end 

    def goodbye
        puts ""
        puts "Until then. Goodluck with meal planning! Please come back anytime."
    end

    def invalid_entry
        puts "Invalid entry. Please choose 'day' or 'week' or exit."
        menu
    end
end


    


