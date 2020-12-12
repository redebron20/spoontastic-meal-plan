class SpoontasticMealPlan::Meal
    # attr_accessor :id, :title
    # attr_reader :instruction, :ingredients, :servings, :readyinMinutes
    
    @@all = []

    def initialize(meal_hash)
        meal_hash.each do |k, v| 
            self.class.attr_accessor k
            self.send(("#{k}="), v)
        end
        save
    end

    def save
        self.class.all << self
    end

    def self.all
        @@all
    end
    
    def add_instruction(instruction)
        @instruction = instruction
    end
    
    def add_ingredients(ingredient)
        @ingredient = ingredient
    end

    def self.reset
        @@all.clear
    end 
    

end