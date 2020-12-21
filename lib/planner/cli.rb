class SpoontasticMealPlan::CLI

    attr_accessor :user_diet, :user_intolerance

    def run
        a = Artii::Base.new
        puts ""
        puts a.asciify('H E L L O !').green
        puts "Welcome to Spoontastic Meal Plan!".upcase.black.on_yellow
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
        puts "Please select your diet from the below list. Use a comma to separate multiple choices (e.g., '3, 5').".black.on_light_green
        puts "Type 'n' if you don't follow these diets.".black.on_light_green
        puts ""
        list_results(diet_list)
        puts ""

        diet_input = gets.strip.split(", ")
        unless input_validation(diet_input, diet_list)
            puts ""
            invalid_input
            puts ""
            get_diet
        end

        @user_diet = select_search_word(diet_input, diet_list)
    end

    def get_intolerance
        intolerance_list = SpoontasticMealPlan::MealScraper.intolerances
        puts ""
        puts "Please select intolerance/s from the below list. Use a comma to separate multiple choices (e.g., '3, 5').".black.on_light_green
        puts "Type 'n' if none.".black.on_light_green
        puts ""
        list_results(intolerance_list)
        puts ""

        intolerance_input = gets.strip.split(", ")
        unless input_validation(intolerance_input, intolerance_list)
            invalid_input
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
        }
    end

#Mealplan Controller
    def get_mealplan_day
        puts ""
        puts "Here's your curated daily meal plan:".black.on_yellow
        puts ""

        SpoontasticMealPlan::API.get_mealplan_day(search_hash)
    end

    def display_mealplan_day
        SpoontasticMealPlan::Meal.all.each.with_index(1) do |recipe_obj, i|
            puts ""
            puts "#{i}.#{recipe_obj.title}".magenta.underline
            puts "Ready in #{recipe_obj.readyinMinutes} minutes"
            puts ""
        end
    end

    def get_new_mealplan_list
        SpoontasticMealPlan::Meal.reset
        get_mealplan_day
        display_mealplan_day
    end

    def select_recipe
        puts ""
        puts "Select a number to learn more about the recipe, or enter 'new' to generate a new meal plan.".black.on_light_green
        puts ""
        #puts "Enter 'x' to quit the program."

        input = gets.strip.downcase

        unless selection_validation(input)
            invalid_input
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
        puts ""
        puts "Title: #{recipe.title}".upcase.black.on_yellow
        puts "Cook Time: #{recipe.readyinMinutes} minutes"
        puts "Serves: #{recipe.servings}"
        puts ""
        puts "Steps:".magenta.underline
        recipe.instruction.each.with_index(1) { |step, i| puts "#{i}. #{step}" }
        puts ""
        puts "Ingredients:".magenta.underline
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
        prompt = TTY::Prompt.new
        # puts ""
        # puts "Would you like to add these ingredients to your shopping list? (y/n)"
        puts ""
        input = prompt.yes?("Would you like to add these ingredients to your shopping list?")
        # unless planner_input_validation(input)
        #   invalid_input
        #   shopping_list(recipe)
        # end

        if input
          update_serving(recipe)
          display_shopping_list
        else
          display_mealplan_day
          select_recipe
        end
    end

    def planner_input_validation(input)
        input || !input
    end

    def update_serving(recipe)
        puts ""
        puts "How many servings of #{recipe.title} would you like to make?".black.on_light_green
        puts ""
        serving_input = gets.strip.to_i
        unless serving_input > 0
          invalid_input
          update_serving(recipe)
        end

        updated_ingredient = recipe.ingredient.map do |ingredient_hash|
          ingredient_hash["amount"] *= (serving_input.to_f / recipe.servings.to_f)
          ingredient_hash
        end

        SpoontasticMealPlan::Ingredient.create_from_collection(updated_ingredient)
        puts ""
        puts "Ingredients for #{serving_input} servings of #{recipe.title} have been added to your shopping list.".black.on_magenta
        puts ""
    end

    def display_shopping_list
        prompt = TTY::Prompt.new
        puts ""
        # puts "Would you like to see your shopping list? (y/n)"
        # puts ""
        display_sl_input = prompt.yes?("Would you like to see your shopping list?")
        puts ""
        # unless display_sl_input_validation(display_sl_input)
        #   puts "Invalid input. Let's try again.".red.on_yellow
        #   display_shopping_list
        # end


        if display_sl_input
            puts "Shopping list:".black.on_yellow
            puts ""
            SpoontasticMealPlan::Ingredient.all.each do |ingredient_obj|
                parsed_amount = parse_ingredient_amount(ingredient_obj.amount)
                puts "#{parsed_amount} #{ingredient_obj.unit} #{ingredient_obj.name}"
            end
            get_more_input
        else
            display_mealplan_day
            select_recipe
        end
    end

    # def display_sl_input_validation(input)
    #     input == "y" || input == "n"
    # end

    def get_more_input
        puts ""
        puts "Enter 'more' to add more ingredients or 'x' to quit.".black.on_light_green
        puts ""
        more_input = gets.strip.downcase
        unless more_input_validation(more_input)
          invalid_input
          get_more_input
        end

        if more_input == "more"
            display_mealplan_day
            select_recipe
        else
           goodbye
        end
    end

    def more_input_validation(input)
        input == "more" || "x" || "exit"
    end

    def invalid_input
        puts "Invalid input. Let's try again.".red
    end

    def goodbye
        a = Artii::Base.new
        puts ""
        puts "Thank you for using the app!".black.on_yellow
        puts ""
        puts a.asciify('G O O D B Y E!').green
    end

end





