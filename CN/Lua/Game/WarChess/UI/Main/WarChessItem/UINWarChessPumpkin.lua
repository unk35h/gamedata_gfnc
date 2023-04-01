-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessPumpkin = class("UINWarChessPumpkin", base)
local cs_MessageCommon = CS.MessageCommon
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
UINWarChessPumpkin.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_pumpkain, self, self.__OnClickPumpkin)
  self.__refreshPunpkinNum = BindCallback(self, self.__RefreshPunpkinNum)
  MsgCenter:AddListener(eMsgEventId.WC_ItemNumChange, self.__refreshPunpkinNum)
  MsgCenter:AddListener(eMsgEventId.WC_ItemLimitNumChange, self.__refreshPunpkinNum)
  self.__UpdShowWcPumkinFxFunc = BindCallback(self, self._UpdShowWcPumkinFx)
  MsgCenter:AddListener(eMsgEventId.WC_HeroDynUpdate, self.__UpdShowWcPumkinFxFunc)
  MsgCenter:AddListener(eMsgEventId.WC_SelectTeam, self.__UpdShowWcPumkinFxFunc)
end

UINWarChessPumpkin.InitWCSSpecialItem = function(self, specialItemCfg)
  -- function num : 0_1
  local param = specialItemCfg.param
  self.eventId = param[3]
  self.itemId = param[4]
  self:__RefreshPunpkinNum()
  self:_UpdShowWcPumkinFx()
end

UINWarChessPumpkin.__RefreshPunpkinNum = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local capacity = (wcCtrl.backPackCtrl):GetWCItemCapacity(self.itemId)
  local curNum = (wcCtrl.backPackCtrl):GetWCItemNum(self.itemId)
  ;
  ((self.ui).txt_itemNum):SetIndex(0, tostring(curNum), tostring(capacity))
end

UINWarChessPumpkin.WCSpecialItemNodeRefresh = function(self)
  -- function num : 0_3
  self:__RefreshPunpkinNum()
  self:_UpdShowWcPumkinFx()
end

UINWarChessPumpkin.__OnClickPumpkin = function(self)
  -- function num : 0_4 , upvalues : _ENV, eWarChessEnum, cs_MessageCommon
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if not (wcCtrl.curState):IsCanOpenMenu() then
    return 
  end
  local teamData = nil
  if wcCtrl.state == (eWarChessEnum.eWarChessState).play then
    teamData = (wcCtrl.curState):GetCurSelectedTeamData()
  end
  if teamData == nil then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8719))
    return 
  end
  teamData:ClearWCLastAP()
  local wid, tid = (wcCtrl.teamCtrl):GetWCTeamIdentify(teamData)
  local identify = {wid = wid, tid = tid}
  ;
  (wcCtrl.wcNetworkCtrl):CS_WarChess_GlobalInteract(identify, self.eventId)
end

UINWarChessPumpkin._UpdShowWcPumkinFx = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if IsNull((self.ui).fx) then
    return 
  end
  local show = self:_IsNeedShowFx()
  ;
  ((self.ui).fx):SetActive(show)
end

UINWarChessPumpkin._IsNeedShowFx = function(self)
  -- function num : 0_6 , upvalues : _ENV, eWarChessEnum
  (WarChessManager:GetWarChessCtrl())
  local wcCtrl = nil
  local teamData = nil
  if wcCtrl.state == (eWarChessEnum.eWarChessState).play then
    teamData = (wcCtrl.curState):GetCurSelectedTeamData()
  end
  if teamData == nil then
    return false
  end
  local choiceCfg = (ConfigData.warchess_event_choice)[119]
  if choiceCfg == nil then
    error("Cant get warchess_event_choice,id:" .. tostring(119))
    return false
  end
  local allHpPer = nil
  for k,v in ipairs(choiceCfg.triggerActions) do
    if v.cat == (eWarChessEnum.eTriggerType).ChangeTeamHp then
      allHpPer = 10000 - (v.pms)[2]
    end
  end
  if allHpPer == nil then
    error("allHpPer = nil")
    return false
  end
  local choiceCfg = (ConfigData.warchess_event_choice)[120]
  if choiceCfg == nil then
    error("Cant get warchess_event_choice,id:" .. tostring(120))
    return false
  end
  local singleHpPer = nil
  for k,v in ipairs(choiceCfg.triggerActions) do
    if v.cat == (eWarChessEnum.eTriggerType).ChangeMinHpHeroHp then
      singleHpPer = 10000 - (v.pms)[2]
    end
  end
  if singleHpPer == nil then
    error("singleHpPer = nil")
    return false
  end
  local allOk = true
  local wcDynPlayer = teamData:GetTeamDynPlayer()
  for heroId,dynHero in pairs(wcDynPlayer.heroDic) do
    if allHpPer <= dynHero.hpPer then
      allOk = false
    end
    if dynHero.hpPer < singleHpPer then
      return true
    end
  end
  return allOk
end

UINWarChessPumpkin.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.WC_ItemNumChange, self.__refreshPunpkinNum)
  MsgCenter:RemoveListener(eMsgEventId.WC_ItemLimitNumChange, self.__refreshPunpkinNum)
  MsgCenter:RemoveListener(eMsgEventId.WC_HeroDynUpdate, self.__UpdShowWcPumkinFxFunc)
  MsgCenter:RemoveListener(eMsgEventId.WC_SelectTeam, self.__UpdShowWcPumkinFxFunc)
  ;
  (base.OnDelete)(self)
end

return UINWarChessPumpkin

