
MasterRecipeListIngredient = {}

function MasterRecipeListIngredient:new (ingredientlink)
  o = {id = ingredientlink}
  setmetatable(o, self)
  self.__index = self      
  return o
end

function MasterRecipeListIngredient:GetName()
  if not self.name then
    self.name = GetItemLinkName(self.id)
  end
  return self.name  
end

function MasterRecipeListIngredient:GetNameLower()
  if not self.lowername then
    self.lowername = self:GetName():lower()
  end
  return self.lowername
end

function MasterRecipeListIngredient:GetLink()
  return self.id
end
