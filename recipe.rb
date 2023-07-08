# frozen_string_literal: true

# store any recipes
class Recipe
  @recipes = {}

  attr_accessor :name, :ingredients, :method_steps, :errors

  def initialize(name)
    @name = name # recipe name
    @ingredients = [] # store ingredients
    @method_steps = [] # store steps
    @errors = []
  end

  def self.clear
    @recipes = {} # clear all stored recipe
  end

  def self.for(name)
    @recipes[name] # get stored recipe object
  end

  def self.list_recipes
    @recipes.keys
  end

  def self.describe(&block)
    instance_eval(&block) # execute code block within a context of a class recipe
  end

  def self.recipe(name, &block)
    recipe = Recipe.new(name) # create recipe object
    recipe.instance_eval(&block) # execute code block within a context of object
    @recipes[name] = recipe # store to class variable
  end

  def ingredient(name)
    @ingredients << name # store any given ingredients
  end

  def remove_ingredient(name)
    @ingredients.delete(name) # remove
  end

  def method(&block)
    instance_eval(&block) # execute code block within a context of object
  end

  def step(name)
    @method_steps << name # store any given steps
  end

  def remove_step(name)
    @method_steps.delete(name)
  end
end
