-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonInfoDetail = class("UIDungeonInfoDetail", UIBaseWindow)
local base = UIBaseWindow
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local UINDungeonInfoChipDetail = require("Game.CommonUI.DungeonState.Info.UINDungeonInfoChipDetail")
local UINDungeonInfoHeroDetail = require("Game.CommonUI.DungeonState.Info.UINDungeonInfoHeroDetail")
local UINBattleGirdInfoNode = require("Game.Battle.UI.Grid.UINBattleGirdInfoNode")
local CS_ResLoader = CS.ResLoader
UIDungeonInfoDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : CS_ResLoader, UINDungeonInfoChipDetail, UINDungeonInfoHeroDetail, UINBattleGirdInfoNode, _ENV
  self.resloader = (CS_ResLoader.Create)()
  self.chipDetailNode = (UINDungeonInfoChipDetail.New)(self)
  ;
  (self.chipDetailNode):Init((self.ui).obj_chipDetail)
  ;
  (self.chipDetailNode):Hide()
  self.heroDetailNode = (UINDungeonInfoHeroDetail.New)()
  ;
  (self.heroDetailNode):Init((self.ui).obj_heroDetail)
  ;
  (self.heroDetailNode):Hide()
  self.battleGirdInfoNode = (UINBattleGirdInfoNode.New)()
  ;
  (self.battleGirdInfoNode):Init((self.ui).battleGirdInfoNode)
  self.isShowingChipDetail = false
  self.isShowingHeroDetail = false
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Retreat, self, self.OnClickRetreat)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickBlank)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Left, self, self.OnClickLeftButton)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Right, self, self.OnClickRightButton)
  ;
  ((self.ui).obj_DetailTips):SetActive(self.isShowingChipDetail)
  ;
  ((self.ui).activeAlgTitle):SetActive(false)
end

UIDungeonInfoDetail.ShowChipDetail = function(self, chipDataList, index, DeselectAllItemCallBack, SelectItemCallBack, isGainActiveAlg)
  -- function num : 0_1 , upvalues : _ENV
  if self.isShowingHeroDetail then
    self:OnClickRetreat()
    DeselectAllItemCallBack()
    return 
  end
  ;
  (self.chipDetailNode):InitChipInfo(chipDataList, index, isGainActiveAlg)
  ;
  (self.chipDetailNode):Show()
  ;
  (self.battleGirdInfoNode):Hide()
  self.deselectChipCallBack = DeselectAllItemCallBack
  self.SelectChipByIndexCallBack = SelectItemCallBack
  if not self.isShowingChipDetail then
    MsgCenter:Broadcast(eMsgEventId.OnDungeonDetailWinChange, true)
  end
  self.isShowingChipDetail = true
  if self.isShowingChipDetail then
    ((self.ui).obj_DetailTips):SetActive(not isGainActiveAlg)
    ;
    ((self.ui).activeAlgTitle):SetActive(isGainActiveAlg)
    if not self.SettedTopStatus then
      (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
      self.SettedTopStatus = true
    end
  end
end

UIDungeonInfoDetail.HideChipDetail = function(self)
  -- function num : 0_2
  self.isShowingChipDetail = false
  ;
  ((self.ui).obj_DetailTips):SetActive(self.isShowingChipDetail)
  ;
  ((self.ui).activeAlgTitle):SetActive(false)
  ;
  (self.chipDetailNode):Hide()
  if self.deselectChipCallBack ~= nil then
    (self.deselectChipCallBack)()
  end
end

UIDungeonInfoDetail.SwitchChip = function(self, bool)
  -- function num : 0_3
  local index = (self.chipDetailNode):SwitchChip(bool)
  ;
  (self.SelectChipByIndexCallBack)(index - 1)
end

UIDungeonInfoDetail.ShowHeroDetail = function(self, dynHeroData, deselectCallBack, switchBack)
  -- function num : 0_4
  if self.isShowingChipDetail then
    self:OnClickRetreat()
    deselectCallBack()
    return 
  end
  ;
  (self.heroDetailNode):InitHeroInfo(dynHeroData, self.resloader)
  ;
  (self.heroDetailNode):Show()
  self:__CommonShowHeroDetail(dynHeroData, deselectCallBack, switchBack)
end

UIDungeonInfoDetail.ShowHeroDetailInBattle = function(self, entity, deselectCallBack, switchBack)
  -- function num : 0_5
  if self.isShowingChipDetail then
    self:OnClickRetreat()
    deselectCallBack()
    return 
  end
  ;
  (self.heroDetailNode):InitHeroInfoInBattle(entity, self.resloader)
  ;
  (self.heroDetailNode):Show()
  self:__CommonShowHeroDetail(entity.character, deselectCallBack, switchBack)
end

UIDungeonInfoDetail.__CommonShowHeroDetail = function(self, dynHeroData, deselectCallBack, switchBack)
  -- function num : 0_6 , upvalues : _ENV
  AudioManager:PlayAudioById(1080)
  self:__ShowHeroEffctGrid(dynHeroData)
  self.deselectHeroCallBack = deselectCallBack
  self.switchHeroCallBack = switchBack
  if not self.isShowingHeroDetail then
    MsgCenter:Broadcast(eMsgEventId.OnDungeonDetailWinChange, true)
    if not self.SettedTopStatus then
      (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
      self.SettedTopStatus = true
    end
  end
  self.isShowingHeroDetail = true
end

UIDungeonInfoDetail.HideHeroDetail = function(self)
  -- function num : 0_7
  (self.heroDetailNode):Hide()
  self.isShowingHeroDetail = false
  if self.deselectHeroCallBack ~= nil then
    (self.deselectHeroCallBack)()
  end
end

UIDungeonInfoDetail.SwitchHero = function(self, bool)
  -- function num : 0_8
  (self.switchHeroCallBack)(bool)
end

UIDungeonInfoDetail.__ShowHeroEffctGrid = function(self, dynHeroData)
  -- function num : 0_9 , upvalues : _ENV
  local needShowGridInfo = false
  if ((CS.BattleManager).Instance).IsInBattle then
    local battleCtrl = ((CS.BattleManager).Instance).CurBattleController
    local effectGrid = (battleCtrl.EfcGridController):GetHeroEffectGrid(dynHeroData.dataId)
    if effectGrid ~= nil then
      needShowGridInfo = true
      ;
      (self.battleGirdInfoNode):InitBattleGridInfo(effectGrid.gridData)
    end
  end
  do
    if needShowGridInfo then
      (self.battleGirdInfoNode):Show()
    else
      ;
      (self.battleGirdInfoNode):Hide()
    end
  end
end

UIDungeonInfoDetail.BackAction = function(self)
  -- function num : 0_10 , upvalues : _ENV
  self.SettedTopStatus = false
  self:HideChipDetail()
  self:HideHeroDetail()
  self:Hide()
  MsgCenter:Broadcast(eMsgEventId.OnDungeonDetailWinChange, false)
  self.deselectChipCallBack = nil
  self.SelectChipByIndexCallBack = nil
  self:__ReshowLastCharacterInfoBtn()
end

UIDungeonInfoDetail.OnClickRetreat = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self.SettedTopStatus then
    (UIUtil.OnClickBack)()
  end
end

UIDungeonInfoDetail.__ReshowLastCharacterInfoBtn = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local characterInfoUI = UIManager:GetWindow(UIWindowTypeID.TDCharactorInfo)
  if characterInfoUI ~= nil and characterInfoUI.active then
    (characterInfoUI.gameObject):SetActive(true)
  end
end

UIDungeonInfoDetail.OnClickBlank = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if self.SettedTopStatus then
    (UIUtil.OnClickBack)()
  end
end

UIDungeonInfoDetail.OnClickLeftButton = function(self)
  -- function num : 0_14
  if self.isShowingChipDetail then
    self:SwitchChip(false)
  end
  if self.isShowingHeroDetail then
    self:SwitchHero(false)
  end
end

UIDungeonInfoDetail.OnClickRightButton = function(self)
  -- function num : 0_15
  if self.isShowingChipDetail then
    self:SwitchChip(true)
  end
  if self.isShowingHeroDetail then
    self:SwitchHero(true)
  end
end

UIDungeonInfoDetail.SetSwitchBtnActive = function(self, active)
  -- function num : 0_16
  (((self.ui).btn_Left).gameObject):SetActive(active)
  ;
  (((self.ui).btn_Right).gameObject):SetActive(active)
end

UIDungeonInfoDetail.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  (self.chipDetailNode):Delete()
  ;
  (self.resloader):Put2Pool()
  self.resloader = nil
  ;
  (base.OnDelete)(self)
end

return UIDungeonInfoDetail

