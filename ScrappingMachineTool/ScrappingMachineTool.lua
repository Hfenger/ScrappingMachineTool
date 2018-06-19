LoadAddOn("Blizzard_ScrappingMachineUI")

local cg = true
local cb = false
local cp = false
local ilv = 300
local speed = 1
local zt = false

local function GetActualItemLevel(link) 
	local _,_,_, itemLevel = GetItemInfo(link)
	return itemLevel
end

local function puti() 
	for bag=0,4,1 do 
		for slot=1,GetContainerNumSlots(bag),1 do 
			local q=GetContainerItemLink(bag,slot) 
			if q and GetActualItemLevel(q) <= ilv and GetActualItemLevel(q) > 180 then 
				if cg == true and q:sub(5,10)=="1eff00" then
					UseContainerItem(bag,slot)
				end
				if cb == true and q:sub(5,10)=="0070dd" then
					UseContainerItem(bag,slot)
				end
				if cp == true and q:sub(5,10)=="a335ee" then
					UseContainerItem(bag,slot)
				end 
			end 
		end 
	end
end

local mainFrame = CreateFrame('Frame', nil, ScrappingMachineFrame)
mainFrame:SetPoint('TOP', ScrappingMachineFrame, 'BOTTOM', 0, 2)
mainFrame:SetSize(ScrappingMachineFrame:GetWidth()+4, 35)
mainFrame:EnableMouse(true)
mainFrame:SetFrameLevel(ScrappingMachineFrame:GetFrameLevel()-1)
mainFrame:SetBackdrop({
      bgFile="Interface\\FrameGeneral\\UI-Background-Marble", 
      edgeFile='Interface/Tooltips/UI-Tooltip-Border', 
      tile = false, tileSize = 16, edgeSize = 16,
      insets = { left = 4, right = 4, top = 4, bottom = 4 }}
)

mainFrame.totalText = mainFrame:CreateFontString()
mainFrame.totalText:SetFontObject("GameFontHighlight")
mainFrame.totalText:SetText("|cffC495DD限制装等："..ilv)
mainFrame.totalText:SetPoint('BOTTOMRIGHT', -45, 12)

local downButton = CreateFrame('Button', nil, mainFrame)
downButton:SetSize(24, 24)
downButton:SetNormalTexture('Interface/Buttons/UI-SpellbookIcon-PrevPage-Up')
downButton:SetPushedTexture('Interface/Buttons/UI-SpellbookIcon-PrevPage-Down')
downButton:SetDisabledTexture('Interface/Buttons/UI-SpellbookIcon-PrevPage-Disabled')
downButton:SetPoint('RIGHT', mainFrame.totalText, 'LEFT', -2, -1)
downButton:SetHighlightTexture('Interface/Buttons/UI-Common-MouseHilight', 'ADD')
downButton:SetScript('OnClick', function(self)
	if ilv > 180 then
		ilv = ilv-5
		mainFrame.totalText:SetText("|cffC495DD限制装等："..ilv)
	end
end)


local upButton = CreateFrame('Button', nil, mainFrame)
upButton:SetSize(24, 24)
upButton:SetNormalTexture('Interface/Buttons/UI-SpellbookIcon-NextPage-Up')
upButton:SetPushedTexture('Interface/Buttons/UI-SpellbookIcon-NextPage-Down')
upButton:SetDisabledTexture('Interface/Buttons/UI-SpellbookIcon-NextPage-Disabled')
upButton:SetPoint('LEFT', mainFrame.totalText, 'RIGHT', 2, -1)
upButton:SetHighlightTexture('Interface/Buttons/UI-Common-MouseHilight', 'ADD')
upButton:SetScript('OnClick', function(self)
	if ilv < 1000 then
		ilv = ilv+5
		mainFrame.totalText:SetText("|cffC495DD限制装等："..ilv)
	end
end)

local autoButton = CreateFrame('Button', nil, mainFrame, 'GameMenuButtonTemplate')
autoButton:SetSize(75, 25)
autoButton:SetPoint("BOTTOMLEFT", 5, 6)
autoButton:SetText("自动填装")
autoButton:SetScript('OnClick', function(self)
	if zt == true then
		zt = false
		autoButton:SetText("自动填装")
	else
		zt = true
		autoButton:SetText("|cff1eff00已开启")
	end

	
end)



local handButton = CreateFrame('Button', nil, mainFrame, 'GameMenuButtonTemplate')
handButton:SetSize(75, 25)
handButton:SetPoint('LEFT', autoButton, 'RIGHT', 2, 0)
handButton:SetText("手动填装")
handButton:SetScript('OnClick', function(self)
	puti()	
end)


local ashTextToggle = CreateFrame('Button', nil, ScrappingMachineFrame)
ashTextToggle:SetPoint('CENTER', ScrappingMachineFrameInset, 'BOTTOMRIGHT', -20, 20)
ashTextToggle:SetSize(32, 32)

ashTextToggle.n = ashTextToggle:CreateTexture()
ashTextToggle.n:SetTexture("Interface\\common\\help-i")
ashTextToggle.n:SetAllPoints()

ashTextToggle.g = ashTextToggle:CreateTexture(nil, 'OVERLAY')
ashTextToggle.g:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
ashTextToggle.g:SetBlendMode("ADD")
ashTextToggle.g:SetAllPoints()
ashTextToggle.g:Hide()

ashTextToggle:SetScript('OnEnter', function(self)
    self.g:Show()
    GameTooltip:SetOwner(ashTextToggle, "ANCHOR_TOPRIGHT")
    GameTooltip:AddLine("塞弗斯驱灵金拆解助手，可根据实际需求进行设置，忽略指定装备功能正在开发中!", 1, 1, 1)
    GameTooltip:Show()
end)

ashTextToggle:SetScript('OnLeave', function(self)
    self.g:Hide()
    GameTooltip:Hide()
end)


local function hideSelection()
    if selectedButton then
        SetItemButtonDesaturated(getSelectedButton(), false)
        AnimatedShine_Stop(getSelectedButton())
        previousSelectedButton = selectedButton
        selectedButton = nil
    end
    itemName:Hide()
    itemLevel:Hide()
    
    ashText:Hide()
end

mainFrame.green = ScrappingMachineFrame:CreateFontString()
mainFrame.green:SetFontObject("GameFontHighlight")
mainFrame.green:SetText("|cff1eff00绿")
mainFrame.green:SetPoint('LEFT', ScrappingMachineFramePortrait, 'RIGHT', 20, -20)

mainFrame.greenCheck = CreateFrame('CheckButton', nil, ScrappingMachineFrame, "UICheckButtonTemplate")
mainFrame.greenCheck:SetPoint('LEFT', mainFrame.green, 'RIGHT', 0, -2)
mainFrame.greenCheck:SetSize(28, 28)
if cg == true then
	mainFrame.greenCheck:SetChecked(true)
else
	mainFrame.greenCheck:SetChecked(false)
end
mainFrame.greenCheck:SetScript('OnClick', function(self)
	if cg == true then
		cg = false
		self:SetChecked(false)
	else
		cg = true
		self:SetChecked(true)
	end

end)

mainFrame.greenCheck:SetScript('OnEnter', function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText("是否填装绿装？")
    GameTooltip:Show()
end)

mainFrame.greenCheck:SetScript('OnLeave', function(self)
    GameTooltip:Hide()
end)

mainFrame.blue = ScrappingMachineFrame:CreateFontString()
mainFrame.blue:SetFontObject("GameFontHighlight")
mainFrame.blue:SetText("|cff0070dd蓝")
mainFrame.blue:SetPoint('LEFT', mainFrame.green, 'RIGHT', 50, 0)

mainFrame.blueCheck = CreateFrame('CheckButton', nil, ScrappingMachineFrame, "UICheckButtonTemplate")
mainFrame.blueCheck:SetPoint('LEFT', mainFrame.blue, 'RIGHT', 0, -2)
mainFrame.blueCheck:SetSize(28, 28)
if cb == true then
	mainFrame.blueCheck:SetChecked(true)
else
	mainFrame.blueCheck:SetChecked(false)
end
mainFrame.blueCheck:SetScript('OnClick', function(self)
	if cb == true then
		cb = false
		self:SetChecked(false)
	else
		cb = true
		self:SetChecked(true)
	end
end)

mainFrame.blueCheck:SetScript('OnEnter', function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText("是否填装蓝装？")
    GameTooltip:Show()
end)

mainFrame.blueCheck:SetScript('OnLeave', function(self)
    GameTooltip:Hide()
end)

mainFrame.purple = ScrappingMachineFrame:CreateFontString()
mainFrame.purple:SetFontObject("GameFontHighlight")
mainFrame.purple:SetText("|cffa335ee紫")
mainFrame.purple:SetPoint('LEFT', mainFrame.blue, 'RIGHT', 50, 0)

mainFrame.purpleCheck = CreateFrame('CheckButton', nil, ScrappingMachineFrame, "UICheckButtonTemplate")
mainFrame.purpleCheck:SetPoint('LEFT', mainFrame.purple, 'RIGHT', 0, -2)
mainFrame.purpleCheck:SetSize(28, 28)
if cp == true then
	mainFrame.purpleCheck:SetChecked(true)
else
	mainFrame.purpleCheck:SetChecked(false)
end
mainFrame.purpleCheck:SetScript('OnClick', function(self)
	if cp == true then
		cp = false
		self:SetChecked(false)
	else
		cp = true
		self:SetChecked(true)
	end
end)

mainFrame.purpleCheck:SetScript('OnEnter', function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText("是否填装紫装？")
    GameTooltip:Show()
end)

mainFrame.purpleCheck:SetScript('OnLeave', function(self)
    GameTooltip:Hide()
end)

ScrappingMachineFrame:SetScript('OnHide', function(self)
	zt = false
	autoButton:SetText("自动填装")
end)

mainFrame.sec = 0
mainFrame:SetScript("OnUpdate", function(self, elapsed)
	self.sec = self.sec + elapsed
	if self.sec > speed and zt == true then
		self.sec = 0
		puti()
		
	end
end)
