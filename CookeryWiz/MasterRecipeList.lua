
local masterRecipeList = {}

MasterRecipeList = {}
MasterRecipeList.name = "MasterRecipeList"

local function trace(obj)
  d(obj)
end

function MasterRecipeList:GetEntryByFoodName(foodName)    
  for key, masterEntry in pairs(masterRecipeList) do 
    local foodResultName = masterEntry:GetFoodResultName()

    if foodResultName == foodName then
      return masterEntry
    end
  end
end

-- Returns the MasterRecipeListEntry by index
function MasterRecipeList:GetEntry(index)
  if not index then
    trace("no index specified")
    return nil
  end
  
  if index > #masterRecipeList then
    trace("index greater than number of recipes")
    return nil    
  end
  
  if index <= 0 then
    trace("index less than 1")
    return nil    
  end
  
  return masterRecipeList[index]
end

-- returns the number of recipes in the list
function MasterRecipeList:GetCount()
  return #masterRecipeList
end

-- Maps the recipes to the ingame list indexes and creates lowercase name
-- Should be called whenever the game first loads and when a recipe is learnt!
function MasterRecipeList:RegenerateEntryIndexes()
  -- for performance reasons, we want to be more efficient with search filtering
  -- so create a lower case version of the recipe name
  -- and also get the in game recipe index
  for key, mrle in pairs(masterRecipeList) do 
    -- only get lowecase name if it has not been obtained
    mrle:GetRecipeNameLower()
    
    -- and add the recipe index. This is constant, but will not return any info if not learnt
    if not mrle.recipeIndex then
      local name,numRecipes,upIcon,downIcon,overIcon,disabledIcon,createSound = GetRecipeListInfo(mrle.cat)
      for i=1, numRecipes do
        local known, recipeName, numIngredients, provisionerLevelReq, qualityReq, specialIngredientType = GetRecipeInfo(mrle.cat, i)
        if recipeName.lower() == mrle.lowername then
          mrle.numIngredients = numIngredients
          mrle.recipeIndex = i
          break;
        end
      end
    end
    
  end  
end

function MasterRecipeList:Initialize()
  trace("MasterRecipeList:Initialize")
  MasterRecipeList:RegenerateEntryIndexes()
end

function MasterRecipeList.OnAddOnLoaded(event, addonName)
  if addonName == MasterRecipeList.name then
    MasterRecipeList:Initialize()
  end
end


-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(MasterRecipeList.name, EVENT_ADD_ON_LOADED, MasterRecipeList.OnAddOnLoaded)

---------------------------------------------------------------------------
-- Forget below here
---------------------------------------------------------------------------
local function ne(cat, rid)
    local mrle = MasterRecipeListEntry:new(cat, rid)
    local index = #masterRecipeList + 1
    mrle.index = index
    masterRecipeList[index] = mrle
end

ne(1,"|H1:item:45935:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45888:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45911:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45891:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45938:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45915:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45941:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45894:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45918:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45944:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45921:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45897:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45900:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45947:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45924:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45903:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45950:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45927:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45930:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45953:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45906:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45933:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45909:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45956:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45959:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56948:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56951:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45962:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56961:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56964:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45965:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56974:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56977:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:45968:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56986:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56989:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56998:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:56999:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(1,"|H1:item:57000:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45889:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45913:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45936:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45892:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45939:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45916:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45919:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45942:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45895:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45898:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45922:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45945:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45925:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45901:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45948:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45928:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45904:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45951:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45907:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45931:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45954:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45957:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:56946:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45910:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45960:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:56949:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:56950:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45963:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:56962:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:56963:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45966:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:56975:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:56976:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:45969:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:56987:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:56988:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:57001:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:57002:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(2,"|H1:item:57003:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45912:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45887:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45934:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45914:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45937:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45890:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45893:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45917:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45940:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45896:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45943:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45920:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45899:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45946:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45923:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45926:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45949:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45902:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45929:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45905:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45952:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45955:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45908:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45932:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45958:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:56952:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:56953:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45961:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:56965:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:56966:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45964:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:56978:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:56979:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:45967:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:56990:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:56991:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:57004:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:57005:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(3,"|H1:item:57006:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45636:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45675:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45654:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45639:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45678:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45657:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45681:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45642:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45660:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45685:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45646:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45664:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45688:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45649:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45667:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45672:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45693:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45652:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45699:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:56955:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:56956:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45705:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:56968:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:56969:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45711:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:56981:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:56982:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:45717:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:56993:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:56994:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:57007:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:57008:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(4,"|H1:item:57009:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45655:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45637:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45676:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45640:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45679:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45658:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45682:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45661:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45643:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45645:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45663:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45684:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45666:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45687:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45648:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45651:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45670:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:54243:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45697:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:56954:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:56957:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45703:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:56967:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:56970:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45709:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:56980:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:56983:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:45715:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:56992:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:56995:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:57010:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:57011:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(5,"|H1:item:57012:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45638:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45677:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45656:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45641:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45680:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45659:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45644:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45662:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45683:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45665:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45686:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45647:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45668:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45650:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45689:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45695:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45653:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45674:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45700:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:56958:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:56959:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45706:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:56971:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:56972:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45712:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:56984:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:56985:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:45718:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:56996:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:56997:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:57013:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:57014:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(6,"|H1:item:57015:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:56943:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:56944:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:56947:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:56945:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45671:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45690:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:54370:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45692:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45696:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45694:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45701:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45707:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45791:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45673:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:56973:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:54371:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:54369:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45710:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45698:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45708:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45719:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45702:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45704:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45714:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45716:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:45713:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(7,"|H1:item:57016:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45988:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45970:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45980:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45971:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45981:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45989:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45972:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45982:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45990:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45991:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:46035:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45973:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45984:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45974:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45992:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45993:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45975:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45985:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45994:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45976:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45986:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45995:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45977:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45987:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45978:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57020:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57023:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:45979:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57032:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57035:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:46048:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57044:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57047:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:46051:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:46054:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57056:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57062:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57063:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(8,"|H1:item:57064:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:45996:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46006:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46014:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46007:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46015:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:45997:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:45998:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46008:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46016:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46017:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46009:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:45999:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46000:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46018:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46010:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46011:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46019:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46001:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46002:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46012:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46020:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46021:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46003:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46013:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46004:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57021:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57022:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46005:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57033:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57034:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46049:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57045:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57046:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46055:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:46052:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57057:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57065:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57066:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(9,"|H1:item:57067:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46032:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46022:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46040:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46033:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46023:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46041:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46034:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46024:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46042:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46025:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:45983:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46043:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46036:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46026:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46044:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46045:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46027:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46037:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46028:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46046:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46038:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46047:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46029:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46039:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46030:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57024:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57025:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46031:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57036:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57037:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46050:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57048:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57049:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46056:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:46053:1:36:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57058:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57068:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57069:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(10,"|H1:item:57070:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45551:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45539:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45559:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45552:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45540:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45560:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45541:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45553:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45561:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45542:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45554:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45562:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45555:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45563:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45543:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45564:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45556:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45544:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45546:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57026:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57029:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45548:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57038:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57041:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:54241:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57050:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57053:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:54242:1:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:45631:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57059:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57071:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57072:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(11,"|H1:item:57073:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45579:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45587:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45567:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45580:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45568:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45588:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45569:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45589:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45581:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45590:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45582:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45570:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45571:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45591:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45583:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45592:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45572:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45584:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45574:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57027:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57028:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45604:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57039:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57040:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45622:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57051:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57052:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45633:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:45627:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57060:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57074:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57075:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(12,"|H1:item:57076:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45607:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45614:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45594:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45608:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45615:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45595:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45616:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45609:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45596:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45617:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45610:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45597:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45598:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45618:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45611:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45600:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45612:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45619:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45602:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57030:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57031:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45576:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57042:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57043:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45624:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57054:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57055:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45629:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:45535:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57061:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57077:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57078:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(13,"|H1:item:57079:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:57017:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:57018:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:57019:3:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:46079:1:35:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45545:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45691:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45565:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45575:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45601:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45547:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:46081:1:35:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45577:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45549:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45603:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:46082:1:35:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45620:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45621:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45573:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45623:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45632:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45625:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45626:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45628:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45557:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45634:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45599:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")
ne(14,"|H1:item:45630:1:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h")