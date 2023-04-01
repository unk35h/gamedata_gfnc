-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTDBattleHeroHeadItem = class("UINTDBattleHeroHeadItem", UIBaseNode)
local base = UIBaseNode
local UINHeroHeadItem = require("Game.CommonUI.Hero.UINHeroHeadItem")
local csBattleMgr = CS.BattleManager
local CS_MessageCommon = CS.MessageCommon
UINTDBattleHeroHeadItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroHeadItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.headItem = (UINHeroHeadItem.New)()
  ;
  (self.headItem):Init(((self.ui).heroHeadItem).gameObject)
  ;
  (UIUtil.AddButtonListener)((self.ui).heroHeadItem, self, self.OnSetDragHero)
  local eventTrigger = ((CS.EventTriggerListener).Get)((self.headItem).gameObject)
  eventTrigger:onBeginDrag("+", BindCallback(self, self.OnBeginDragHero))
end

UINTDBattleHeroHeadItem.OnSetDragHero = function(self)
  -- function num : 0_1 , upvalues : _ENV
  do
    if not self:__CheckAbleToDragHero() then
      local stateInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
      if stateInfoWin then
        stateInfoWin:ShowHero(self.dynHeroData)
      end
      return 
    end
    MsgCenter:Broadcast(eMsgEventId.OnTapSetTDRole)
    self:OnBeginDragHero()
  end
end

UINTDBattleHeroHeadItem.OnInitHeroItem = function(self, roleEntity, cost, onDragFunc, onClickHeroFunc, onChangePointDrag, onSetCurSelectItem)
  -- function num : 0_2 , upvalues : _ENV
  self.onDragFunc = onDragFunc
  self.onClickHeroFunc = onClickHeroFunc
  self.__onChangePointDrag = onChangePointDrag
  self.__onSetCurSelectItem = onSetCurSelectItem
  self.dataId = roleEntity.roleDataId
  self.roleEntity = roleEntity
  local stateInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if stateInfoWin then
    stateInfoWin:TowerPlacementChange(roleEntity.roleDataId, false)
  end
  local dynPlay = (BattleUtil.GetCurDynPlayer)()
  local dynHeroData = dynPlay:GetDynHeroByDataId(self.dataId)
  if dynHeroData ~= nil then
    (self.headItem):InitHeroHeadItem(dynHeroData.heroData)
  else
    error(" dynHeroData is NIL ")
    ;
    (self.headItem):InitHeroHeadItemWithId(self.dataId)
  end
  self.dynHeroData = dynHeroData
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_CostToken).text = tostring(cost)
  ;
  ((self.ui).returnCD):SetActive(false)
  self._cost = cost
end

UINTDBattleHeroHeadItem.__CheckAbleToDragHero = function(self)
  -- function num : 0_3 , upvalues : csBattleMgr, _ENV, CS_MessageCommon
  local csBattleCtrl = (csBattleMgr.Instance).CurBattleController
  if csBattleCtrl == nil then
    return false
  end
  if (csBattleCtrl.fsm):IsCurrentState((CS.eBattleState).Deploy) then
    return false
  end
  if csBattleCtrl.PlayerBattleRoleFull then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.MeetMaxStageRoleCountInTD))
    return false
  end
  local playerTDComp = (csBattleCtrl.PlayerController):GetTowerPlayerComponent()
  if playerTDComp == nil then
    return false
  end
  if playerTDComp.UITowerMp < self._cost then
    return false
  end
  return true
end

UINTDBattleHeroHeadItem.OnBeginDragHero = function(self, go, eventData)
  -- function num : 0_4
  if self.__onChangePointDrag ~= nil and eventData ~= nil then
    (self.__onChangePointDrag)(eventData)
  end
  if not self:__CheckAbleToDragHero() then
    return 
  end
  if self.__onSetCurSelectItem ~= nil then
    (self.__onSetCurSelectItem)(self)
  end
end

UINTDBattleHeroHeadItem.UpdateCd = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local curCd = (self.roleEntity):GetTDRoleCurCd()
  local totalCd = (self.roleEntity):GetTDRoleCastCd()
  local remainSec = (BattleUtil.FrameToTime)(totalCd - curCd)
  if remainSec > 0 then
    ((self.ui).returnCD):SetActive(true)
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_ReCD).text = tostring(remainSec)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).cDImage).fillAmount = (totalCd - curCd) / totalCd
  else
    ;
    ((self.ui).returnCD):SetActive(false)
  end
end

UINTDBattleHeroHeadItem.UpdateEnoughState = function(self, mp, isFull)
  -- function num : 0_6
  ((self.ui).notEnough):SetActive(mp >= self._cost and isFull)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINTDBattleHeroHeadItem.OnClickHeroHead = function(self)
  -- function num : 0_7
  if self.onClickHeroFunc ~= nil then
    (self.onClickHeroFunc)(self.roleEntity)
  end
end

return UINTDBattleHeroHeadItem

