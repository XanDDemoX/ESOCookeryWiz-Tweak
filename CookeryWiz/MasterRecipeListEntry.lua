
MasterRecipeListEntry = {}

function MasterRecipeListEntry:new (category, recipelink)
  o = {cat = category, rid = recipelink}
  setmetatable(o, self)
  self.__index = self      
  return o
end


-- Gets the corresponding list index in the game
function MasterRecipeListEntry:GetRecipeIndex()
  if not self.recipeIndex then
    local name = self:GetFoodResultName()
    local listName,numRecipes,upIcon,downIcon,overIcon,disabledIcon,createSound = GetRecipeListInfo(self.cat)
    for i=1, numRecipes do    
      local known, recipeName, numIngredients, provisionerLevelReq, qualityReq, specialIngredientType = GetRecipeInfo(self.cat, i)
      --d("-"..recipeName)
      if recipeName == name then
        self.recipeIndex = i
        break;
      end    
    end
  end
  return self.recipeIndex
end

-- Returns the recipe list index it belongs to
function MasterRecipeListEntry:GetRecipeListIndex()
  return self.cat
end

function MasterRecipeListEntry:GetIngredientCount()
  if not self.numIngredients then
    self.numIngredients = GetItemLinkRecipeNumIngredients(self.rid)
  end
  return self.numIngredients
end

function MasterRecipeListEntry:GetStackCount()
  local _, icon, stack, sellPrice, quality = GetRecipeResultItemInfo(self:GetRecipeListIndex(), self:GetRecipeIndex())
  return stack
end

-- Returns a table of ingredients
function MasterRecipeListEntry:GetIngredients()
  --if not self.ingredients then
    local ingredients = {}
    local total = self:GetIngredientCount()
    
    for i=1, total do
      local name, stockedAmount = GetItemLinkRecipeIngredientInfo(self.rid, i)

      --d(name.."["..stockedAmount.."]")
      -- They are all now one of each?
      local entryIngredient = MasterRecipeListIngredients:GetEntryByName(name)
      local entry = { name = name, link = entryIngredient:GetLink(), quantity = 1, stocked = stockedAmount }
      ingredients[#ingredients + 1] = entry
    end

    self.ingredients = ingredients
  --end
  return self.ingredients
end

function MasterRecipeListEntry:GetRecipeNameLower()
  if not self.lowername then
    self.lowername = self:GetRecipeName():lower()
  end
  return self.lowername
end

function MasterRecipeListEntry:GetRecipeName()
  if not self.name then
    self.name = GetItemLinkName(self.rid)
  end
  return self.name
end

function MasterRecipeListEntry:GetRecipeLink()
  return self.rid
end

function MasterRecipeListEntry:IsKnown()
  return IsItemLinkRecipeKnown(self.rid)
end
-- returns the index of this entry in the master recipe list table
function MasterRecipeListEntry:GetIndex()
  return self.index
end

function MasterRecipeListEntry:GetFoodResultLink()
    if not self.fid then
      self.fid = GetItemLinkRecipeResultItemLink(self.rid)
    end  
    return self.fid
end

function MasterRecipeListEntry:GetFoodResultLevel()
  if not self.foodLevel then
    self.foodLevel = GetItemLinkRequiredLevel(self:GetFoodResultLink())
  end
  return self.foodLevel
end

function MasterRecipeListEntry:GetFoodResultVetRank()
  if not self.foodVetRank then
    self.foodVetRank = GetItemLinkRequiredVeteranRank(self:GetFoodResultLink())
  end
  return self.foodVetRank
end

function MasterRecipeListEntry:GetFoodResultQuality()
  if not self.foodQuality then
    local link = self:GetFoodResultLink()
    self.foodQuality = GetItemLinkQuality(link)
  end
  return self.foodQuality
end

function MasterRecipeListEntry:GetFoodResultName()
  return GetItemLinkName(self:GetFoodResultLink())
end

