-- params : ...
-- function num : 0 , upvalues : _ENV
local UITDCharactorInfo = class("UITDCharactorInfo", UIBaseWindow)
local csBattleManager = CS.BattleManager
local base = UIBaseWindow
UITDCharactorInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_ShowInfo, self, self.OnClickCharactorInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Retreat, self, self.OnClickRetreat)
end

UITDCharactorInfo.Show = function(self)
  -- function num : 0_1 , upvalues : _ENV, base
  local tdBattleWindow = UIManager:GetWindow(UIWindowTypeID.TDBattle)
  if tdBattleWindow ~= nil and tdBattleWindow.onTapSelectRole then
    return 
  end
  ;
  (base.Show)(self)
end

UITDCharactorInfo.OnShow = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.OnShow)(self)
  MsgCenter:Broadcast(eMsgEventId.TDOpenBulletTime, true)
  MsgCenter:Broadcast(eMsgEventId.TDDisplayOtherUI, false)
end

UITDCharactorInfo.InitCharactor = function(self, hero, reTreatTowerAction)
  -- function num : 0_3
  self.hero = hero
  self:TDCharactorCutdown()
  self.__reTreatTowerAction = reTreatTowerAction
end

UITDCharactorInfo.OnClickCharactorInfo = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local dungeonStateWindow = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if dungeonStateWindow ~= nil then
    dungeonStateWindow:ShowHero((self.hero).character)
    ;
    (self.gameObject):SetActive(false)
  end
end

UITDCharactorInfo.OnClickRetreat = function(self)
  -- function num : 0_5
  if self.__reTreatTowerAction ~= nil then
    (self.__reTreatTowerAction)(self.hero)
  end
  self:Hide()
end

UITDCharactorInfo.TDCharactorCutdown = function(self)
  -- function num : 0_6 , upvalues : _ENV, csBattleManager
  if self.hero == nil then
    return 
  end
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  if dynPlayer == nil then
    return 
  end
  local returnEnergy = (self.hero):GetTDTowerLoadOffReturnEnergy()
  local csBattleCtrl = (csBattleManager.Instance).CurBattleController
  local playerTDComp = nil
  if csBattleCtrl ~= nil then
    playerTDComp = (csBattleCtrl.PlayerController):GetTowerPlayerComponent()
  end
  do
    if playerTDComp ~= nil then
      local returnEnergyLimit = (ConfigData.game_config).towerMoneyMax - playerTDComp.UITowerMp
      returnEnergy = (math.min)(returnEnergy, returnEnergyLimit)
    end
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Token).text = tostring(returnEnergy)
  end
end

UITDCharactorInfo.OnHide = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnHide)(self)
  self.hero = nil
  MsgCenter:Broadcast(eMsgEventId.TDCloseBulletTime)
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  MsgCenter:Broadcast(eMsgEventId.TDDisplayOtherUI, true)
end

return UITDCharactorInfo

