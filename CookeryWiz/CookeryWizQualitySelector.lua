local QUALITY_DATA_TYPE = 3

local L = CookeryWizLanguage.language

-- purple, blue, green
local qualityTable = {
  {nil, nil, ITEM_QUALITY_MAGIC},
  {nil, ITEM_QUALITY_ARCANE, ITEM_QUALITY_MAGIC},
  {ITEM_QUALITY_ARTIFACT, ITEM_QUALITY_ARCANE, ITEM_QUALITY_MAGIC},
  {nil, nil, ITEM_QUALITY_ARCANE},
  {nil, ITEM_QUALITY_ARTIFACT, ITEM_QUALITY_ARCANE},
  {nil, nil, ITEM_QUALITY_ARTIFACT},  
}

CookeryWizQualitySelector = EasyFrame:new()
CookeryWizQualitySelector.name = "CookeryWizQualitySelector"
CookeryWizQualitySelector.dialogCaption = "Quality"
CookeryWizQualitySelector.qualityScrollControl = nil

CookeryWizQualitySelector.traceEnabled = false

CookeryWizQualitySelector.sourceQuality = nil

CookeryWizQualitySelector.qualityDownButtonControl  = nil
CookeryWizQualitySelector.selectedQualityControl = nil
CookeryWizQualitySelector.ui = nil
CookeryWizQualitySelector.contentControl = nil

CookeryWizQualitySelector.changeQualityObject = nil
CookeryWizQualitySelector.changeQualityFunction = nil

CookeryWizQualitySelector.captureEnabled = false
CookeryWizQualitySelector.countDownResetAmount = 4
CookeryWizQualitySelector.countDown = 4

local function trace(msg)
  CookeryWizQualitySelector:Trace(msg)
end

function CookeryWizQualitySelector:OnSelectedQualityButtonInitialized(control)
  self.selectedQualityControl = control
  self.contentControl = control:GetParent()
  local data = qualityTable[3]
  self:PopulateQualityRow(self.selectedQualityControl, data)
  self:LinkSourceRow(self.selectedQualityControl)
  self:SetSelectedQuality(data) 
  
  local wizSelector = self

  self.selectedQualityControl:SetHandler("OnMouseEnter", function(self)
      local selectedData = wizSelector:GetSelectedQuality()
      local string = wizSelector:GetQualityText(selectedData)
      ZO_Tooltips_ShowTextTooltip(self, TOP, string)      
    end)
  self.selectedQualityControl:SetHandler("OnMouseExit", function(self)
        ZO_Tooltips_HideTextTooltip() 
    end)  

end


function CookeryWizQualitySelector:OnQualityDownButtonInitialized(control)
  self.qualityDownButtonControl = control  
  self:SetupTooltip(control, L[CWL_BUTTON_TOOLTIP_QUALITY_FILTER])   
  
  if true then
   return
  end
  self.qualityDownButtonControl = control
  self.contentControl = control:GetParent()
  self.selectedQualityControl =  WINDOW_MANAGER:CreateControlFromVirtual(self.contentControl:GetName().."SelectedQuality", control, "QualityRowTemplate")  
  self.selectedQualityControl:SetAnchor(BOTTOMRIGHT, control, BOTTOMLEFT, -6, 3)
  self.selectedQualityControl:SetMouseEnabled(true)
	--self.selectedQualityControl:SetEdgeTexture("EsoUI\\Art\\Tooltips\\UI-Border.dds", 128, 16)
	--bg:SetCenterTexture("EsoUI\\Art\\Tooltips\\UI-TooltipCenter.dds")
	--bg:SetInsets(8, 8, -8, -8)  


  local bg = WINDOW_MANAGER:CreateControlFromVirtual(self.selectedQualityControl:GetName().."BG", self.selectedQualityControl, "ZO_DefaultBackdrop")
  bg:ClearAnchors()
  bg:SetDimensions( 82 , 30 )
	bg:SetAnchor(BOTTOMRIGHT, control, BOTTOMLEFT, -2, 4)
	--bg:SetAnchor(BOTTOMRIGHT, control, BOTTOMLEFT, 3, 3)
  
  -- add tooltip handling
  --self:SetupTooltip(self.selectedQualityControl, L[CWL_BUTTON_TOOLTIP_QUALITY_FILTER])
  
  --ZO_PreHookHandler(self.selectedQualityControl, "OnMouseEnter", function() d("MMM") end)  
  --[[
  self.selectedQualityControl:SetHandler("OnMouseEnter", function(self)
      d("MMM")
      ZO_Tooltips_ShowTextTooltip(self, TOP, L[CWL_BUTTON_TOOLTIP_QUALITY_FILTER])
      
    end)
  self.selectedQualityControl:SetHandler("OnMouseExit", function(self)
        ZO_Tooltips_HideTextTooltip() 
    end)
  
   
  ]]--
  --[[
  	label:SetMouseEnabled(true)
	if submenuData.tooltip then
		label.data = {tooltipText = submenuData.tooltip}
		label:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
		label:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
	end
  ]]--
end

function CookeryWizQualitySelector:OnShow(control)
  --d("OnShow")
  self.captureEnabled = true
  self.countDown = self.countDownResetAmount
  self.CaptureTimeEvent()
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ACTION_LAYER_POPPED, CookeryWizQualitySelector.ActionLayer)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ACTION_LAYER_PUSHED, CookeryWizQualitySelector.ActionLayer)
end

function CookeryWizQualitySelector:OnHide(control)
  --d("OnHide")
  self.captureEnabled = false
  EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ACTION_LAYER_POPPED)
  EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ACTION_LAYER_PUSHED)
end

function CookeryWizQualitySelector.CaptureTimeEvent()
  local self = CookeryWizQualitySelector
  if self.captureEnabled then

    local control = moc()
    local controlName = "unknown"
    local controlParent
    local controlParentName = "unknown"
    
    if control then
      controlName = control:GetName()
      controlParent = control:GetParent()
      if controlParent then
        controlParentName = controlParent:GetName()
      end
    end
    --d(GetTimeString().."Capturing "..controlName .. " ["..controlParentName.."]")
    -- if this is the countdown button contrnt..downbutton
    local currentNameMatch = self.contentControl:GetName()..controlName
    if currentNameMatch == self.contentControl:GetName()..self.qualityDownButtonControl:GetName() then
      --d("Reset countdown")
      self.countDown =  self.countDownResetAmount
    end
    if controlParentName:find(self.ui:GetName()) == 1 then
      --d("Reset countdown")
      self.countDown = self.countDownResetAmount   
    end
    if self.countDown == 0 then
      self.ui:SetHidden(true)
    else
      zo_callLater(self.CaptureTimeEvent, 500)
      self.countDown = self.countDown -1 
    end
  end
end


function CookeryWizQualitySelector:OnQualityDownButtonClicked(control)
  local ui = self.ui
  local isHidden = ui:IsHidden()
  if isHidden then
    -- position it
    ui:ClearAnchors()
    ui:SetAnchor(TOPRIGHT, control, BOTTOMRIGHT, -5, 12)
    ui:BringWindowToTop()
  end
  ui:SetHidden(not isHidden)

end

function CookeryWizQualitySelector.ActionLayer(eventCode, layerIndex, activeLayerIndex)
  --d("Action layer changed")
  CookeryWizQualitySelector.ui:SetHidden(true)
end

function CookeryWizQualitySelector:OnQualityTooltipInitialized(control)
  if not control then
    trace("Control is nil")
    return
  end
  control:SetParent(PopupTooltipTopLevel)
end


function CookeryWizQualitySelector:GetQualityText(data)
  if not data then
    trace("No data item associated with quality. None selected?")
    return ""
  end  
  
  local types = {}
  if data[3] then
    types[#types+1] = L[CWL_QUALITY_FINE]
  end
  if data[2] then
    types[#types+1] = L[CWL_QUALITY_SUPERIOR]
  end
  if data[1] then
    types[#types+1] = L[CWL_QUALITY_EPIC]
  end
  local string
  local orfunc = L[CWL_OR_FUNCTION]
  --d("NumTypes "..#types)
  if #types >= 1 then
    string = types[1]
  end
  if #types >= 2 then
    string = orfunc(string,types[2])
  end
  if #types >= 3 then
    string = orfunc(string,types[3])
  end
  return string
end
-- Show the tooltip for the control
function CookeryWizQualitySelector:ShowQualityToolTip(control, state)
  local data = ZO_ScrollList_GetData(control) 

  -- hmm nothing selected?
  if not data then
    trace("No data item associated with quality. None selected?")
    return
  end
  if state then
    local string = self:GetQualityText(data)

      ZO_Tooltips_ShowTextTooltip(control, TOP, string)
  else
        ZO_Tooltips_HideTextTooltip() 
  end
end

function CookeryWizQualitySelector:GetSelectedQuality()
  return ZO_ScrollList_GetSelectedData(self.qualityScrollControl)
end

function CookeryWizQualitySelector:SetSelectedQuality(data)
  ZO_ScrollList_SelectData(self.qualityScrollControl, data)
end

function CookeryWizQualitySelector:OnMouseUp(control)
  local data = ZO_ScrollList_GetData(control) 
  if not data then
    return
  end
  --ZO_ScrollList_SelectData(self.qualityScrollControl, data, control)
  self:SetSelectedQuality(data)
  if self.sourceQuality then
    self:PopulateQualityRow(self.sourceQuality, data)
    if self.changeQualityObject then      
      self.changeQualityFunction(self.changeQualityObject, data)
    end
  end
  self.ui:SetHidden(true)
end

function CookeryWizQualitySelector:SetHighlight(control, state)
  local highlightControl = control:GetNamedChild("Highlight")
  highlightControl:SetHidden(not state)
end

function CookeryWizQualitySelector:PopulateQualityEntries()
  
  local listControl = self.qualityScrollControl
  if not listControl then
    trace("No listControl specified")
    return
  end
  
	local scrollData = ZO_ScrollList_GetDataList(listControl)
  --self.ingredients = scrollData
	ZO_ScrollList_Clear(listControl)
	ZO_ScrollList_ResetToTop(listControl)
  
  for i = 1, #qualityTable do
     entry = qualityTable[i]
     scrollData[#scrollData+1] = ZO_ScrollList_CreateDataEntry(QUALITY_DATA_TYPE, entry)
  end
   
  ZO_ScrollList_Commit(listControl)
  
end


function CookeryWizQualitySelector:LinkSourceRow(sourceQuality)
  self.sourceQuality = sourceQuality
end

function CookeryWizQualitySelector:PackRGB(r, g, b, a)
  local r1 = r/255
  local g1 = nil
  local b1 = nil
  local a1 = nil
  
  if g then
    g1 = g / 255
  end

  if b then
    b1 = b / 255
  end

  if a then
    a1 = a / 255
  end

  return r1, g1, b1, a1
  
end


function CookeryWizQualitySelector:PopulateQualityRow(rowControl, entry)
    
    local controls = {}
    controls[#controls + 1] = rowControl:GetNamedChild("Left") 
    controls[#controls + 1] = rowControl:GetNamedChild("Middle") 
    controls[#controls + 1] = rowControl:GetNamedChild("Right") 
    
  
    -- purple, blue, green
    for i=1, 3 do
        local quality = entry[i]
        local control = controls[i]
        if quality then
          local backDropControl = control:GetNamedChild("BD")
          if quality == ITEM_QUALITY_MAGIC then
            backDropControl:SetCenterColor(self:PackRGB(44, 188, 16, 255))
          elseif quality == ITEM_QUALITY_ARCANE then
            backDropControl:SetCenterColor(self:PackRGB(58, 146, 255, 255))
          elseif quality == ITEM_QUALITY_ARTIFACT then
            backDropControl:SetCenterColor(self:PackRGB(160, 46, 247, 255))
          end
          control:SetHidden(false)
        else
          control:SetHidden(true)
        end
    end
  
end

function CookeryWizQualitySelector:OnQualityScrollListInitialized(control)
  self.qualityScrollControl = control
  if not control then
      trace("qualityScrollControl is nil")
      return
  end  
  
  -- It is important to note that rows are reused. This is an efficient way of optimising memory usage
  -- However, the row control will have left over data and settings from the previous time it was used
  -- This means you cannot rely on defaults and must explicitly clear/set them
  local function InitializeBaseRow(self, rowControl, entry, fadeFavorite)
    --d("Inside initialise base row")
    self:PopulateQualityRow(rowControl, entry)

  end

  local function DestroyBaseRow(rowControl)
    ZO_ObjectPool_DefaultResetControl(rowControl)
  end

 	local function InitializeQualityRow(rowControl, entry)
    self:PopulateQualityRow(rowControl, entry)
		--InitializeBaseRow(self, rowControl, entry, false)
  end
  
 	local function SelectedQualityRow(rowControl, entry)
    --d("Selected")
		--InitializeBaseRow(self, rowControl, entry, false)
  end
  
	local function DestroyQualityRow(rowControl)
		DestroyBaseRow(rowControl)
	end  
     
  ZO_ScrollList_Initialize(control)
  ZO_ScrollList_AddDataType(control, QUALITY_DATA_TYPE, "QualityRowTemplate", 26, InitializeQualityRow, nil, nil, DestroyQualityRow)
  ZO_ScrollList_EnableSelection(control, "ZO_ThinListHighlight")
  ZO_ScrollList_SetAutoSelect(control, true)
	ZO_ScrollList_AddResizeOnScreenResize(control) 
  
  self:PopulateQualityEntries()
  
  --self.qualityScrollControl
end

function CookeryWizQualitySelector:Initialize(changeQualityObject, changeQualityFunction)
  trace("Initialize")
  self.ui = CookeryWizQualitySelectorUI
  self.ui:SetResizeHandleSize(0)  
  self.changeQualityObject = changeQualityObject
  self.changeQualityFunction = changeQualityFunction
end

--[[
function CookeryWizQualitySelector.OnAddOnLoaded(event, addonName)
  local self = CookeryWizQualitySelector
  if addonName == self.name then
    self:Initialize()
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)
  end
end

EVENT_MANAGER:RegisterForEvent(CookeryWizQualitySelector.name, EVENT_ADD_ON_LOADED, CookeryWizQualitySelector.OnAddOnLoaded)
]]--
