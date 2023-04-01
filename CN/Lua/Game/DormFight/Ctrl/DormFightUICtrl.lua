-- params : ...
-- function num : 0 , upvalues : _ENV
local DormFightCtrlBase = require("Game.Fight.Ctrl.DormFightCtrlBase")
local DormFightUICtrl = class("DormFightUICtrl", DormFightCtrlBase)
local CS_pvpFightManager_ins = (CS.PvpFightManager).Instance
local CS_UIInfoWindow = (((CS.P3).PvpFight).UI).UI_PvpFightCharacterInfoWindow
DormFightUICtrl.ctor = function(self)
  -- function num : 0_0
end

DormFightUICtrl.OnPrepareDormFightUI = function(self, roomInfo, resLoader)
  -- function num : 0_1 , upvalues : _ENV, CS_pvpFightManager_ins
  self.resLoader = ((CS.ResLoader).Create)()
  self.fightUI = UIManager:ShowWindow(UIWindowTypeID.DormFightMain)
  ;
  (self.fightUI):InitDormFightMain(roomInfo, self.resLoader)
  ;
  (self.fightUI):Hide()
  self.pvpFightUiController = CS_pvpFightManager_ins.PvpFightUiController
  self.characterInfoWindow = (self.pvpFightUiController):CreateCharacterInfoWindow()
  ;
  (self.characterInfoWindow):Hide()
end

DormFightUICtrl.OnEnterDormFightScene = function(self)
  -- function num : 0_2
  (self.fightUI):Show()
  ;
  (self.characterInfoWindow):Show()
end

DormFightUICtrl.OnCreateFighter = function(self, fighterController)
  -- function num : 0_3
  local netCharacter = fighterController.NetCharacter
  if netCharacter.IsOwnedBySelf then
    self:SetMainCharacter(fighterController)
  end
end

DormFightUICtrl.OnDestroyFighter = function(self, pvpFightController, fighterController)
  -- function num : 0_4
  local netCharacter = fighterController.NetCharacter
  local retiredUserId = (netCharacter.NetId).userId
  local retiredRoomPlayer = pvpFightController:GetRoomPlayerByUserId(retiredUserId)
  local index = retiredRoomPlayer.CurrentFighterIndex
  ;
  (self.fightUI):FighterRetired(netCharacter.IsOwnedBySelf, index)
end

DormFightUICtrl.FightSecondsChanged = function(self, pvpFightController, dormFightInGameState, seconds)
  -- function num : 0_5
  (self.fightUI):UpDateCountDown(seconds, dormFightInGameState.fightTimeLimit)
end

DormFightUICtrl.SetMainCharacter = function(self, fighterController)
  -- function num : 0_6 , upvalues : _ENV
  if IsNull(self.fightUI) then
    return 
  end
  ;
  (self.fightUI):SetMainFighterController(fighterController)
end

DormFightUICtrl.OnUpdateBtnWeapon = function(self, netCharacter)
  -- function num : 0_7
  (self.fightUI):OnUpdateBtnWeapon(netCharacter)
end

DormFightUICtrl.OnUpdateBtnRun = function(self, netCharacter)
  -- function num : 0_8
  (self.fightUI):OnUpdateBtnRun(netCharacter)
end

DormFightUICtrl.OnFightStart = function(self)
  -- function num : 0_9
end

DormFightUICtrl.OnFightEnd = function(self)
  -- function num : 0_10 , upvalues : _ENV
  (self.characterInfoWindow):Hide()
  UIManager:HideWindow(UIWindowTypeID.DormFightMain)
end

DormFightUICtrl.Delete = function(self)
  -- function num : 0_11
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  self:ClearDormFightLuaWindow()
  self:ClearAllCSharpWindow()
end

DormFightUICtrl.ClearDormFightLuaWindow = function(self)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:DeleteWindow(UIWindowTypeID.DormFightMain)
  self.fightUI = nil
end

DormFightUICtrl.ClearAllCSharpWindow = function(self)
  -- function num : 0_13
  (self.pvpFightUiController):DestroyCharacterInfoWindow()
  self.characterInfoWindow = nil
end

return DormFightUICtrl

