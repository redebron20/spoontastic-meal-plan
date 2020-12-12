
class SpoontasticMealPlan::Ingredient
    # attr_accessor :name, :amount, :unit
    @@all = []

    def initialize(ingredient_hash)
        ingredient_hash.each do |k, v| 
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

end
