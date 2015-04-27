
local SHOW_HIDE = 1
local SHOW_SHRUNK = 2
local SHOW_NORMAL = 3


-- The EasyFrame class
EasyFrame = {}
EasyFrame.name = "EasyFrame"

EasyFrame.ui = nil
EasyFrame.buttonShrink = nil

EasyFrame.textureShrink = nil

EasyFrame.expandTooltip = "Expand"
EasyFrame.shrinkTooltip = "Shrink"
EasyFrame.shrinkButtonTooltip = EasyFrame.shrinkTooltip

EasyFrame.closeTooltip = "Close"
EasyFrame.reloadTooltip = "Reload"
EasyFrame.reloadButton = nil
EasyFrame.closeButton = nil
EasyFrame.shrinkButton = nil
EasyFrame.titleLabel = nil
EasyFrame.parentWindow = nil

EasyFrame.resizeHandleSize = 5

EasyFrame.minWidthNormal = nil
EasyFrame.minHeightNormal = nil
EasyFrame.maxWidthNormal = nil
EasyFrame.maxHeightNormal = nil

EasyFrame.traceEnabled = false

EasyFrame.easyFrameVariables = {
      left = 100,
      top = 100,
      width = 400,
      height = 400,
      heightMin = 400,
      widthMin = 400,
	  shrinkWidth=250,
	  shrinkHeight=290,
	  shrinkWidthMin=200,
	  shrinkHeightMin=200,
      isShrunk = false,
      isHidden = false,
      viewState = SHOW_NORMAL
}

EasyFrame.uis = {
  
}

function EasyFrame:EnableTrace(enable)
  self.traceEnabled = enable
end

function EasyFrame:Trace(msg)
  if self.traceEnabled then
    d(msg)
  end
end

---------------------------------------------------------------------
-- virtual functions
---------------------------------------------------------------------
function EasyFrame:OnShrink(isHidden)
end

function EasyFrame:OnEasyFrameResize()
end

function EasyFrame:OnRestorePosition()
end

function EasyFrame:OnReload()
end

function EasyFrame:OnMoveStop()
end

function EasyFrame:OnHideWindow(isHidden)
end

---------------------------------------------------------------------
-- General functions
---------------------------------------------------------------------

function EasyFrame:DisableShrink(disable)
  self.easyFrameVariables.disableShrink = disable
  self.shrinkButton:SetHidden(disable)
end

function EasyFrame:IsShrinkDisabled()
  return self.easyFrameVariables.disableShrink
end

function EasyFrame:GetParentWindow()
  return self.parentWindow
end

function EasyFrame:CenterToParent()
  local ui = self.ui

  if self.parentWindow then
    --d("Centring to parent")
    local dialogWidth = ui:GetWidth()
    local dialogHeight = ui:GetHeight()
    local parentWidth = self.parentWindow:GetWidth()
    local parentHeight = self.parentWindow:GetHeight()
    
    --d("Width:["..dialogWidth.."], Height:["..dialogHeight.."], "..self.parentWindow:GetName())
    self.ui:ClearAnchors()
    self.ui:SetAnchor(TOPLEFT, self.parentWindow, TOPLEFT, (parentWidth/2)-(dialogWidth/2), (parentHeight/2)-(dialogHeight/2)) 
  else
    --d("Not Centering to parent null")
  end
end

function EasyFrame:OnShow()
  --d("EasyFrame:OnShow")
end

function EasyFrame:ToggleWindow()
  local isHidden = self.ui:IsHidden()
  
  local isShrinkDisabled = self:IsShrinkDisabled()
  if isShrinkDisabled then
    self:HideWindow(not isHidden)
    return
  end
  
  if isHidden then
    -- next stage is to show normal
    self.easyFrameVariables.isShrunk = false
    self:Shrink() 
    isHidden = false
  else
    if self.easyFrameVariables.isShrunk then
      --d("shrink button is hidden")
      isHidden = true
    elseif self.shrinkButton:IsHidden() then
      isHidden = true
    else
      self.easyFrameVariables.isShrunk = true
      self:Shrink()
      isHidden = false
    end
  end
  self:HideWindow(isHidden)
end


function EasyFrame:OnEasyFrameResizeStop(control)
  --d("resize")
  if not self then
    d("OnEasyFrameResizeStop called without :")
    return
  end
  
  local vars = self.easyFrameVariables
  local isShrunk = vars.isShrunk
  
  if isShrunk == true then
  	  vars.shrinkWidth = control:GetWidth()
	  vars.shrinkHeight = control:GetHeight()  
  else
	  vars.width = control:GetWidth()
	  vars.height = control:GetHeight()  
  end
  
  self:OnEasyFrameResize()
end

function EasyFrame:Shrink()
  local ui = self.ui
  local vars = self.easyFrameVariables
  
  local isShrunk = vars.isShrunk
  local width = vars.width
  local height = vars.height
  local heightMin = vars.heightMin
  local widthMin = vars.widthMin

  local left = vars.left
  local top = vars.top
  local texture
  
  ui:ClearAnchors()
  ui:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)

	if isShrunk == true then
	
		self.ui:SetDimensionConstraints(10, 10) 
		
		local wantedWidth = self.titleLabel:GetDimensions()
		local wantedHeight = 23
		wantedWidth = wantedWidth + 85
		
		if (self.reloadButton:IsHidden()) then
			wantedWidth = wantedWidth - self.reloadButton:GetWidth()
		end
	
		width = vars.shrinkWidth
		height = vars.shrinkHeight
		
		widthMin = math.max(vars.shrinkWidthMin,wantedWidth)
		heightMin = math.max(vars.shrinkHeightMin,wantedHeight)
	else
		self.ui:SetDimensionConstraints(self.minWidthNormal, self.minHeightNormal) 
	end
	
    if width < widthMin then
      width = widthMin
    end
    ui:SetWidth(width)
    --d("Setting width("..width..")")
    if height < heightMin then
      height = heightMin
    end    
    ui:SetHeight(height)
    --d("Setting height("..height..")")    
    texture = "/esoui/art/minimap/minimap_minimize_up.dds"
    --texture = "EsoUI/Art/Buttons/cancel_up.dds"
    self.shrinkButtonTooltip = self.shrinkTooltip
    ui:SetResizeHandleSize(self.resizeHandleSize)
	
  --end
  
  
  
  if self.textureShrink then    
    self:SetShrinkButtonTexture(true)
    --self.textureShrink:SetTexture(isShrunk)
  end

  self:OnShrink()
end


function EasyFrame:RestorePosition()
  local left = self.easyFrameVariables.left
  local top = self.easyFrameVariables.top
  
  self.ui:ClearAnchors()
  self.ui:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
  self:OnRestorePosition()
  
  self:Shrink()   
end

---------------------------------------------------------------------
-- Initialisation and click functions
---------------------------------------------------------------------

function EasyFrame:SetupTooltip(control, text)
  local easyFrame = self
  
  control:SetHandler("OnMouseEnter", function(self)
      ZO_Tooltips_ShowTextTooltip(self, TOP, text)
      
    end)
  control:SetHandler("OnMouseExit", function(self)
        ZO_Tooltips_HideTextTooltip() 
    end)
end
--
-- Shrink button initialisation. Sets up tooltips and click events
--

function EasyFrame:SetShrinkButtonTexture(normal)
  if normal then
    if self.easyFrameVariables.isShrunk then
      self.textureShrink:SetTexture("esoui/art/chatwindow/maximize_up.dds")
    else
      self.textureShrink:SetTexture("esoui/art/chatwindow/minimize_up.dds")
    end  
  else
    if self.easyFrameVariables.isShrunk then
      self.textureShrink:SetTexture("esoui/art/chatwindow/maximize_over.dds")
    else
      self.textureShrink:SetTexture("esoui/art/chatwindow/minimize_over.dds")
    end     
  end
end


function EasyFrame:OnShrinkButtonInitialized(control)
  local easyFrame = self
  
  control:SetHandler("OnMouseEnter", function(self)
      easyFrame:SetShrinkButtonTexture(false)
      ZO_Tooltips_ShowTextTooltip(self, TOP, easyFrame.shrinkButtonTooltip)
      
    end)
  control:SetHandler("OnMouseExit", function(self)
      easyFrame:SetShrinkButtonTexture(true)
        ZO_Tooltips_HideTextTooltip()
      
    end)
  control:SetHandler("OnClicked", function(self)
        easyFrame:OnShrinkButtonClicked()
    end)
end

function EasyFrame:OnShrinkButtonClicked(control) 
  self.easyFrameVariables.isShrunk = not self.easyFrameVariables.isShrunk
  self:Shrink()
end


--
-- Close button initialisation. Sets up tooltips and click events
--

function EasyFrame:OnCloseButtonInitialized(control)
  local easyFrame = self
  
  control:SetHandler("OnMouseEnter", function(self)
      ZO_Tooltips_ShowTextTooltip(self, TOP, easyFrame.closeTooltip)
  end)
  control:SetHandler("OnMouseExit", function(self)
      ZO_Tooltips_HideTextTooltip()
  end)
  
  control:SetHandler("OnClicked", function(self)
        easyFrame:OnCloseButtonClicked()
    end) 
end

function EasyFrame:HideWindow(isHidden)
  self.easyFrameVariables.isHidden = isHidden
  if self.ui then
    self.ui:SetHidden(isHidden)
  end
  self:OnHideWindow(isHidden)
end

function EasyFrame:OnCloseButtonClicked()
  self:HideWindow(true)
end

--
-- Reload button initialisation. Sets up tooltips and click events
--

function EasyFrame:OnReloadButtonInitialized(control)
  local easyFrame = self
  
  control:SetHandler("OnMouseEnter", function(self)
      ZO_Tooltips_ShowTextTooltip(self, TOP, easyFrame.reloadTooltip)
  end)
  control:SetHandler("OnMouseExit", function(self)
      ZO_Tooltips_HideTextTooltip()
  end)

  control:SetHandler("OnClicked", function(self)
        easyFrame:OnReloadButtonClicked()
    end)
end

function EasyFrame:OnReloadButtonClicked()
  self:OnReload()
end

--
-- Texture. Nothing really
--
function EasyFrame:OnTextureShrinkInitialized(control)
  
end

---------------------------
function EasyFrame:new ()

    local o = {}
    setmetatable(o, self)
    self.__index = self
    -- clone the easyFrameVariables, ready for changes
    o.easyFrameVariables = ZO_ShallowTableCopy(self.easyFrameVariables)
    return o
end

function EasyFrame:EasyFrameValidate()
  d("EasyFrameValidate")
  
  if not self then
    d("You have called EasyFrame:Validate without :")
    return
  end
  
  local res = true

  if not self.ui then
      d("No TopLevelControl")
      res = false
  end 
  if not self.reloadButton then
      d("No reloadButton")
      res = false
  end 
  if not self.shrinkButton then
      d("No shrinkButton")
      res = false
  end
  if not self.closeButton then
      d("No closeButton")
      res = false
  end
  if not self.textureShrink then
      d("No textureShrink")
      res = false
  end
  
  if not self.titleLabel then
      d("No titleLabel")
      res = false
  end  
  return res
end

function EasyFrame:OnEasyFrameMoveStop()
  --d("OnEasyFrameMoveStop")
  self.easyFrameVariables.left = self.ui:GetLeft()
  self.easyFrameVariables.top = self.ui:GetTop()
  self:OnMoveStop()
end

-- The main TopLevelControl
function EasyFrame:InitializeEasyFrame(title, ui, parentUI)
  local easyFrame = self
  self.ui = ui
  self.parentWindow = parentUI
  
  if not self.ui then
      d("No TopLevelControl passed")
      return
  end 
  
  -- add event handlers
  self.reloadButton = ui:GetNamedChild("ReloadButton")
  if not self.reloadButton then
      d("No reloadButton")
      return
  end
  
  self.shrinkButton = ui:GetNamedChild("ShrinkButton")
  if not self.shrinkButton then
      d("No shrinkButton")
      return
  end
  
  self.closeButton = ui:GetNamedChild("CloseButton")
  if not self.closeButton then
      d("No closeButton")
      return
  end  
  
  self.titleLabel = ui:GetNamedChild("TitleLabel")
  if not self.titleLabel then
      d("No titleLabel")
      return
  end
  
  self.textureShrink = self.shrinkButton:GetNamedChild("TextureShrink")
  if not self.textureShrink then
      d("No textureShrink")
      return
  end

  
  -- Set title
  self.titleLabel:SetText(title)
  
  -- Initialise these controls
  self:OnReloadButtonInitialized(self.reloadButton)
  self:OnShrinkButtonInitialized(self.shrinkButton)
  
  self:OnCloseButtonInitialized(self.closeButton)
  self.OnTextureShrinkInitialized(self.textureShrink)
  
  -- Handle MoveStop  
  self.ui:SetHandler("OnMoveStop", function(self)
        --d("OnMoveStop")
        easyFrame:OnEasyFrameMoveStop(self)
    end)
  
  -- Handle Resize
  self.ui:SetHandler("OnResizeStop", function(self)
        --d("OnResizeStop")
        easyFrame:OnEasyFrameResizeStop(self)
    end)
  
  
  -- Get any size constraints that are in place
  self.minWidthNormal, self.minHeightNormal, self.maxWidthNormal, self.maxHeightNormal = self.ui:GetDimensionConstraints()
  
  self:RestorePosition()

  self:DisableShrink(self.easyFrameVariables.disableShrink)
  self:HideWindow(self.easyFrameVariables.isHidden)
end


