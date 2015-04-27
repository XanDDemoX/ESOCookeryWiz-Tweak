
local L = CookeryWizLanguage.language

CookeryWizMailer = EasyFrame:new()
CookeryWizMailer.name = "CookeryWizMailer"
CookeryWizMailer.isInitialised = false

CookeryWizMailer.cookeryWiz = nil
CookeryWizMailer.editAddressControl = nil

CookeryWizMailer.characterComboBox = nil
CookeryWizMailer.characterDropdown = nil
  
CookeryWizMailer.contentControl = nil

CookeryWizMailer.statusLabelControl = nil

CookeryWizMailer.selectedCharacter = nil
CookeryWizMailer.sendingRecipes = false

CookeryWizMailer.traceEnabled = false

local function trace(msg)
  CookeryWizMailer:Trace(msg)
end

---------------------------------------------------------------------
-- EasyFrame virtual functions
---------------------------------------------------------------------

function CookeryWizMailer:OnHideWindow(isHidden)
  local ui = self.ui

  if not isHidden then
    --d("Showing")
    local mailerWidth = ui:GetWidth()
    local mailerHeight = ui:GetHeight()
    if self.statusLabelControl then
      self.statusLabelControl:SetText("")
    end
    self.ui:SetAnchor(TOPLEFT, self.parentWindow, TOPLEFT, (mailerWidth/2), (mailerHeight/2))    
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_MAIL_SEND_FAILED, self.OnMailSendFailed)
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_MAIL_SEND_SUCCESS, self.OnMailSendSuccess)
  else
    --d("Hiding")
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_MAIL_SEND_FAILED)
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_MAIL_SEND_SUCCESS) 
  end  
end

function CookeryWizMailer:OnMailShow(topLevelControl)
  --d("OnShowCookeryWizMailer")
  --self:OnReloadRecipes(true)
  --d("Populating characters")
  self:PopulateCharacterDropDown()
end

-- Use this function to hide and show controls according to whether we are shrunk or expanded
function CookeryWizMailer:OnShrink(isHidden)
  if not self then
    d("OnShrink called without :")
    return
  end
   
  local vars = self.easyFrameVariables
  local isShrunk = vars.isShrunk
  
  if isShrunk then
    -- hide controls

  else
    -- show controls

  end

  self.contentControl:SetHidden(isShrunk)
end

function CookeryWizMailer:PopulateCharacterDropDown()
  local cookeryWizMailer = self
  
  if not self.characterDropdown then
    d("No Character Dropdown")
    return
  end
  
  local function OnItemSelect(control, choiceText, choice)
    cookeryWizMailer.selectedCharacter = choiceText
  end
  
  self.characterDropdown:ClearItems()
      
  -- populate from our stored list. The key of the list is the character name
  for key, characterData in pairs(CookeryWiz.savedVariables.characters) do
    if characterData.enabled then
      -- skip external characters 
      if not key:find("@", 1, true) then
        local entry = self.characterDropdown:CreateItemEntry(key, OnItemSelect)
        self.characterDropdown:AddItem(entry)
      end
    end    
  end

  self.characterDropdown:SetSelectedItem(self.selectedCharacter)
end

function CookeryWizMailer:OnStatusLabelInitialized(control)
  self.statusLabelControl = control
  self.statusLabelControl:SetText("")
end

function CookeryWizMailer:OnDescriptionLabelInitialized(control)
  --self.statusLabelControl = control
  control:SetText(L[CWL_LABEL_MAILER_DESCRIPTION_TEXT])
end

function CookeryWizMailer:OnCharacterLabelInitialized(control)
  --self.statusLabelControl = control
  control:SetText(L[CWL_LABEL_MAILER_CHARACTER_TEXT])
end

function CookeryWizMailer:OnAddressLabelInitialized(control)
  --self.statusLabelControl = control
  control:SetText(L[CWL_LABEL_MAILER_ADDRESS_TEXT])
end


function CookeryWizMailer:OnCharacterComboInitialized(control)  
  self.characterComboBox = control
  self.characterDropdown = ZO_ComboBox:New(control)
end

function CookeryWizMailer:OnContentInitialized(control)
  self.contentControl = control
end

function CookeryWizMailer:OnEditAddressInitialized(control)
  self.editAddressControl = control
  control:SetText(L[CWL_EDIT_MAILER_ADDRESS_BLANK_TEXT])
end

function CookeryWizMailer:OnEditAddressFocusLost(control)
  local text = control:GetText()
  if text == "" then
    control:SetText(L[CWL_EDIT_MAILER_ADDRESS_BLANK_TEXT])
  end 
end

function CookeryWizMailer:OnEditAddressFocusGained(control)
  local text = control:GetText()
  if text == L[CWL_EDIT_MAILER_ADDRESS_BLANK_TEXT] then
    control:SetText("")
  end 
end

function CookeryWizMailer:OnEditAddressChanged(control)

  local text = control:GetText()
  
  if text == L[CWL_EDIT_MAILER_ADDRESS_BLANK_TEXT] then
    return
  end 

end



function CookeryWizMailer:OnSendButtonInitialized(control)
  control:SetText(L[CWL_BUTTON_MAILER_SENDMAIL])
  self:SetupTooltip(control, L[CWL_BUTTON_MAILER_TOOLTIP_SENDMAIL])
end

function CookeryWizMailer:OnSendButtonClicked(control) 

  local address = self.editAddressControl:GetText()

  if not address or address == "" or address == L[CWL_EDIT_MAILER_ADDRESS_BLANK_TEXT] then
    d(L[CWL_NOTIFY_BLANK_ADDRESS])
    return
  end
  
  if not self.selectedCharacter or self.selectedCharacter == "" then
    d("No character selected")
    return    
  end
  -- mail them
  self.sendingRecipes = true
  self.cookeryWiz:EnableScanning(false)
  self.cookeryWiz:SendKnownRecipes(self.selectedCharacter, address)
  
end
  
function CookeryWizMailer.OnMailSendFailed(eventCode, reason)
  local self = CookeryWizMailer
  trace("OnMailSendFailed "..eventCode..", reason "..reason)
  if self.sendingRecipes then
    self.sendingRecipes = false
    self.cookeryWiz:EnableScanning(true)
    self.statusLabelControl:SetText(L[CWL_LABEL_MAILER_SENT_FAILED])
  end
end

function CookeryWizMailer.OnMailSendSuccess(eventCode)
  trace("OnMailSendSuccess ["..eventCode.."]") 
  local self = CookeryWizMailer
  if self.sendingRecipes then
    self.sendingRecipes = false  
    self.cookeryWiz:EnableScanning(true)
    self.statusLabelControl:SetText(L[CWL_LABEL_MAILER_SENT_SUCCESS])
  end
end



function CookeryWizMailer:ToggleShow(parentWindow)
  if not self.isInitialised then
    d("Not initialised")
    return
  end
  self.parentWindow = parentWindow
  local ui = self.ui
  local isHidden = self.ui:IsHidden()
  self:HideWindow(not isHidden)  
end

function CookeryWizMailer:Initialize()
  self.cookeryWiz = CookeryWiz
	local defaultSave =
	{
    easyFrameVariables = self.easyFrameVariables
	} 
  
  self.easyFrameVariables.width = CookeryWizMailerUI:GetWidth()
  self.easyFrameVariables.height = CookeryWizMailerUI:GetHeight()
  self.easyFrameVariables.widthMin = self.easyFrameVariables.width
  self.easyFrameVariables.heightMin = self.easyFrameVariables.height
  self.easyFrameVariables.isHidden = true

  self.isInitialised = true
  self:InitializeEasyFrame(L[CWL_COOKERYWIZMAILER_TITLE], CookeryWizMailerUI)
  
  self.ui:SetResizeHandleSize(0)
  
  self.selectedCharacter = GetUnitName("player")
  self.reloadButton:SetHidden(true)
  self.shrinkButton:SetHidden(true)
  
    -- Configure strings
  self.closeTooltip = L[CWL_BUTTON_TOOLTIP_CLOSE]
end

function CookeryWizMailer.OnAddOnLoaded(event, addonName)
  local self = CookeryWizMailer
  if addonName == self.name then
    self:Initialize()
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)
  end
end

EVENT_MANAGER:RegisterForEvent(CookeryWizMailer.name, EVENT_ADD_ON_LOADED, CookeryWizMailer.OnAddOnLoaded)
