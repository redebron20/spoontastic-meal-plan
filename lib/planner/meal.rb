class SpoontasticMealPlan::Meals
    # attr_accessor :id, :title
    # attr_reader :instruction, :ingredients, :servings, :readyinMinutes
    
    @@all = []

    def initialize(meal_hash)
        meal_hash.each do |k, v| 
            self.class.attr_accessor key
            self.send(("#{k}="), v)
        end
        save
    end

    def save
        self.class.all < self
    end

    def self.all
        @@all
        binding.pry
    end
    
    def add_instruction(instruction)
        @instruction = instruction
    end
    
    def add_ingredients(ingredients)
        @ingredients = ingredients
    end

    def self.reset
        @@all.clear
    end 
    

end