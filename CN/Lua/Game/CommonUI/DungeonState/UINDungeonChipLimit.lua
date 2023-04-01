-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDungeonChipLimit = class("UINDungeonChipLimit", UIBaseNode)
local base = UIBaseNode
local CS_DOTween = ((CS.DG).Tweening).DOTween
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
UINDungeonChipLimit.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SellChip, self, self._OnSellChipClick)
  self.__onEpSceneStateChanged = BindCallback(self, self._OnEpSceneStateChanged)
  MsgCenter:AddListener(eMsgEventId.OnEpSceneStateChanged, self.__onEpSceneStateChanged)
  self:_InitChipLimitSequence()
end

UINDungeonChipLimit.InitDungeonChipLimit = function(self, chipLimitInfo)
  -- function num : 0_1 , upvalues : _ENV
  self.chipLimitInfo = chipLimitInfo
  self._isWeekly = ExplorationManager:GetIsInWeeklyChallenge()
  self._isTd = ExplorationManager:IsInTDExp()
  self._hasStore = (ExplorationManager.epCtrl ~= nil and ((ExplorationManager.epCtrl).residentStoreCtrl):HasEpResidentStore())
  self:RefreshSellButton()
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINDungeonChipLimit.RefreshSellButton = function(self, isGotoBattle)
  -- function num : 0_2 , upvalues : _ENV
  local tModel = false
  if self._isTd then
    tModel = self._hasStore
  end
  local cModel = false
  -- DECOMPILER ERROR at PC19: Unhandled construct in 'MakeBoolean' P1

  if self._isWeekly and isGotoBattle == nil then
    if self._hasStore then
      cModel = not ((ExplorationManager.epCtrl).sceneCtrl):InBattleScene()
      cModel = not isGotoBattle
      self.__tModel = tModel
      self.__cModel = cModel
      if not self.__tModel then
        local showSellBtn = self.__cModel
      end
      self:SetSellBtnActive(showSellBtn)
    end
  end
end

UINDungeonChipLimit.RefreshLimit = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local num = (self.chipLimitInfo).count
  local limit = (self.chipLimitInfo).limit
  ;
  ((self.ui).tex_LimitChip):SetIndex(0, tostring(num), tostring(limit))
  local isFirst = (self.chipLimitInfo).firstLimit
  local isLimit = limit < num
  ;
  ((self.ui).obj_limitBackground):SetActive(isLimit)
  ;
  ((self.ui).obj_Limit):SetActive(isLimit)
  if limit < num then
    if isFirst and self.chipLimitSequence ~= nil then
      (self.chipLimitSequence):PlayForward()
    end
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.chipLimitInfo).firstLimit = false
    return 
  end
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.chipLimitInfo).firstLimit = true
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINDungeonChipLimit._InitChipLimitSequence = function(self)
  -- function num : 0_4 , upvalues : _ENV, CS_DOTween
  local obj_Limit_SizeDelta = (((self.ui).obj_Limit).transform).sizeDelta
  local obj_chipCountLimit_SizeDelta = ((self.ui).tran_Anima).sizeDelta
  local small_Limit_SizeDelta = (Vector2.New)(0, obj_Limit_SizeDelta.y)
  local small_chipCountLimit_SizeDelta = (Vector2.New)(obj_chipCountLimit_SizeDelta.x - obj_Limit_SizeDelta.x, obj_chipCountLimit_SizeDelta.y)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).obj_Limit).transform).sizeDelta = small_Limit_SizeDelta
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tran_Anima).sizeDelta = small_chipCountLimit_SizeDelta
  if self.chipLimitSequence ~= nil then
    (self.chipLimitSequence):Kill()
    self.chipLimitSequence = nil
  end
  self.chipLimitSequence = ((((((((CS_DOTween.Sequence)()):Append((((self.ui).obj_Limit).transform):DOSizeDelta(obj_Limit_SizeDelta, 0.5))):Join(((self.ui).tran_Anima):DOSizeDelta(obj_chipCountLimit_SizeDelta, 0.5))):Append(((((self.ui).obj_Limit).transform):DOSizeDelta(small_Limit_SizeDelta, 0.5)):SetDelay(2.5))):Join(((self.ui).tran_Anima):DOSizeDelta(small_chipCountLimit_SizeDelta, 0.5))):AppendCallback(function()
    -- function num : 0_4_0 , upvalues : self
    (self.chipLimitSequence):Rewind()
  end
)):Pause()):SetAutoKill(false)
end

UINDungeonChipLimit._OnEpSceneStateChanged = function(self, epSceneState)
  -- function num : 0_5 , upvalues : ExplorationEnum
  local inTimeLine = epSceneState == (ExplorationEnum.eEpSceneState).InTimeline
  local inBattleScene = epSceneState == (ExplorationEnum.eEpSceneState).InBattleScene
  self:RefreshSellButton(inTimeLine or inBattleScene)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINDungeonChipLimit._OnSellChipClick = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local windows = UIManager:GetWindow(UIWindowTypeID.EpChallengeDiscard)
  if windows ~= nil then
    windows:CloseEpDiscard()
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EpChallengeDiscard, function(win)
    -- function num : 0_6_0 , upvalues : _ENV
    if win == nil then
      error("can\'t open EpChipDiscard UI")
      return 
    end
    win:InitEpChipDiscard((ExplorationManager:GetDynPlayer()), nil, true)
  end
)
end

UINDungeonChipLimit.SetSellBtnActive = function(self, active)
  -- function num : 0_7
  if not active then
    active = false
  end
  if not self.__tModel then
    local canSet = self.__cModel
  end
  if not canSet then
    (((self.ui).btn_SellChip).gameObject):SetActive(false)
    return 
  end
  if (((self.ui).btn_SellChip).gameObject).activeSelf == active then
    return 
  end
  ;
  (((self.ui).btn_SellChip).gameObject):SetActive(active)
end

UINDungeonChipLimit.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, base
  if self.chipLimitSequence ~= nil then
    (self.chipLimitSequence):Kill()
    self.chipLimitSequence = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.OnEpSceneStateChanged, self.__onEpSceneStateChanged)
  ;
  (base.OnDelete)(self)
end

return UINDungeonChipLimit

