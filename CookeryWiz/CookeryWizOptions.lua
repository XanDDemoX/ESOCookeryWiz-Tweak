
local L = CookeryWizLanguage.language

CookeryWizOptions = EasyFrame:new()
CookeryWizOptions.name = "CookeryWizOptions"
CookeryWizOptions.cookeryWiz = nil

CookeryWizOptions.contentControl = nil

CookeryWizOptions.characterComboBox = nil
CookeryWizOptions.characterDropdown = nil
CookeryWizOptions.externalCharacterComboBox = nil
CookeryWizOptions.externalCharacterDropdown = nil
CookeryWizOptions.characterEnabledButton = nil

CookeryWizOptions.disableShrinkCheckButton = nil

function CookeryWizOptions:OnCookeryWizOptionsInitialized(control) 
  self:Initialize()
end

function CookeryWizOptions:OnGeneralOptionsLabelInitialized(control)
  control:SetText(L[CWL_LABEL_OPTIONS_GENERAL_OPTIONS_TEXT])
  control:SetColor(255,255,255)
end

function CookeryWizOptions:OnAccountOptionsLabelInitialized(control)
  control:SetText(L[CWL_LABEL_OPTIONS_ACCOUNT_OPTIONSL_TEXT ])
  control:SetColor(255,255,255)
end

function CookeryWizOptions:OnExternalOptionsLabelInitialized(control)
  control:SetText(L[CWL_LABEL_OPTIONS_IMPORTED_OPTIONS_TEXT ])
  control:SetColor(255,255,255)  
end

function CookeryWizOptions:OnDisableShrinkLabelInitialized(control)
  control:SetText(L[CWL_LABEL_OPTIONS_DISABLE_SHRINK_TEXT])
  self:SetupTooltip(control, L[CWL_BUTTON_OPTIONS_DISABLE_SHRINK_TOOLTIP])
  
end

function CookeryWizOptions:OnDisableShrinkCheckButtonInitialized(control)
  self.disableShrinkCheckButton = control
end

function CookeryWizOptions:OnDisableShrinkCheckButtonClicked(control, mouseButton)
  local savedVars = self.cookeryWiz.savedVariables
  if not savedVars then
    return
  end
  local shrinkDisabled = self.cookeryWiz:IsShrinkDisabled()
  self.cookeryWiz:DisableShrink(not shrinkDisabled)
  ZO_CheckButton_OnClicked(control, mouseButton)
end

function CookeryWizOptions:OnCharacterLabelInitialized(control)
    control:SetText(L[CWL_LABEL_OPTIONS_ACCOUNT_CHARACTER_TEXT])
end

function CookeryWizOptions:OnContentControlInitialized(control)
  self.contentControl = control
end

function CookeryWizOptions:OnCharacterDisabledButtonClicked(control)
  
  --local characterName = ZO_ComboBox:GetSelectedItem(self.characterComboBox)
  local characterName = self.characterDropdown:GetSelectedItem()
  
  local characterVars = self.cookeryWiz.savedVariables.characters[characterName];
  if not characterVars then
    return
  end

  characterVars.enabled = not characterVars.enabled
  self:ConfigureDisabledButton(characterVars)
  self.cookeryWiz:PopulateCharacterDropDown()
end

function CookeryWizOptions:ConfigureDisabledButton(characterVars)
   if characterVars.enabled then
    self.characterEnabledButton:SetText(L[CWL_BUTTON_OPTIONS_DISABLE])
    self:SetupTooltip(self.characterEnabledButton, string.format(L[CWL_BUTTON_OPTIONS_DISABLE_TOOLTIP], L[CWL_COOKERYWIZ_TITLE]))      
  else
    self.characterEnabledButton:SetText(L[CWL_BUTTON_OPTIONS_ENABLE])
    self:SetupTooltip(self.characterEnabledButton, string.format(L[CWL_BUTTON_OPTIONS_ENABLE_TOOLTIP], L[CWL_COOKERYWIZ_TITLE]))       
  end 
end

function CookeryWizOptions:OnCharacterSelected(control, choiceText, choice)
  local characterVars = self.cookeryWiz.savedVariables.characters[choiceText];
  if not characterVars then
    return
  end
  
  if control.m_name == self.characterComboBox:GetName() then
    --d("Character")
    self:ConfigureDisabledButton(characterVars)
  elseif control.m_name == self.externalCharacterComboBox:GetName() then
    --d("External")
  end

end

function CookeryWizOptions:OnCharacterComboInitialized(control)
  self.characterComboBox = control
  self.characterDropdown = ZO_ComboBox:New(control)

end

function CookeryWizOptions:OnCharacterDisabledButtonInitialized(control)
  self.characterEnabledButton = control
  control:SetText(L[CWL_BUTTON_OPTIONS_DISABLE])
  self:SetupTooltip(control, string.format(L[CWL_BUTTON_OPTIONS_DISABLE_TOOLTIP], L[CWL_COOKERYWIZ_TITLE]))
end


-- External
function CookeryWizOptions:OnImportedCharacterLabelInitialized(control)
  control:SetText(L[CWL_LABEL_OPTIONS_IMPORTED_CHARACTER_TEXT])
end

function CookeryWizOptions:OnImportedCharacterComboInitialized(control)
  self.externalCharacterComboBox = control
  self.externalCharacterDropdown = ZO_ComboBox:New(control)
end

function CookeryWizOptions:OnDeleteExternalCharacterButtonInitialized(control)
  control:SetText(L[CWL_BUTTON_OPTIONS_DELETE])
  self:SetupTooltip(control, L[CWL_BUTTON_OPTIONS_DELETE_TOOLTIP])
end

function CookeryWizOptions:OnDeleteExternalCharacterButtonClicked(control)
  local characterName = self.externalCharacterDropdown:GetSelectedItem()
  local characterVars = self.cookeryWiz.savedVariables.characters[characterName];
  if not characterVars then
    return
  end
  self.cookeryWiz.savedVariables.characters[characterName] = nil
  self.cookeryWiz:PopulateCharacterDropDown()
  self:PopulateCharacterDropDown(self.externalCharacterDropdown, true)
  self.externalCharacterDropdown:SelectFirstItem()
end

function CookeryWizOptions:PopulateCharacterDropDown(characterDropdown, isExternal)
  local cookeryWizOptions = self
  
  if not characterDropdown then
    d("No Character Dropdown")
    return
  end
  
  local function OnItemSelect(comboBox, name, entry)
    self:OnCharacterSelected(comboBox, name, entry)
  end
  
  characterDropdown:ClearItems()
      
  -- populate from our stored list. The key of the list is the character name
  for key, characterData in pairs(CookeryWiz.savedVariables.characters) do
    -- skip external characters 
    local foundAt = key:find("@", 1, true)
    if isExternal then
      --d(key)
      if foundAt then
        local entry = self.characterDropdown:CreateItemEntry(key, OnItemSelect)
        characterDropdown:AddItem(entry)          
      end        
    else 
      if not foundAt then
        local entry = self.characterDropdown:CreateItemEntry(key, OnItemSelect)
        characterDropdown:AddItem(entry)
      end
    end

  end
end
---------------------------------------------------------------------
-- EasyFrame virtual functions
---------------------------------------------------------------------

function CookeryWizOptions:OnHideWindow(isHidden)
  --d("CookeryWizOptions:OnHideWindow")
 
  local ui = self.ui
  if isHidden then
    --d("Hiding")
  else
    --d("Showing")
    local characterName = GetUnitName("player")
    self:PopulateCharacterDropDown(self.characterDropdown, false)    
    self.characterDropdown:SetSelectedItem(characterName)    
    
    self:PopulateCharacterDropDown(self.externalCharacterDropdown, true)
    self.externalCharacterDropdown:SelectFirstItem()
    
    local characterVars = self.cookeryWiz.savedVariables.characters[characterName];
    if characterVars then
      self:ConfigureDisabledButton(characterVars)      
    end
    
    self:CenterToParent()
    ui:BringWindowToTop()
    
    if self.statusLabelControl then
      self.statusLabelControl:SetText("")
    end   

    -- set the check
    local shrinkDisabled = self.cookeryWiz:IsShrinkDisabled()
    if shrinkDisabled then
        ZO_CheckButton_SetChecked(self.disableShrinkCheckButton)
    else
        ZO_CheckButton_SetUnchecked(self.disableShrinkCheckButton)
    end
    
  end  
end


function CookeryWizOptions:Initialize()
  self.cookeryWiz = CookeryWiz
	local defaultSave =
	{    
    easyFrameVariables = self.easyFrameVariables
	} 
  
  self.easyFrameVariables.width = CookeryWizOptionsUI:GetWidth()
  self.easyFrameVariables.height = CookeryWizOptionsUI:GetHeight()
  self.easyFrameVariables.widthMin = self.easyFrameVariables.width
  self.easyFrameVariables.heightMin = self.easyFrameVariables.height
  self.easyFrameVariables.isHidden = true

  self.isInitialised = true
  self:InitializeEasyFrame(L[CWL_COOKERYWIZOPTIONS_TITLE], CookeryWizOptionsUI, CookeryWizUI)
  
  self.ui:SetResizeHandleSize(0)
  
  self.selectedCharacter = GetUnitName("player")
  self.reloadButton:SetHidden(true)
  self.shrinkButton:SetHidden(true)
  
    -- Configure strings
  self.closeTooltip = L[CWL_BUTTON_TOOLTIP_CLOSE] 

end


