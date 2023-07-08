# frozen_string_literal: true

require_relative 'recipe'

describe Recipe do
  before do
    Recipe.clear

    Recipe.describe do
      recipe 'Pancake' do
        ingredient 'Store-bought pancake mix'
        ingredient 'Water'

        method do
          step 'Mix the ingredients'
          step 'Cook them in a pan'
        end
      end

      recipe 'Miso Soup' do
        ingredient 'Tofu'
        ingredient 'White miso paste'

        method do
          step 'Mix miso paste into boiling water'
          step 'Add tofu and serve'
        end
      end
    end
  end

  it 'records the ingredients and method of each recipe' do
    pancake_recipe = Recipe.for('Pancake')

    expect(pancake_recipe.name).to eq 'Pancake'
    expect(pancake_recipe.ingredients).to eq ['Store-bought pancake mix', 'Water']
    expect(pancake_recipe.method_steps).to eq ['Mix the ingredients', 'Cook them in a pan']

    soup_recipe = Recipe.for('Miso Soup')

    expect(soup_recipe.name).to eq 'Miso Soup'
    expect(soup_recipe.ingredients).to eq ['Tofu', 'White miso paste']
    expect(soup_recipe.method_steps).to eq ['Mix miso paste into boiling water', 'Add tofu and serve']
  end

  it 'returns nil for non-existent recipes' do
    expect(Recipe.for('Non-existent Recipe')).to be_nil
  end

  it 'returns an array of all recipe names' do
    recipe_names = Recipe.list_recipes
    expect(recipe_names).to contain_exactly('Pancake', 'Miso Soup')
  end

  it 'removes an ingredient from a recipe' do
    pancake_recipe = Recipe.for('Pancake')
    pancake_recipe.remove_ingredient('Water')

    expect(pancake_recipe.ingredients).to eq ['Store-bought pancake mix']
  end

  it 'removes a step from a recipe' do
    pancake_recipe = Recipe.for('Pancake')
    pancake_recipe.remove_step('Cook them in a pan')

    expect(pancake_recipe.method_steps).to eq ['Mix the ingredients']
  end

  context 'with validation' do
    it 'returns error when name is empty' do
      expect do
        Recipe.describe do
          recipe '' do
            ingredient 'Tofu'
            ingredient 'White miso paste'

            method do
              step 'Mix miso paste into boiling water'
              step 'Add tofu and serve'
            end
          end
        end
      end.to raise_error('name cannot be blank')
    end

    it 'returns error when ingredient is empty' do
      expect do
        Recipe.describe do
          recipe 'Miso Soup2' do
            method do
              step 'Mix miso paste into boiling water'
              step 'Add tofu and serve'
            end
          end
        end
      end.to raise_error('please add at least one ingredient')
    end

    it 'returns error when step is not given' do
      expect do
        Recipe.describe do
          recipe 'Miso Soup' do
            ingredient 'Tofu'
            ingredient 'White miso paste'
          end
        end
      end.to raise_error('please add at least one step')
    end

    it "doesn't store an invalid recipe" do
      expect do
        Recipe.describe do
          recipe 'Miso Soup2' do
            method do
              step 'Mix miso paste into boiling water'
              step 'Add tofu and serve'
            end
          end
        end
      end.to raise_error('please add at least one ingredient')

      recipe_names = Recipe.list_recipes
      expect(recipe_names).not_to include('Miso Soup2')
    end

    it 'show all error messages' do
      expect do
        Recipe.describe { recipe('') {} }
      end.to raise_error(
        'name cannot be blank, please add at least one ingredient, please add at least one step'
      )
    end
  end
end
