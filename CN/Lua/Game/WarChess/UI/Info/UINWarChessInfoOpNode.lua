-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessInfoOpNode = class("UINWarChessInfoOpNode", base)
local UINWarChessInfoOpNodeBtn = require("Game.WarChess.UI.Info.UINWarChessInfoOpNodeBtn")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
UINWarChessInfoOpNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessInfoOpNodeBtn
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.btnPool = (UIItemPool.New)(UINWarChessInfoOpNodeBtn, (self.ui).obj_btn_Info)
  ;
  (self.btnPool):SetItemPoolHideName("h")
  ;
  ((self.ui).obj_btn_Info):SetActive(false)
end

UINWarChessInfoOpNode.CleanWCOPRoot = function(self)
  -- function num : 0_1
  self.__actCallback = nil
  self.__infoActCallback = nil
  ;
  (self.btnPool):HideAll()
end

UINWarChessInfoOpNode.SetWCAct = function(self, actCallback, interactCfg, costAP, isMonster, getIsSecKill)
  -- function num : 0_2
  local SetInterAct = function(isSecKill)
    -- function num : 0_2_0 , upvalues : self, isMonster, costAP, actCallback, interactCfg
    self.__isWaitingCouldSecKill = false
    local interActBtn = (self.btnPool):GetOne()
    local index = isMonster and 1 or 2
    if isMonster then
      if isSecKill then
        index = 5
      else
        index = 1
      end
    else
      index = 2
    end
    interActBtn:SetInterActionType(index, costAP)
    interActBtn:SetClickCallback(function()
      -- function num : 0_2_0_0 , upvalues : actCallback, interactCfg, self
      if actCallback ~= nil then
        actCallback(interactCfg)
      end
      self:Hide()
    end
)
    self.__interActBtn = interActBtn
    if self.__whenWaitOverClkik then
      self:WCOpDoubleClick()
      self.__whenWaitOverClkik = false
    end
  end

  if isMonster and getIsSecKill ~= nil then
    self.__isWaitingCouldSecKill = true
    getIsSecKill(SetInterAct)
  else
    SetInterAct(false)
  end
end

UINWarChessInfoOpNode.SetWCShowDynDeployTeam = function(self)
  -- function num : 0_3 , upvalues : _ENV, eWarChessEnum
  local infoActBtn = (self.btnPool):GetOne()
  infoActBtn:SetInterActionType(3)
  infoActBtn:SetClickCallback(function()
    -- function num : 0_3_0 , upvalues : _ENV, eWarChessEnum, self
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    if wcCtrl:IsWCInSubSystem() then
      ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(8516))
      return 
    end
    if (wcCtrl.backPackCtrl):GetWCDeployPointNum() < 1 then
      ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(8523))
    end
    wcCtrl:ChangeWarChessState((eWarChessEnum.eWarChessState).deploy, {isDynDeploy = true})
    self:Hide()
  end
)
  self.__infoActBtn = infoActBtn
end

UINWarChessInfoOpNode.SetWCCustomInteract = function(self, actCallback, costAP, typeIndex)
  -- function num : 0_4
  local infoActBtn = (self.btnPool):GetOne()
  infoActBtn:SetInterActionType(typeIndex, costAP)
  infoActBtn:SetClickCallback(function()
    -- function num : 0_4_0 , upvalues : actCallback, self
    if actCallback ~= nil then
      actCallback()
    end
    self:Hide()
  end
)
  self.__infoActBtn = infoActBtn
end

UINWarChessInfoOpNode.SetWCUseCallback = function(self, callback)
  -- function num : 0_5
  self.__hideCallback = callback
end

UINWarChessInfoOpNode.WCOpDoubleClick = function(self)
  -- function num : 0_6
  if self.__interActBtn ~= nil then
    (self.__interActBtn):__OnClick()
  else
    if self.__isWaitingCouldSecKill then
      self.__whenWaitOverClkik = true
    else
      if self.__infoActBtn ~= nil then
        (self.__infoActBtn):__OnClick()
      end
    end
  end
end

UINWarChessInfoOpNode.OnHide = function(self)
  -- function num : 0_7
  if self.__hideCallback ~= nil then
    (self.__hideCallback)()
    self.__hideCallback = nil
  end
end

UINWarChessInfoOpNode.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoOpNode

