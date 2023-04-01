-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSum22DunRepeat = class("UIActSum22DunRepeat", UIBaseWindow)
local base = UIBaseWindow
local UIActSum22DunRepeatItem = require("Game.ActivitySummer.Year22.DunRepeat.UINActSum22DunRepeatItem")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UIActSum22DunRepeat.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UIActSum22DunRepeatItem
  (UIUtil.SetTopStatus)(self, self.OnCloseChallenge)
  self._itemPool = (UIItemPool.New)(UIActSum22DunRepeatItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).doubleBg, self, self.OnClickDoubleReward)
  ;
  (UIUtil.AddButtonListener)((self.ui).ticketItem, self, self.__OnClickTicketRes)
  self.__OnSelectChallengeCallback = BindCallback(self, self.__OnSelectChallenge)
  self.__RefreshCoinCallback = BindCallback(self, self.__RefreshCoin)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__RefreshCoinCallback)
  for k,anim in ipairs((self.ui).anim_iconList) do
    (anim:get_Item("UI_ActSum22DunRepeatIcon")).time = k * 0.75
  end
end

UIActSum22DunRepeat.InitSum22DunRepeat = function(self, sum22Data, callback)
  -- function num : 0_1 , upvalues : _ENV, cs_DoTween
  self._sum22Data = sum22Data
  self._callback = callback
  self._dungeonLevelDic = (self._sum22Data):GetSectorIIIDungeonInfo()
  ;
  ((self.ui).bg_animation):Play()
  local mainCfg = (self._sum22Data):GetSectorIIIMainCfg()
  self._showItemId = mainCfg.ticket_item
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).icon).sprite = CRH:GetSpriteByItemId(self._showItemId, true)
  self:__RefreshCoin()
  self:__RefreshDouble()
  self:__RefreshPointMultRate()
  self._showSe = ((cs_DoTween.Sequence)()):SetLink(self.gameObject)
  for k,lineImg in ipairs((self.ui).list_line) do
    local time = k * 0.05 + 0.5
    ;
    (self._showSe):Insert(time, ((lineImg.transform):DOScale(0, 0.33)):From())
    ;
    (self._showSe):Insert(time, (lineImg:DOFade(0, 0.22)):From())
  end
  ;
  (self._itemPool):HideAll()
  for _,dungeonlevel in pairs(self._dungeonLevelDic) do
    local item = (self._itemPool):GetOne()
    item:InitSum22ChallengeItem(dungeonlevel, self.__OnSelectChallengeCallback)
    local idx = dungeonlevel:GetDungeonIndex()
    local parentTr = ((self.ui).list_posTr)[idx]
    if parentTr == nil and isGameDev then
      error("没有这个副本的位置 " .. tostring(dungeonlevel:GetDungeonLevelStageId()))
    end
    ;
    (item.transform):SetParent(parentTr)
    -- DECOMPILER ERROR at PC105: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (item.transform).anchoredPosition = Vector2.zero
    local time = idx * 0.1 + 0.4
    local itemCg = item:GetSum22ChallengeItemCanvasGroup()
    ;
    (self._showSe):Insert(time, (itemCg:DOFade(0, 0.2)):From())
    ;
    (self._showSe):Insert(time, ((item.transform):DOAnchorPos((Vector2.Temp)(0, -10), 0.4)):From())
  end
end

UIActSum22DunRepeat.__RefreshCoin = function(self)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Point).text = tostring(PlayerDataCenter:GetItemCount(self._showItemId))
end

UIActSum22DunRepeat.__RefreshPointMultRate = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local pointMultRateDic = (self._sum22Data):GetSectorIII_PointMultRat()
  local poitId = (self._sum22Data):GetSectorIIIDunPointId()
  local multRata = pointMultRateDic[poitId] or 0
  local isHaveMultRate = multRata > 0
  ;
  ((self.ui).pointUpBg):SetActive(isHaveMultRate)
  if not isHaveMultRate then
    return 
  end
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_PointUp).text = (string.format)("+%s%%", GetPreciseDecimalStr(multRata / 10, 0))
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIActSum22DunRepeat.__RefreshDouble = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local rate = (self._sum22Data):GetSectorIII_EffiMultRate()
  local isCouldUsingMultEffi = rate > 0
  ;
  (((self.ui).doubleBg).gameObject):SetActive(isCouldUsingMultEffi)
  do
    if isCouldUsingMultEffi then
      local isUsingMultEffi = (self._sum22Data):SectorIII_IsFarmDouble()
      ;
      ((self.ui).img_Choose):SetActive(isUsingMultEffi)
      ;
      ((self.ui).tex_Additon):SetIndex(0, tostring(rate + 1))
    end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UIActSum22DunRepeat.OnClickDoubleReward = function(self)
  -- function num : 0_5
  local isUsingMultEffi = (self._sum22Data):SectorIII_IsFarmDouble()
  ;
  (self._sum22Data):SectorIII_SetFarmDouble(not isUsingMultEffi)
  self:__RefreshDouble()
end

UIActSum22DunRepeat.__OnSelectChallenge = function(self, dungenLevelData)
  -- function num : 0_6 , upvalues : _ENV
  local isLocked = not dungenLevelData:GetIsLevelUnlock()
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonLevelDetail, function(win)
    -- function num : 0_6_0 , upvalues : dungenLevelData, isLocked
    if win == nil then
      return 
    end
    win:InitDungeonLevelDetail(dungenLevelData, isLocked)
    win:SetDungeonLevelBgClose(true)
  end
)
end

UIActSum22DunRepeat.__OnClickTicketRes = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[(self._sum22Data):GetSectorIIIDunTicketId()]
  if itemCfg == nil then
    return 
  end
  local window = UIManager:ShowWindow(UIWindowTypeID.GlobalItemDetail)
  window:InitCommonItemDetail(itemCfg)
end

UIActSum22DunRepeat.OnCloseChallenge = function(self)
  -- function num : 0_8
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIActSum22DunRepeat.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__RefreshCoinCallback)
  UIManager:DeleteWindow(UIWindowTypeID.DungeonLevelDetail)
  ;
  (base.OnDelete)(self)
end

return UIActSum22DunRepeat

