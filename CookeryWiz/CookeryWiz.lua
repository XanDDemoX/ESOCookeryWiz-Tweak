
local RECIPE_DATA_TYPE = 1
local INGREDIENT_DATA_TYPE = 2

local MAIL_COMMAND_KNOWN = 1

local MRL = MasterRecipeList

local L = CookeryWizLanguage.language

local filterOptions = { L[CWL_FILTER_ALL], L[CWL_FILTER_KNOWN], L[CWL_FILTER_QUANTITY], L[CWL_FILTER_UNKNOWN]}
local filterLevelOptions = { L[CWL_FILTER_ALL], "1-10", "11-20", "21-30", "31-40", "41-50", "V1-10"}

-- String used in the keybindings window
ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_COOKERYWIZ_WINDOW", "Show/Hide Cook Book")

CookeryWiz = EasyFrame:new()
CookeryWiz.name = "CookeryWiz"

-- scroll list control
CookeryWiz.recipeScrollList = nil

-- ingredients list control
CookeryWiz.ingredientsScrollList = nil

CookeryWiz.characterComboBox = nil
CookeryWiz.characterDropdown = nil

CookeryWiz.filterComboBox = nil
CookeryWiz.filterDropdown = nil
CookeryWiz.selectedFilter = nil

CookeryWiz.filterLevelComboBox = nil
CookeryWiz.filterLevelDropdown = nil
CookeryWiz.selectedFilterLevel = nil

CookeryWiz.qualityComboBox = nil
CookeryWiz.qualityDropdown = nil

CookeryWiz.savedVariables = nil

--CookeryWiz.masterRecipeList = nil
CookeryWiz.selectedPlayerName = nil

CookeryWiz.searchControl = nil

CookeryWiz.searchClearButtonControl = nil

CookeryWiz.optionsButtonControl = nil

CookeryWiz.clearOrdersButtonControl = nil

CookeryWiz.cookButtonControl = nil

CookeryWiz.mailButtonControl = nil


CookeryWiz.contentControl = nil

CookeryWiz.ingredients = {}

CookeryWiz.filterText = ""

CookeryWiz.provisionWritStartTextLower = "craft"

CookeryWiz.isCookingStationOpen = false
--CookeryWiz.isCooking = false
CookeryWiz.currentlyCooking = nil

CookeryWiz.scannedMailItems = {}
CookeryWiz.lastMailCount = -1
CookeryWiz.enableScanning = true
CookeryWiz.messages = nil

-- The very first time the mailbox is opened it will not be populated with messages
-- If this flag is true then we scan mail on the first read event instead
CookeryWiz.firstRead = true

CookeryWiz.ingredientMissingColour = "FF6347"

CookeryWiz.currentQuality = nil

CookeryWiz.recipeTooltipControl = nil
CookeryWiz.foodTooltipControl = nil
CookeryWiz.disableIngredientUpdate = false

CookeryWiz.editLinkControl = nil
CookeryWiz.cancelCooking = false

CookeryWiz.traceEnabled = false

local function trace(msg)
  CookeryWiz:Trace(msg)
end

---------------------------------------------------------------------
-- General functions
---------------------------------------------------------------------

function CookeryWiz:CookeryWizValidate()
  trace("Inside CookeryWizValidate")
  if not self then
    trace("You have called Validate without :")
    return
  end
  
  local res = true

  if not self.recipeScrollList then
      trace("No recipeScrollList")
      res = false
  end 
  
  if not self.characterDropdown then
    trace("No characterDropdown")
    res = false
  end
  
  res = self:EasyFrameValidate()
  return res
end

---------------------------------------------------------------------
-- Cookbook ScrollList related functions
---------------------------------------------------------------------

function CookeryWiz:GetCookEntry(masterRecipeIndex)
  local cookVars = self.savedVariables.cook
  for cookIndex, cookEntry in pairs(cookVars) do
    -- Each cookEntry looks like this { index = <index into masterrecipelist>, quantity = <quantity to cook>, tag = < a tag of some sort> }    
    if cookEntry.masterindex == masterRecipeIndex then
      --d("Matched recipe. Cook index "..cookIndex)
      return cookEntry
    end
  end  
end

-- Gets the first entry that still needs to be cooked
function CookeryWiz:GetFirstCookEntry()
  -- # on this is unreliable
  local cookVars = self.savedVariables.cook
  for cookIndex, cookEntry in pairs(cookVars) do
      return cookEntry
  end   
end

function CookeryWiz:IsCollapsed(cat) 
  local isCollapsed = self.savedVariables.collapsed[tostring(cat)]
  if isCollapsed then
    return true
  else
    return false
  end
end

function CookeryWiz:SetCollapsed(cat, collapsed)
  self.savedVariables.collapsed[tostring(cat)] = collapsed  
end

function CookeryWiz:RebuildMasterRecipeScrollList(listControl)
  if not listControl then
      trace("listControl is null")
      return
  end
   
 
	local scrollData = ZO_ScrollList_GetDataList(listControl)
	ZO_ScrollList_Clear(listControl)
	--ZO_ScrollList_ResetToTop(listControl)

  -- table of items to cook  
  local lastEntry = nil
  local collapsed = false
  local lastCat = 0
  local newEntry  = nil

  local characterVars = self.savedVariables.characters[self.selectedPlayerName];
  if not characterVars then
    --trace("No CharacterVars for "..self.selectedPlayerName)
    characterVars = { enabled = true, known = {} }
  end     

  local ALL = L[CWL_FILTER_ALL]
  local KNOWN = L[CWL_FILTER_KNOWN]
  local UNKNOWN = L[CWL_FILTER_UNKNOWN]
  local QUANTITY = L[CWL_FILTER_QUANTITY]
  
  local lastQuality = 0
  local lastMatchQuality = true
  
  local masterRecipeCount = MRL:GetCount()
  for masterRecipeIndex = 1, masterRecipeCount do
    local masterEntry = MRL:GetEntry(masterRecipeIndex)
    local isKnown = false
    local cookQuantity = 0
    local matchText = true
    local matchCategory = true
    local matchQuality = true
    local matchLevel = true
   
    -- filter on entered text
    if self.filterText ~= "" then
      local i, j = string.find(masterEntry:GetRecipeNameLower(), self.filterText)
      if not i then
        matchText = false    
      end
    end
    
    -- optimise by only checking if it has not already been filtered out
    if matchText then
      local knownEntry = characterVars.known[tostring(masterRecipeIndex)]
      if knownEntry then
        isKnown = true
      end
      local cookEntry = self:GetCookEntry(masterRecipeIndex)
      if cookEntry then
        --d("Found cook entry - q"..cookEntry.quantity)
        cookQuantity = cookEntry.quantity
      end      
      -- Filter on category
      if self.selectedFilter ~= ALL then
        if self.selectedFilter == QUANTITY then
          if cookQuantity <= 0 then
            matchCategory = false
          end          
        elseif self.selectedFilter == KNOWN then
          if not isKnown then        
            matchCategory = false
          end
        elseif self.selectedFilter == UNKNOWN then
           if isKnown then        
            matchCategory = false
          end       
        end      
      end    
    end
    
    -- Filter on level of food? { veteran, lower, upper }
    if matchCategory and self.selectedFilterLevel then
      local foodLevel = masterEntry:GetFoodResultLevel()
      if self.selectedFilterLevel.veteran then
        local vetRank = masterEntry:GetFoodResultVetRank()
        if vetRank < self.selectedFilterLevel.lower or vetRank > self.selectedFilterLevel.upper then
          matchLevel = false          
        end       
      else
        if foodLevel < self.selectedFilterLevel.lower or foodLevel > self.selectedFilterLevel.upper then
          matchLevel = false
        end
      end
    end
         
    -- filter on collapsed
    if masterEntry.cat ~= lastCat then
      -- check on quality for this cat
      local quality = masterEntry:GetFoodResultQuality() 

      if self.currentQuality[1] == quality or self.currentQuality[2] == quality or self.currentQuality[3] == quality then
        matchQuality = true
      else
        matchQuality = false
      end
      lastMatchQuality = matchQuality
      collapsed = self:IsCollapsed(masterEntry.cat)
      if matchQuality and matchText and matchCategory and matchLevel then
        lastCat = masterEntry.cat
        scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(RECIPE_DATA_TYPE,{ known = false, cat = lastCat})
      end
    end    
    
    -- if we found a match, then add this master recipe item
    
    if not collapsed and lastMatchQuality and matchText and matchCategory and matchLevel then
			scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(RECIPE_DATA_TYPE, { known = isKnown, masterindex = masterRecipeIndex })
      lastEntry = masterEntry
    end
    
  end

	ZO_ScrollList_Commit(listControl)

	return scrollData
end


function CookeryWiz:OnRecipeScrollListInitialized(control)
  trace("CookeryWiz:OnRecipeScrollListInitialized")
  self.recipeScrollList = control

  if not control then
      trace("RecipeScrollList is null")
      return
  end
  
  -- It is important to note that rows are reused. This is an efficient way of optimising memory usage
  -- However, the row control will have left over data and settings from the previous time it was used
  -- This means you cannot rely on defaults and must explicitly clear/set them
  local function InitializeBaseRow(self, rowControl, entry, fadeFavorite)
    local nameControl = rowControl:GetNamedChild("Name")
    local editAmountControl = rowControl:GetNamedChild("EditAmount")
    local expandButtonControl = rowControl:GetNamedChild("ExpandButton")
    local collapseButtonControl = rowControl:GetNamedChild("CollapseButton")
    local tickControl = rowControl:GetNamedChild("Tick")
    local currentExpandControl = nil
    local text = nil
    
    -- if there is a recipe id then display the link
    local masterEntry
    if entry.masterindex then
      masterEntry = MRL:GetEntry(entry.masterindex)
    end
    
    local cookEntry = nil
    
    if masterEntry and masterEntry.rid then
      text = masterEntry.rid
      cookEntry = self:GetCookEntry(entry.masterindex)
      entry.cook = cookEntry
      
      expandButtonControl:SetHidden(true)
      collapseButtonControl:SetHidden(true)
      
      nameControl:ClearAnchors()
      nameControl:SetAnchor(LEFT, editAmountControl, RIGHT, 10)      
    else
      -- No recipe id, so it is a category. Show the name
      local name,numRecipes,upIcon,downIcon,overIcon,disabledIcon,createSound = GetRecipeListInfo(entry.cat)
      text = name
      local isCollapsed = self:IsCollapsed(entry.cat)
      if isCollapsed then
        currentExpandControl = expandButtonControl
        expandButtonControl:SetHidden(false)
        collapseButtonControl:SetHidden(true)
      else
        currentExpandControl = collapseButtonControl
        expandButtonControl:SetHidden(true)
        collapseButtonControl:SetHidden(false)        
      end
      
      
      currentExpandControl.cat = entry.cat
      -- is it expanded or collapsed
      --local textureControl = expandButtonControl:GetNamedChild("ExpandButton")
      --d(expandButtonControl)
      
      nameControl:ClearAnchors()
      nameControl:SetAnchor(LEFT, expandButtonControl, RIGHT, 10)
      
      --local expandTextureControl = expandButtonControl:GetNamedChild("TextureExpand")  
      --self:SetExpandButtonTexture(expandTextureControl, isCollapsed, true)      
    end
    
    -- Store the recipe list entry object with the Name control so we can fetch it later at will
    nameControl.entry = entry
    nameControl:SetText(text)
       
    -- if there is no recipe id then this is a heading
    if not masterEntry or not masterEntry.rid then
      tickControl:SetHidden(true)
      editAmountControl:SetHidden(true)
    else
      -- do we know this recipe?
      if entry.known then
        tickControl:SetHidden(false)
      else
        tickControl:SetHidden(true)
      end
      editAmountControl:SetHidden(false)     
    end
    
    -- We dont want to show 0 quantities
    if cookEntry and cookEntry.quantity ~= 0 then
      editAmountControl:SetText(cookEntry.quantity)
    else
      editAmountControl:SetText("")
    end
    
  end

  local function DestroyBaseRow(rowControl)
    ZO_ObjectPool_DefaultResetControl(rowControl)
  end

 	local function InitializeRecipeRow(rowControl, entry)
		InitializeBaseRow(self, rowControl, entry, false)
  end
  
	local function DestroyRecipeRow(rowControl)
		DestroyBaseRow(rowControl)
	end  
  
  ZO_ScrollList_Initialize(control)
  ZO_ScrollList_AddDataType(control, RECIPE_DATA_TYPE, "RecipeRowTemplate", 24, InitializeRecipeRow, nil, nil, DestroyRecipeRow)
	ZO_ScrollList_AddResizeOnScreenResize(control)

end



function CookeryWiz:SetExpandButtonTexture(textureControl, isCollapsed, normal)
  if normal then
    if isCollapsed then
      --textureControl:SetTexture("/esoui/art/buttons/plus_up.dds")
    else
      --textureControl:SetTexture("/esoui/art/buttons/minus_up.dds")
    end  
  else
    if isCollapsed then
      --textureControl:SetTexture("/esoui/art/buttons/plus_up.dds")
    else
      --textureControl:SetTexture("/esoui/art/buttons/minus_up.dds")
    end     
  end
end

function CookeryWiz:OnExpandButtonInitialized(control)
  local cookeryWiz = self
  control:SetHandler("OnMouseEnter", function(self)
      local text
      if cookeryWiz:IsCollapsed(control.cat) then
        text = L[CWL_BUTTON_TOOLTIP_EXPAND]
      else
        text = L[CWL_BUTTON_TOOLTIP_COLLAPSE]
      end
      ZO_Tooltips_ShowTextTooltip(self, TOP, text)
      
    end)
  control:SetHandler("OnMouseExit", function(self)
        ZO_Tooltips_HideTextTooltip()
      
    end)  
  control:SetHandler("OnClicked", function(self)
        cookeryWiz:OnExpandButtonClicked(control)
    end)
end


function CookeryWiz:OnExpandButtonClicked(control)

  local collapsed = self:IsCollapsed(control.cat)
  self:SetCollapsed(control.cat, not collapsed)

  self:OnReloadRecipes(false, control)
  
end

---------------------------------------------------------------------
-- Mailbox functions
---------------------------------------------------------------------

-- Helper function to split a string into a table object
function split(str, delim)
    local res = {}
    local pattern = string.format("([^%s]+)%s", delim, delim)
    for line in str:gmatch(pattern) do
        table.insert(res, line)
    end
    return res
end

function CookeryWiz:EnableScanning(enableScanning)
  self.enableScanning = enableScanning
end

 
function CookeryWiz.OnMailReadable(eventCode, mailId)
  local self = CookeryWiz
  local mailStringId = Id64ToString(mailId) 
  trace("OnMailReadable: code["..eventCode.."], mailid[".. mailStringId .."]")
  
  if self.firstRead then
    self.firstRead = false
    self:ScanMail()
    return
  end
  
  -- if we have no messages we are interested in then exit
  if not self.messages then
    trace("No messages to parse so exiting")
    return
  end
  
  -- Is this an entry we are interested in?
  message = self:GetMatchingMessage(mailId)  
  if not message then
    trace("No matching message to parse so exiting")
    return
  end
  
  d(string.format(L[CWL_NOTIFY_IMPORTING_CHARACTER], self.name, message.storageName))
  
  local body = ReadMail(message.mailId)   
  if not body or #body == 0 then
    d(L[CWL_NOTIFY_MAIL_MISSING_BODY])
  else
    self:ParseEmail(message.stringMailEntry, message.storageName, body, message.secsSinceReceived)      
  end
  
  -- move to the next one
  self.messages[message.storageName] = nil
  message = self:GetNextMessage()
  if message then
    RequestReadMail(message.mailId)
  else 
      -- we are done
      trace("No remaining messages to parse so exiting")
      self.messages = nil
      self:PopulateCharacterDropDown()
  end  
  
end

function CookeryWiz:ParseEmail(mailStringId, storageName, body, secsSinceReceived)
  
  local characterVars = self.savedVariables.characters[storageName];
  if not characterVars then
    trace("Creating storage for this character")
    -- NOTE: 2592000 seconds is roughly 30 days, which is how long a message can be in the inbox for
    characterVars = { enabled = true, external = nil, seconds = 2592000, known = {} }
  end 
  characterVars.external = mailStringId
  characterVars.seconds = secsSinceReceived 
  
  local table = split(body, ",")
  
  -- now go through it
  trace("Table entries - "..#table)
  -- there should be at least the 'command' and the 'version'
  if #table >= 2 then
    -- replace it
    local known = {}
    local command = tonumber(table[1])
    local version = table[2]
    if command == MAIL_COMMAND_KNOWN then
      
      for i=3, #table do
        known[table[i]] = tonumber(table[i])
      end
      
      -- store this data, and repopulate the dropdown
      characterVars.known = known              
      self.savedVariables.characters[storageName] = characterVars
    end            
  end
  
end

function CookeryWiz:GetNextMessage()
  if not self.messages then
    return
  end
  
  for key, entry in pairs(self.messages) do
    return entry
  end      
end

function CookeryWiz:GetMatchingMessage(mailId)
  if not self.messages then
    return
  end
  
  for key, entry in pairs(self.messages) do
    if entry.mailId == mailId then
      return entry
    end
  end      
end

-- This function will scan the inbox for mails relating to CookeryWiz.
-- NOTE: Not sure why, but sometimes the mail count will be 0. This only appears to happen on the very first
-- time that the inbox is scanned. Perhaps a race condition if it has not been properly initialised?
function CookeryWiz:ScanMail()
  if not self.enableScanning then
    return
  end
  
  --RequestOpenMailbox() 
  local mailCount = GetNumMailItems()
  trace("Last Mail Count "..self.lastMailCount)
  if mailCount == self.lastMailCount then
    trace(string.format(L[CWL_NOTIFY_NOT_SCANNING], self.name, mailCount))
    return
  else
    trace(string.format(L[CWL_NOTIFY_SCANNING], self.name, mailCount))
  end

  local mailEntry = GetNextMailId(nil)

  while mailEntry do

    -- is it one we have checked before?
    for key, entry in pairs(self.scannedMailItems) do
      if entry == mailEntry then
        -- yep. exit
        trace("Scanned this email before "..mailEntry)
        return
      end      
    end
    
    -- we have not seen it. scan it    
    local senderDisplayName, senderCharacterName, subject, icon, unread, fromSystem, fromCustomerService, returned,
    numAttachments, attachedMoney, codAmount, expiresInDays, secsSinceReceived = GetMailItemInfo(mailEntry) 
    
    -- parse the subject line
    if subject:find(self.name)==1 then
      trace("Found mail for us '"..subject.." ["..mailEntry.."]'")
      -- it is meant for us
      local startPos = #self.name+2
      local characterName = subject:sub(startPos)

      -- The information is stored under a combination of characterName and account name
      -- make sure we have them both. If they are missing then it looks like this is an 
      -- email which is not correct
      if characterName ~= "" and senderDisplayName ~= "" then
        -- it's valid
        local storageName = characterName..senderDisplayName 
        
        local characterVars = self.savedVariables.characters[storageName];

        -- we dont want to parse this email if we dont have to. This is for performance reasons
        -- so the mail id is stored with the character's known recipes. We check this to see if
        -- we have already parsed the mail.
        -- In addition, if there happens to be more than one mail entry in the inbox for this character we
        -- we will not read it if it is older than the 'secondsreceived' entry of the existing one
        local stringMailEntry = tostring(mailEntry)
        
        if not characterVars or characterVars.external ~= stringMailEntry and secsSinceReceived < characterVars.seconds then

          if not self.messages then
            self.messages = {}
          end
          
          local message = self.messages[storageName]
          if not message then
            message = {}
            self.messages[storageName] = message
          else
            -- do we replace this?
            if secsSinceReceived < message.secsSinceReceived then
              trace("Replacing ["..message.mailId.."]")
              message = {}
              self.messages[storageName] = message             
            end
          end
          
          -- we could also check if we have an email for this storagename and
          -- replace if the current one is later
          
          message.mailId = mailEntry
          message.storageName = storageName
          message.secsSinceReceived = secsSinceReceived
          message.stringMailEntry = stringMailEntry
        end
      end
    end  
   
    -- for optimisation reasons, we record the mail ids of those already scanned
    -- this is only for the player session and we do not record them in the saved variables
    self.scannedMailItems[#self.scannedMailItems] = mailEntry   
    
    -- get the next mail entry id
    mailEntry = GetNextMailId(mailEntry)
  end
  
  -- now start the reading of the body process
  local message = self:GetNextMessage()  
  if message then
    RequestReadMail(message.mailId)
  end
  
  -- for further optimisation, store the count of emails when we parsed this. The scan routine is run when the inbox is opened
  -- if the user deletes items them the count will change, or new messages.
  self.lastMailCount = mailCount
end

function CookeryWiz.OnOpenMailBox(eventCode)
  --d("OnOpenMailBox")
  --zo_callLater(function() CookeryWiz:ScanMail() end, 500)
  local self = CookeryWiz
  if not self.firstRead then
    self:ScanMail()
  end    
end

function CookeryWiz.OnMailRemoved(eventCode, mailId)
  --trace("Mail removed")
  self = CookeryWiz
  self.lastMailCount = self.lastMailCount - 1
end

function CookeryWiz.OnCloseMailBox(eventCode)
  --d("OnCloseMailBox "..eventCode)
end

function CookeryWiz.OnMailSendFailed(eventCode, reason)
  d("OnMailSendFailed "..eventCode..", reason "..reason)
end

function CookeryWiz.OnMailSendSuccess(eventCode)
 --d("OnCloseMailBox "..eventCode)   
end

function CookeryWiz:OnMailButtonInitialized(control)
  --d("OnMailButtonInitialized")
  self.mailButtonControl = control
  self:SetupTooltip(control, L[CWL_BUTTON_TOOLTIP_MAILER])  
end

function CookeryWiz:SendKnownRecipes(characterName, address)

  local characterVars = self.savedVariables.characters[characterName];
  
  if not characterVars then
    --d("No CharacterVars Object")
    characterVars = { enabled = true, known = {} }
  end
     
  local t = {MAIL_COMMAND_KNOWN,1}
  
  -- populate the list of known recipes
  for key, value in pairs(characterVars.known) do
    table.insert(t, key)
  end
  
    --local knownEntry = characterVars.known[tostring(masterRecipeIndex)]
    --if knownEntry then
      --isKnown = true
    --end  
    --[[
  local masterRecipeCount = MRL:GetCount()
  for i = 1, masterRecipeCount do
    local mrle = MRL:GetEntry(i)
    if IsItemLinkRecipeKnown(mrle.rid) then
      table.insert(t, i)
    end  
  end  
  ]]--
  s = table.concat(t, ",") 
  --d(s)
  RequestOpenMailbox()
  SendMail(address, self.name.." "..characterName, s)
end

function CookeryWiz:OnMailShow(control)
  
end

function CookeryWiz:OnMailButtonClicked(control)
  CookeryWizMailer:ToggleShow(self.ui)
end

---------------------------------------------------------------------
-- EasyFrame virtual functions
---------------------------------------------------------------------

-- Use this function to hide and show controls according to whether we are shrunk or expanded
function CookeryWiz:OnShrink()
  if not self then
    d("OnShrink called without :")
    return
  end
  
  if not self.recipeScrollList then
    d("Missing recipeScrollList control")
    return    
  end
  
  local vars = self.easyFrameVariables
  local isShrunk = vars.isShrunk
  
  self.recipeScrollList:ClearAnchors()
  
  if isShrunk then
    -- hide controls
	self.recipeScrollList:SetAnchor(TOPRIGHT,self.contentControl,TOPLEFT,1,2)
  else
    -- show controls
	self.recipeScrollList:SetAnchor(TOPLEFT,self.contentControl,TOPLEFT,1,2)
	self.recipeScrollList:SetAnchor(BOTTOMLEFT,self.contentControl,BOTTOMLEFT,-4,-36)
  end

  local controls ={	self.recipeScrollList,
					self.characterComboBox,
					self.optionsButtonControl,
					self.mailButtonControl,
					self.searchContentControl }
  
  for i,control in ipairs(controls) do
	control:SetHidden(isShrunk)
  end 
 
end

function CookeryWiz:OnEasyFrameResize()
  --d("OnEasyFrameResize")
  
  if not self then
    d("OnEasyFrameResize called without :")
    return
  end
  
  if not self.recipeScrollList then
    d("Missing recipeScrollList")
    return    
  end
  
  if not self.ui then
    d("Missing ui")
    return    
  end
  
  local function SetScrollListDimensions(control, width, height)
    --control:SetWidth(width)
    --ZO_ScrollList_SetHeight(control, height)
    ZO_ScrollList_Commit(control)
  end

  SetScrollListDimensions(self.recipeScrollList, self.easyFrameVariables.width, self.easyFrameVariables.height)
end

function CookeryWiz:OnRestorePosition()
end


function CookeryWiz:SetHighlight(control, state)
  local bgControl = control:GetNamedChild("Bg")
  local highlightControl = control:GetNamedChild("Highlight")
  --d("Sethighlight")
  bgControl:SetHidden(state)
  highlightControl:SetHidden(not state)
end


-- Show the tooltip for the control
function CookeryWiz:ShowItemToolTip(control, state)
  local recipeTooltip = self.recipeTooltipControl
  local foodTooltip = self.foodTooltipControl
  if state then
    local labelControl = control:GetNamedChild("Name")
    -- the recipe data entry object was assigned to the control. A 'fake' one
    -- is created for the food categories and has no .rid or .fid
    local entry = labelControl.entry
    
    if entry.masterindex then
      local tooltipOffset = 10
      local masterEntry = MRL:GetEntry(entry.masterindex)
      local text = masterEntry.rid
      -- we need to determine optimal postion. If close to edge of screen funny things happen!
      local tooltipWidth = recipeTooltip:GetWidth()
      local left = self.easyFrameVariables.left
      local tooltipLeft = left
      
      local screenWidth = self.ui:GetParent():GetWidth()
      local uiWidth = self.ui:GetWidth()
      
      if left + uiWidth + tooltipWidth + tooltipOffset > screenWidth then
        InitializeTooltip(recipeTooltip, self.ui, TOPLEFT, -1 * (tooltipWidth + 10), -5, TOPLEFT)  
      else
        InitializeTooltip(recipeTooltip, self.ui, TOPLEFT, 10, -5, TOPRIGHT)
      end
        InitializeTooltip(foodTooltip, recipeTooltip, TOPLEFT, 0, 0, BOTTOMLEFT)
      
      --d("tooltipWidth-"..tooltipWidth..", tooltipLeft-"..tooltipLeft.."uiLeft-"..left)

      recipeTooltip:SetLink(text)
      -- food tooltip
      
      foodTooltip:SetLink(masterEntry:GetFoodResultLink())
    end
  else
    ClearTooltip(recipeTooltip)
    ClearTooltip(foodTooltip)
  end
end

function EasyFrame:OnHideWindow(isHidden)
  if isHidden then
    CookeryWizMailer:HideWindow(true)
    CookeryWizOptions:HideWindow(true)
  end
end

function CookeryWiz:OnShow(topLevelControl)
  --d("OnShow")
  self:OnReloadRecipes(true)
end

function CookeryWiz:OnReload()
  self:OnReloadRecipes(true)
  self:UpdateCookIngredients()   
end

function CookeryWiz:OnReloadRecipes(refreshCharacter)
  if not self then
    d("OnReloadRecipes called without :")
    return
  end
   
  -- check master recipes to see if known
  local numRecipeLists = GetNumRecipeLists()
  
  local characterName = self.selectedPlayerName  
  local characterVars = self.savedVariables.characters[characterName];
  
  -- Only refresh if the current player is the one selected
  -- As we have no way of refreshing other players!
  if refreshCharacter and characterName == GetUnitName("player") then
    self:RefreshCharacterKnowledge()
  end  

  self.disableIngredientUpdate = true
  local scrollData = self:RebuildMasterRecipeScrollList(self.recipeScrollList)
  self.disableIngredientUpdate = false
end

function CookeryWiz:OnMoveStop()
end

---------------------------------------------------------------------
-- Initialization functions
---------------------------------------------------------------------

function CookeryWiz:OnContentInitialized(control)
  self.contentControl = control

end

function CookeryWiz:OnSearchClearButtonInitialized(control)
  self.searchClearButtonControl = control
  self:SetupTooltip(control, L[CWL_BUTTON_TOOLTIP_CLEAR_SEARCH])
end

function CookeryWiz:OnSearchClearButtonClicked(control) 
  self.searchControl:SetText("");
end

function CookeryWiz:OnRecipeTooltipInitialized(control)
  if not control then
    d("Control is nil")
    return
  end
  self.recipeTooltipControl = control
  control:SetParent(PopupTooltipTopLevel)
end

function CookeryWiz:OnFoodTooltipInitialized(control)
  if not control then
    d("Control is nil")
    return
  end
  self.foodTooltipControl = control
  control:SetParent(PopupTooltipTopLevel)
end



---------------------------------------------------------------------
-- Ingredients scroll control functions
---------------------------------------------------------------------

function CookeryWiz:RepositionTooltip(control)
  -- we need to determine optimal postion. If close to edge of screen funny things happen!
  local tooltipOffset = 10
  local tooltipWidth = control:GetWidth()
  local left = self.easyFrameVariables.left
  local tooltipLeft = left
    
  local screenWidth = self.ui:GetParent():GetWidth()
  local uiWidth = self.ui:GetWidth()
    
  if left + uiWidth + tooltipWidth + tooltipOffset > screenWidth then
    InitializeTooltip(control, self.ui, TOPLEFT, -1 * (tooltipWidth + 10), 15, TOPLEFT)  
  else
    InitializeTooltip(control, self.ui, TOPLEFT, 10, 15, TOPRIGHT)
  end  
end

function CookeryWiz:OnIngredientsTooltipInitialized(control)
  if not control then
    d("Control is nil")
    return
  end
  control:SetParent(PopupTooltipTopLevel)
end

-- Show the tooltip for the control
function CookeryWiz:ShowIngredientToolTip(control, state)
  local tooltipControl = control:GetNamedChild("Tooltip")
  if state then
    local labelControl = control:GetNamedChild("Name")
    local entry = labelControl.entry
    
    if entry then
      local text = entry.link      
      self:RepositionTooltip(tooltipControl)
      tooltipControl:SetLink(text)
    end
  else
    ClearTooltip(tooltipControl)
  end
end

function CookeryWiz:OnListIngredientsInitialized(control)

  d("CookeryWiz:OnListIngredientsInitialized")
  self.ingredientsScrollList = control

  if not control then
      d("IngredientScrollList is null")
      return
  end
  
  -- It is important to note that rows are reused. This is an efficient way of optimising memory usage
  -- However, the row control will have left over data and settings from the previous time it was used
  -- This means you cannot rely on defaults and must explicitly clear/set them
  local function InitializeBaseRow(self, rowControl, entry, fadeFavorite)
    --d("Inside initialise base row")
    local nameControl = rowControl:GetNamedChild("Name")
    
    nameControl.entry = entry
    local stockedText = nil
    if entry.stocked and entry.stocked > 0 then
      stockedText = " ["..entry.stocked.."]"
    else
      stockedText = ""
    end
    
    if entry.stocked and entry.quantity <= entry.stocked then
      nameControl:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_NORMAL))
    else
      nameControl:SetColor(ZO_DEFAULT_DISABLED_COLOR:UnpackRGBA())
    end
    nameControl:SetText(entry.quantity.." x "..entry.link..stockedText)
    
  end

  local function DestroyBaseRow(rowControl)
    ZO_ObjectPool_DefaultResetControl(rowControl)
  end

 	local function InitializeIngredientRow(rowControl, entry)
		InitializeBaseRow(self, rowControl, entry, false)
  end
  
	local function DestroyIngredientRow(rowControl)
		DestroyBaseRow(rowControl)
	end  
  
  ZO_ScrollList_Initialize(control)
  ZO_ScrollList_AddDataType(control, INGREDIENT_DATA_TYPE, "IngredientRowTemplate", 24, InitializeIngredientRow, nil, nil, DestroyIngredientRow)
	ZO_ScrollList_AddResizeOnScreenResize(control)

end

---------------------------------------------------------------------
-- Cooking Action functions
---------------------------------------------------------------------

-- Gets the first entry that still needs to be cooked
-- that we can actually cook and we have the ingredients for
function CookeryWiz:GetFirstCookableEntry()
  -- # on this is unreliable  
  local cookVars = self.savedVariables.cook
  for cookIndex, cookEntry in pairs(cookVars) do
    local masterEntry = MRL:GetEntry(cookEntry.masterindex)
    -- First thing.. do we know it?
    if masterEntry:IsKnown() then
      local missingIngredients = false
      -- so far so good. Do we have enough ingredients?
      local ingredients = masterEntry:GetIngredients()
      for ingredientIndex = 1, #ingredients do
        local ingredient = ingredients[ingredientIndex]
        if ingredient.stocked == 0 then
          missingIngredients = true
          break;
        end
      end
      
      -- did we have enough ingredients?
      if not missingIngredients then
        -- yep! return this item
        return cookEntry, masterEntry
      end
    end    
  end   
end


function CookeryWiz:ResetCooking()
    self:SetCookButtonTitle(false)
    self.cancelCooking = false
    self.currentlyCooking = nil
end

function CookeryWiz:OnCookButtonInitialized(control)
  self.cookButtonControl = control
  
  self.cookButtonControl:SetEnabled(false)
  --control:SetText(L[CWL_BUTTON_COOK])
  --self:SetupTooltip(control, L[CWL_BUTTON_TOOLTIP_COOK])
  self:ResetCooking()
end


function CookeryWiz.OnCraftingStationInteract(eventCode, craftSkill, sameStation)
  if craftSkill ~= CRAFTING_TYPE_PROVISIONING then 
    return
  end
  local self = CookeryWiz

  self.isCookingStationOpen = true
  self:ResetCooking()
  --self.cancelCooking = false 
  --self.currentlyCooking = nil
  -- 131345
  --d("Cooking station interaction:event("..eventCode..")")
  --cookeryWiz.cookButtonControl:SetHidden(false)
  self.cookButtonControl:SetEnabled(true) 
  
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_CRAFT_COMPLETED, self.OnCraftCompleted)
end

function CookeryWiz.OnEndCraftingStationInteract(eventCode)
  local self = CookeryWiz
  --local cookeryWiz = CookeryWiz
  if self.isCookingStationOpen then
    -- 131346
    --d("Cooking station close interaction:event("..eventCode..")")
    self.isCookingStationOpen = false
    self:ResetCooking()
    --self.currentlyCooking = nil
    --self.cancelCooking = false    
    --self:SetCookButtonTitle(false)
    
    
    self.cookButtonControl:SetEnabled(false) 
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_CRAFT_COMPLETED)
  end
end

function CookeryWiz.OnCraftCompleted(eventCode, craftSkill)

  local self = CookeryWiz
  -- we ignore any craft completed if we are not doing the crafting!
  if not self.currentlyCooking then
    --d("we are not cooking so ignore")
    return
  end
  
  local cookEntry = self.currentlyCooking
  self.currentlyCooking = nil
  -- 131442
  --d("craftSkill{"..craftSkill.."-PROV("..CRAFTING_TYPE_PROVISIONING.."),eventCode -"..eventCode)
  

    --Returns: string name, textureName icon, integer stack, integer sellPrice, boolean meetsUsageRequirement, integer equipType, integer ItemType itemType, integer itemStyle, integer quality, integer ItemUISoundCategory soundCategory, integer itemInstanceId 
    
  if craftSkill == CRAFTING_TYPE_PROVISIONING then
    --d("Provisioning Craft Completed")
    
    --[[
    local numItems, penaltyApplied = GetNumLastCraftingResultItemsAndPenalty()
    local penaltyString = "false"
    if penaltyApplied then
      penaltyString = "true"
    end
    d("Last Result - "..numItems.." "..penaltyString)
    local name, icon, stack = GetLastCraftingResultItemInfo(1)
    d("LastResult - "..name.." stack - "..stack) 
    ]]--
    
    -- reduce the quantity
    --local cookEntry, masterEntry = self:GetFirstCookableEntry()
    --if cookEntry then
    local masterEntry = MRL:GetEntry(cookEntry.masterindex)
    cookEntry.quantity = cookEntry.quantity - masterEntry:GetStackCount()
    --d(masterEntry:GetRecipeName().." - New Cook Entry Quantity ["..cookEntry.quantity.."]")
    if cookEntry.quantity <= 0 then
      -- delete it and move on
      --d("-Deleting it")
      self:DeleteCookEntry(cookEntry.masterindex)
    end
    self:OnReloadRecipes(true)
    self:UpdateCookIngredients()      
    self:Craft()
  --end
  end

end

function CookeryWiz:SetCookButtonTitle(isCooking)
  if isCooking then
    self.cookButtonControl:SetText(L[CWL_BUTTON_COOK_CANCEL])
    self:SetupTooltip(self.cookButtonControl, L[CWL_BUTTON_TOOLTIP_COOK_CANCEL])  
  else
    self.cookButtonControl:SetText(L[CWL_BUTTON_COOK])
    self:SetupTooltip(self.cookButtonControl, L[CWL_BUTTON_TOOLTIP_COOK])  
  end
 
end

-- This function performs the cooking process. It will use the first item to cook that is known
-- and that we have ingredients for
function CookeryWiz:Craft()
  
  if self.cancelCooking then
    d(L[CWL_NOTIFY_COOKING_CANCELLED])
    self:ResetCooking()
    return
  end
  
  -- we can only cook if we have an open cooking fire station!
  if not self.isCookingStationOpen then
    d("Cooking Station is not open")
    return
  end
  
  -- get the first item that we can cook and have ingredients for
  -- of course there could still be entries that need cooking.. but we cannot do it
  local cookEntry, masterEntry = self:GetFirstCookableEntry()
  if not cookEntry then
    d(L[CWL_NOTIFY_NO_ITEMS_LEFT])
    return
  end

  -- flag that we are cooking
  self.currentlyCooking = cookEntry
  local notifyText = string.format(L[CWL_NOTIFY_CRAFTING], masterEntry:GetRecipeName(), cookEntry.quantity) 
  d(notifyText)
  --d("Crafting "..masterEntry:GetRecipeName().." ["..cookEntry.quantity.."]")
  CraftProvisionerItem(masterEntry:GetRecipeListIndex(), masterEntry:GetRecipeIndex())
end

function CookeryWiz:OnCookButtonClicked(control) 
  -- if we are crafting then we need to stop
  if self.currentlyCooking then
    self.cancelCooking = true
  else
    self:SetCookButtonTitle(true)
    self:Craft()
  end
end

function CookeryWiz:DumpCookIngredients()
  if self.ingredients then
    for key, ingredient in pairs(self.ingredients) do
      --d("-- Name :"..key.."["..ingredient.quantity.."]")
      trace(ingredient)
    end
  end
end

function CookeryWiz:GetIngredientEntry(name)

  for key, ingredientEntry in pairs(self.ingredients) do
    if ingredientEntry.data.name == name then
      return ingredientEntry
    end
  end  
end

function CookeryWiz:UpdateCookIngredients()

  if self.disableIngredientUpdate then
    return
  end

  local cookVars = self.savedVariables.cook
  local cook = nil
   
  local listControl = self.ingredientsScrollList
  if not listControl then
    trace("No listControl specified")
    return
  end

	local scrollData = ZO_ScrollList_GetDataList(listControl)
  self.ingredients = scrollData
	ZO_ScrollList_Clear(listControl)
	ZO_ScrollList_ResetToTop(listControl)
  
  -- next loop through and tally the total ingredients needs for each recipe
  for cookIndex, cookEntry in pairs(cookVars) do
    local masterRecipeEntry = MRL:GetEntry(cookEntry.masterindex)
    local ingredientsEntry = masterRecipeEntry:GetIngredients()
    -- It is quite possible we do not know the recipe.. hence no recipe index!
    local recipeIndex = masterRecipeEntry:GetRecipeIndex()
    local resultStack = 0
    
    if not recipeIndex then
      --d("no recipe index")
      -- we should probably be able to work it out on whether they have the skill!
      -- but since they dont know it, set to 1 as they cannot craft it
      resultStack = 1
    else
      local _, icon, stack, sellPrice, quality = GetRecipeResultItemInfo(masterRecipeEntry:GetRecipeListIndex(), recipeIndex)
      --d("Result Stack for "..masterRecipeEntry:GetRecipeName().." - ["..stack.."]")
      resultStack = stack
    end

    cookEntry.realQuantity = math.ceil(cookEntry.quantity / resultStack)
    --[[
    local remainder = math.fmod(cookEntry.quantity, resultStack)
    if remainder == 0 then
      cookEntry.realQuantity = math.floor ((cookEntry.quantity / resultStack))
    else
      cookEntry.realQuantity = math.floor ((cookEntry.quantity / resultStack)) + remainder
    end
    d(masterRecipeEntry:GetRecipeName().."Q("..cookEntry.quantity.."), S("..resultStack.."), R("..remainder.."), RQ("..cookEntry.realQuantity)
    ]]--
    --d("Count of ingredients "..#ingredientsEntry)
    for ingredientIndex = 1, #ingredientsEntry do
      local ingredient = ingredientsEntry[ingredientIndex]
      local existingEntry = self:GetIngredientEntry(ingredient.name)
      if not existingEntry then
        existingEntry = { name = ingredient.name, quantity = (cookEntry.realQuantity * ingredient.quantity), stocked = ingredient.stocked, link = ingredient.link}
        scrollData[#scrollData+1] = ZO_ScrollList_CreateDataEntry(INGREDIENT_DATA_TYPE,existingEntry)
      else
        --d("scrolldata")
        --d(existingEntry)
        --d("ingredient")
        --d(ingredient)
        existingEntry.data.stocked = ingredient.stocked
        existingEntry.data.quantity = existingEntry.data.quantity + (cookEntry.realQuantity * ingredient.quantity)
      end
    end
  end 
  --d("Total Ingredients "..#scrollData)
  local function SortNameAsc(entryA, entryB)
    return entryA.data.name < entryB.data.name
  end 
  
  table.sort(scrollData,SortNameAsc)
  ZO_ScrollList_Commit(listControl)
  
end

---------------------------------------------------------------------
-- Recipe Options Combo functions
---------------------------------------------------------------------

function CookeryWiz:OnEditLinkInitialized(control)
  self.editLinkControl = control
  self:SetupTooltip(control, L[CWL_EDIT_TOOLTIP_COPY_LINK])  
end

function CookeryWiz:OnEditLinkFocusLost(control)
  control:SetHidden(true)
end

function CookeryWiz:OnRecipeClicked(control, button)
  trace("OnRecipeClicked")
  
  local controlEntry = control.entry
  if controlEntry and controlEntry.cat then
    -- not interested in categories, only recipes
    return
  end
  
  local items = self.recipeOptionsDropdown:GetItems()
  local menuEntry = items[1]
  menuEntry.control = control
  
  local masterEntry = MRL:GetEntry(control.entry.masterindex)    
  local link = masterEntry.rid
  
  menuEntry.name = string.format(L[CWL_MENU_ITEM_COPY_LINK], link)

  self.recipeOptionsComboBox:ClearAnchors()
  self.recipeOptionsComboBox:SetAnchor(LEFTTOP, control, LEFTTOP, 10) 
  self.recipeOptionsDropdown:ShowDropdown()
end

function CookeryWiz:OnRecipeOptionsComboInitialized(control)
  
  self.recipeOptionsComboBox = control
  self.recipeOptionsDropdown = ZO_ComboBox:New(control) 
  
  local function OnItemSelect(dropDown, name, menuEntry)
    local editControl = dropDown.cookeryWiz.editLinkControl
    local masterEntry = MRL:GetEntry(menuEntry.control.entry.masterindex)
    trace("Selected "..name.."["..masterEntry.rid.."]")
    if not dropDown.cookeryWiz then
      d("no edit link control")
      return
    end
    editControl:SetText(masterEntry.rid)
    editControl:SetHidden(false)
    editControl:SelectAll() 
    editControl:TakeFocus()
  end
  
  local recipeOptions = {"Copy Link"}
  
  self.recipeOptionsDropdown:ClearItems()
  self.recipeOptionsDropdown.cookeryWiz = self
  
  -- populate from available options
  for key, recipeOptionsData in pairs(recipeOptions) do      
      local entry = self.recipeOptionsDropdown:CreateItemEntry(recipeOptionsData, OnItemSelect)
      self.recipeOptionsDropdown:AddItem(entry)
  end  
end

---------------------------------------------------------------------
-- Filter Level Combo functions
---------------------------------------------------------------------
  
function CookeryWiz:OnFilterLevelComboInitialized(control)
  self.filterLevelComboBox = control
  self.filterLevelDropdown = ZO_ComboBox:New(control)
  self:SetupTooltip(control, L[CWL_COMBO_TOOLTIP_FILTER_LEVEL]) 
  self:PopulateFilterLevelDropDown()
end

function CookeryWiz:PopulateFilterLevelDropDown()
  local cookeryWiz = self
  
  if not self.filterLevelDropdown then
    d("No filter level Dropdown")
    return
  end
  
  local function OnItemSelect(dropDown, name, menuEntry)
    -- first, if All then there is no filter
    if name == L[CWL_FILTER_ALL] then
      cookeryWiz.selectedFilterLevel = nil
    else
      -- next split on '-'
      local separator = name:find("-", 1, true)

      local selectedLevel = {}
      local lowerString = name:sub(1, separator - 1)
      local upperString = name:sub(separator + 1)
      -- is it veteran?
      if name:find("V", 1, true) == 1 then
        --d("Veteran")
        selectedLevel.veteran = true
        selectedLevel.lower = tonumber(lowerString:sub(2))
        selectedLevel.upper = tonumber(upperString)

      else
        --d("Normal")
        selectedLevel.veteran = false
        selectedLevel.lower = tonumber(lowerString)
        selectedLevel.upper = tonumber(upperString)
      end
      --d(selectedLevel)
      cookeryWiz.selectedFilterLevel = selectedLevel 
    end
    cookeryWiz:RebuildMasterRecipeScrollList(cookeryWiz.recipeScrollList)
    
  end
  
  self.filterLevelDropdown:ClearItems()
  
  -- populate from available options
  for i = 1, #filterLevelOptions do
  --for key, filterLevelData in pairs(filterLevelOptions) do      
      local filterLevelData = filterLevelOptions[i]
      local entry = self.filterDropdown:CreateItemEntry(filterLevelData, OnItemSelect)
      self.filterLevelDropdown:AddItem(entry)
  end

  self.filterLevelDropdown:SetSelectedItem(L[CWL_FILTER_ALL])
end

---------------------------------------------------------------------
-- Filter Combo functions
---------------------------------------------------------------------

function CookeryWiz:OnFilterComboInitialized(control)
  self.filterComboBox = control
  self.filterDropdown = ZO_ComboBox:New(control)
  self:SetupTooltip(control, L[CWL_COMBO_TOOLTIP_RECIPE_CATEGORY])
end


function CookeryWiz:PopulateFilterDropDown()
  local cookbook = self
  
  if not self.filterDropdown then
    d("No filter Dropdown")
    return
  end
  
  local function OnItemSelect(control, choiceText, choice)
    --d("Selected filter - "..choiceText)
    cookbook.selectedFilter = choiceText
    -- load the recipes
    cookbook:OnReloadRecipes(true)
  end
  
  self.filterDropdown:ClearItems()
      
  -- populate from available options
  for key, filterData in pairs(filterOptions) do      
      local entry = self.filterDropdown:CreateItemEntry(filterData, OnItemSelect)
      self.filterDropdown:AddItem(entry)
  end

  self.filterDropdown:SetSelectedItem(L[CWL_FILTER_ALL])
end

---------------------------------------------------------------------
-- Character Combo functions
---------------------------------------------------------------------

function CookeryWiz:PopulateCharacterDropDown()
  local cookbook = self
  
  if not self.characterDropdown then
    d("No Character Dropdown")
    return
  end
  
  local function OnItemSelect(control, choiceText, choice)
    --d("Selected character - "..choiceText)
    cookbook.selectedPlayerName = choiceText
    -- load the recipes
    cookbook:OnReloadRecipes(true)
  end
  
  self.characterDropdown:ClearItems()
      
  -- populate from our stored list. The key of the list is the character name
  for key, characterData in pairs(self.savedVariables.characters) do   
    if characterData.enabled then
      local entry = self.characterDropdown:CreateItemEntry(key, OnItemSelect)
      self.characterDropdown:AddItem(entry)
    else
      if key == self.selectedPlayerName then
        self.selectedPlayerName = nil
      end
    end
  end

  if self.selectedPlayerName then
    self.characterDropdown:SetSelectedItem(self.selectedPlayerName)
  else
    self.characterDropdown:SelectFirstItem()
  end
end


function CookeryWiz:OnCharacterComboInitialized(control)  
  self.characterComboBox = control
  self.characterDropdown = ZO_ComboBox:New(control)
  
  self:SetupTooltip(control, L[CWL_COMBO_TOOLTIP_CHARACTER])
end

function CookeryWiz:RefreshCharacterKnowledge()
  local characterName = GetUnitName("player")
  local characterVars = self.savedVariables.characters[characterName];
  --d("RefreshCharacterKnowledge - "..characterName)
  if not characterVars then
    --d("No CharacterVars Object")
    characterVars = { enabled = true, external = nil, known = {} }
  end
  
  if characterVars.enabled then
    local known = {}
    local knownCount = 0
    
    -- populate the list of known recipes
    local masterRecipeCount = MRL:GetCount()
    for i = 1, masterRecipeCount do
      local mrle = MRL:GetEntry(i)
      if mrle:IsKnown() then
        known[tostring(mrle.index)] = i
        knownCount = knownCount + 1
      end  
    end
    
    characterVars.known = known
    self.savedVariables.characters[characterName] = characterVars
  end
end



function CookeryWiz:OnOptionsButtonInitialized(control)
  self.optionsButtonControl = control
  self:SetupTooltip(control, L[CWL_BUTTON_TOOLTIP_OPTIONS])

end

function CookeryWiz:OnOptionsButtonClicked(control)
  CookeryWizOptions:HideWindow(false)
end

function CookeryWiz:OnClearOrdersButtonInitialized(control)
  self.clearOrdersButtonControl = control
  control:SetText(L[CWL_BUTTON_CLEAR_ORDERS])
  self:SetupTooltip(control, L[CWL_BUTTON_TOOLTIP_CLEAR_ORDERS]) 
end

function CookeryWiz:OnClearOrdersButtonClicked(control)
    self.savedVariables.cook = {}
    self:OnReloadRecipes(false)
    self:UpdateCookIngredients()  
end

function CookeryWiz:OnSearchContentInitialized(control)
	self.searchContentControl = control 
end

function CookeryWiz:OnEditSearchInitialized(control)
  self.searchControl = control
  control:SetText(L[CWL_FILTER_TEXT_BLANK])
  self:SetupTooltip(control, L[CWL_EDIT_TOOLTIP_SEARCH])
end

function CookeryWiz:OnEditSearchFocusLost(control)
  local text = control:GetText()
  if text == "" then
    control:SetText(L[CWL_FILTER_TEXT_BLANK])
  end 
end

function CookeryWiz:OnEditSearchFocusGained(control)
  local text = control:GetText()
  if text == L[CWL_FILTER_TEXT_BLANK] then
    control:SetText("")
  end 
end

function CookeryWiz:OnEditSearchChanged(control)
  --d(GetFormattedTime().."OnEditSearchChanged")
  local text = control:GetText()
  --control:CopyAllTextToClipboard() 
  if text == L[CWL_FILTER_TEXT_BLANK] then
    return
  end 
 
  text = string.lower(text)
  if self.filterText ~= text then
    self.filterText = text
    self:OnReloadRecipes(false)
  end  
end

function CookeryWiz:OnEditAmountInitialized(control)
  
end

function CookeryWiz:OnEditAmountChanged(control)
  local text = control:GetText()
  
  --d("OnEditAmountChanged - "..text)
  -- we want to store this amount
  local controlParent = control:GetParent()
  local controlName = controlParent:GetNamedChild("Name")
  local entry = controlName.entry
  local amount = 0
  local currentAmount = 0
  
    -- if this is not a category
  if not entry.masterindex then
    return
  end
  -- avoid doing this if already the same
  if entry.cook then
    currentAmount = entry.cook.quantity
  end
  
  -- if we have a quantity check that it is numeric
  amount = tonumber(text)
  
  if currentAmount == amount then
    --d("currentamount("..currentAmount..") equals amount("..amount..") so exiting")
    return
  end
    
  if text ~= "" then
    --d("text = "..text)
    if not amount then
      -- it is not, so we set it back to the previous value
      if not entry.cook then
        text = ""
      elseif entry.cook.quantity == 0 then
        text = ""
      else
        text = entry.cook.quantity
      end
      --d("Setting to "..text)
      control:SetText(text)
      return
    end
  else
    -- we should delete this entry?
    --d("text is blank")
    amount = 0   
  end
  
  -- we should delete this entry?
  if amount == 0 then

    local masterEntry = MRL:GetEntry(entry.masterindex)
    --d("Deleting "..masterEntry.rid)
    
    self:DeleteCookEntry(entry.masterindex)
    entry.cook = nil
  else
    if not entry.cook then
      entry.cook = self:CreateCookEntry(entry.masterindex, amount, "test")
    else
      --d("updating to "..amount)
      entry.cook.quantity = amount     
    end
  end
  self:UpdateCookIngredients()
end


function CookeryWiz:ExtractQuestItems(conditionText)
    local craftItem = nil

    local conditionTextLower = conditionText:lower()
    
    --d("ExtractQuestItems '"..conditionTextLower.."'")
    --d("Find '"..self.provisionWritStartTextLower.."'")
    local startIndex = self.provisionWritStartTextLower:len() + 2
    if conditionTextLower:find(self.provisionWritStartTextLower) == 1 then
      local colonIndex = conditionText:find(":")
      craftItem = conditionText:sub(startIndex, colonIndex - 1)
    else
      --d("did not find text")
    end
    return craftItem
end

function CookeryWiz:DeleteCookEntry(masterRecipeIndex)
  if not self.savedVariables.cook then
    self.savedVariables.cook = {}
  end
  local cookVars = self.savedVariables.cook
  local foundIndex
  
  for cookIndex, cookEntry in pairs(cookVars) do
    if cookEntry.masterindex == masterRecipeIndex then
      --d("Matched recipe. Cook index "..cookIndex)
      foundIndex = cookIndex
      break
    end
  end 
  
  if foundIndex then
    --d("Found index and deleting")
    cookVars[foundIndex] = nil
  end
 
end

function CookeryWiz:CreateCookEntry(masterRecipeIndex, entryQuantity, entryTag)
  
  --determine ingredient requirements  
  if not self.savedVariables.cook then
    self.savedVariables.cook = {}
  end
  
  local cook = self.savedVariables.cook  
  local entry = nil
  
  if entryQuantity ~= 0 then
    entry = self:GetCookEntry(masterRecipeIndex)
    if not entry then
      entry = { masterindex = masterRecipeIndex, quantity = entryQuantity, tag = entryTag }
      cook[#cook + 1] = entry
    end
  end
  return entry
end



function CookeryWiz:AddItemEntryToCraft(masterEntry, quantity, tag)
  
  if not self.savedVariables.cook then
    self.savedVariables.cook = {}
  end
  
  local cookVars = self.savedVariables.cook
  local cook = self:GetCookEntry(masterEntry:GetIndex())
  
  -- add extra stuff to it, like quantity of items that need to be cooked!
  --[[
  for _, cookEntry in pairs(cookVars) do
    -- Each cookEntry looks like this { index = <index into masterrecipelist>, quantity = <quantity to cook>, tag = < a tag of some sort> }
    if cookEntry.masterindex == masterEntry:GetIndex() then
      --d("Matched recipe")
      cook = cookEntry
      break
    end
  end
  ]]--
  if not cook then
    --d("AddItemEntryToCraft - no cook "..quantity.."'")
    cook = self:CreateCookEntry(masterEntry:GetIndex(), quantity, tag)
  else     
    local amount = cook.quantity
    if not amount or amount == "" then
      amount = 0
    end
    --d("AddItemEntryToCraft - entry "..amount + quantity.."'")
    cook.quantity = amount + quantity
    if cook.tag then
      cook.tag = cook.tag..", "..tag     
    else    
      cook.tag = tag
    end
  end
  d("CookeryWiz Adding Writ Food - "..masterEntry:GetFoodResultName())
  self:UpdateCookIngredients()
end

function CookeryWiz:AddItemNameToCraft(foodName, quantity, tag)
  
  local masterEntry = MRL:GetEntryByFoodName(foodName)
  if masterEntry then
    --d("Found food to craft "..foodName)
    return self:AddItemEntryToCraft(masterEntry, quantity, tag)
  end
  
  
  --[[
  local itemNameLower = itemName:lower()
  --d("looking for '"..itemNameLower.."'")
  for key, entry in pairs(self.masterRecipeList) do
    local foodName = GetItemLinkName(entry.fid):lower()
    --d("entry '"..foodName.."'")
    if foodName == itemNameLower then
      --d("Found '"..itemNameLower.."'")
      return self:AddItemEntryToCraft(key, entry, quantity, tag)
    end
  end
  ]]--
end

function CookeryWiz.OnQuestAdded(eventCode, journalIndex, questName, objectiveName)
  self = CookeryWiz
  
  --d("Quest - '"..questName.."' Added")
  
  -- Only interested in crafting writ
  if questName ~= L[CWL_QUEST_PROVISIONER_WRIT_TITLE] then
    --d("Quest - '"..questName.."' does not equal '"..self.provisionWritText.."'")
    return
  end

  --d("journalIndex-"..journalIndex)
  --d("objectiveName-"..objectiveName)
  local qname, backgroundText, activeStepText, activeStepType, activeStepTrackerOverrideText, completed, tracked, qlevel, pushed, qtype = GetJournalQuestInfo(journalIndex)
  --d("activeStepText '"..activeStepText.."'")
  --d("activeStepTrackerOverrideText '"..activeStepTrackerOverrideText.."'")
  local stepCount = GetJournalQuestNumSteps(i)
  local updatedCookCount = false
  
  for stepIndex=1, stepCount do
    local qstep, visibility, stepType, trackerOverrideText, numConditions = GetJournalQuestStepInfo(journalIndex,stepIndex)
    if qstep and qstep ~= "" then
      --d(stepIndex..": qstep '"..qstep.."'")
      --d(stepIndex..": trackerOverrideText '"..trackerOverrideText.."'")
      --d(stepIndex..": numConditions '"..numConditions.."'")
      for conditionIndex=1, numConditions do
        local conditionText, currentval, maxval, isFailCondition, _, isCreditShared = GetJournalQuestConditionInfo(journalIndex, stepIndex, conditionIndex)
        --d(conditionIndex..": conditionText '"..conditionText.."'")
        --d(conditionIndex..": currentval '"..currentval.."'")
        --d(conditionIndex..": maxval '"..maxval.."'")
        -- now match item to be crafted
        local craftItem = self:ExtractQuestItems(conditionText)
        if craftItem then
          -- if we have items to create
          local craftItemQuantity = maxval - currentval
          --d("Found Craft Item - '"..craftItem.."' cook quantity "..craftItemQuantity)
          if craftItemQuantity > 0 then
            -- resolve item to craft
            self:AddItemNameToCraft(craftItem, craftItemQuantity, GetUnitName("player"))
            updatedCookCount = true
          end
        end
      end
    end
  end

  if updatedCookCount then
    self:OnReloadRecipes(true)
  end
  --EVENT_QUEST_ADDED (integer eventCode, integer journalIndex, string questName, string objectiveName)  
end

function CookeryWiz.OnRecipeLearned(eventCode, recipeListIndex, recipeIndex)
  self = CookeryWiz
  self:RefreshCharacterKnowledge()
end

function CookeryWiz:QualityChanged(currentQuality)
  --d("quality changed "..self.name)
  self.currentQuality = currentQuality
  self:OnReloadRecipes(false)
end

local function isProvisioningOrDestroyedItem(bagId,slotId,isNewItem)
	local craftType = GetItemCraftingInfo(bagId,slotId)
	return craftType == CRAFTING_TYPE_PROVISIONING or (isNewItem == false and craftType == CRAFTING_TYPE_INVALID)
end

function CookeryWiz.OnInventorySingleSlotUpdate(eventCode,bagId, slotId, isNewItem, itemSoundCategory, updateReason)
	if (bagId == BAG_WORN or bagId == BAG_BACKPACK) and updateReason == INVENTORY_UPDATE_REASON_DEFAULT and isProvisioningOrDestroyedItem(bagId,slotId,isNewItem) == true then

		self = CookeryWiz
		self:UpdateCookIngredients() 
		
	end
end

function CookeryWiz:RegisterSlashCommands()
  local cookeryWiz = self
  
  --chat command handlers
  local function command_handler(arg)
      --d("command_handler")
      arg = string.lower(arg)
      if(arg == "" or arg == nil or #arg == 0 or arg==L[CWL_CHAT_OPTION_TOGGLE]) then
        --Use your toggle function here or maybe this wil work too
        cookeryWiz:ToggleWindow()
      elseif arg==L[CWL_CHAT_OPTION_SHOW] then
        cookeryWiz.ui:SetHidden(false)
      elseif arg==L[CWL_CHAT_OPTION_HIDE] then
        cookeryWiz.ui:SetHidden(true)
      end
  end
     
     
  SLASH_COMMANDS["/cw"]           = command_handler
  SLASH_COMMANDS["/cookerywiz"]   = command_handler
end

function CookeryWiz:Initialize()
  
	local defaultSave =
	{
    collapsed = {},
    characters = {},
    cook = {},
    easyFrameVariables = self.easyFrameVariables
	}

  self.savedVariables = ZO_SavedVars:NewAccountWide("CookeryWizSavedVariables", 1, nil, defaultSave)  

  self.easyFrameVariables = self.savedVariables.easyFrameVariables

  if not self.savedVariables.collapsed then
    self.savedVariables.collapsed = {}
  end
  
  -- Configure strings
  self.closeTooltip = L[CWL_BUTTON_TOOLTIP_CLOSE]
  self.reloadTooltip = L[CWL_BUTTON_TOOLTIP_RELOAD]
  self.expandTooltip = L[CWL_BUTTON_TOOLTIP_EXPAND]
  self.shrinkTooltip = L[CWL_BUTTON_TOOLTIP_SHRINK]

  self.selectedPlayerName = GetUnitName("player")
  self:InitializeEasyFrame(L[CWL_COOKERYWIZ_TITLE], CookeryWizUI) 

  CookeryWizMailer:Initialize()
  CookeryWizQualitySelector:Initialize(self, self.QualityChanged)
  self.currentQuality = CookeryWizQualitySelector:GetSelectedQuality()
  
  -- reset the knowledge for this character
  local characterVars = self.savedVariables.characters[self.selectedPlayerName]
  if characterVars then
    characterVars.known = {}
  else
    self.savedVariables.characters[self.selectedPlayerName] = { enabled = true, known = {} }
  end  
  
  self:PopulateCharacterDropDown()
  self:PopulateFilterDropDown()
  
  -- load the recipes
  self:OnReloadRecipes(true)
  self:UpdateCookIngredients()
  
 
  -- Register slash commands
  self:RegisterSlashCommands()
  
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_CRAFTING_STATION_INTERACT, CookeryWiz.OnCraftingStationInteract)
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_END_CRAFTING_STATION_INTERACT, CookeryWiz.OnEndCraftingStationInteract)
 
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_MAIL_OPEN_MAILBOX, CookeryWiz.OnOpenMailBox)
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_MAIL_CLOSE_MAILBOX, CookeryWiz.OnCloseMailBox)
  
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_MAIL_SEND_FAILED, CookeryWiz.OnMailSendFailed) 
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_MAIL_SEND_SUCCESS, CookeryWiz.OnMailSendSuccess)
  
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_MAIL_READABLE, CookeryWiz.OnMailReadable)
  
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_MAIL_REMOVED, CookeryWiz.OnMailRemoved)
   
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_QUEST_ADDED, CookeryWiz.OnQuestAdded)
  
  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_RECIPE_LEARNED, CookeryWiz.OnRecipeLearned)

  EVENT_MANAGER:RegisterForEvent(CookeryWiz.name,EVENT_INVENTORY_SINGLE_SLOT_UPDATE,CookeryWiz.OnInventorySingleSlotUpdate)
end

function CookeryWiz.OnAddOnLoaded(event, addonName)
  if addonName == CookeryWiz.name then
    CookeryWiz:Initialize()
    EVENT_MANAGER:UnregisterForEvent(CookeryWiz.name, EVENT_ADD_ON_LOADED)
  end
end

EVENT_MANAGER:RegisterForEvent(CookeryWiz.name, EVENT_ADD_ON_LOADED, CookeryWiz.OnAddOnLoaded)


