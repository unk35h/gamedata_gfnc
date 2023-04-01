-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActXMas22DunRepeat = class("UIActXMas22DunRepeat", UIBaseWindow)
local base = UIBaseWindow
local UIActXMas22DunRepeatItem = require("Game.ActivityChristmas.UI.DunRepeat.UINActXMas22DunRepeatItem")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UIActXMas22DunRepeat.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UIActXMas22DunRepeatItem
  (UIUtil.SetTopStatus)(self, self.OnCloseChallenge, {ConstGlobalItem.SKey})
  self._itemPool = (UIItemPool.New)(UIActXMas22DunRepeatItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  self.__OnSelectChallengeCallback = BindCallback(self, self.__OnSelectChallenge)
end

UIActXMas22DunRepeat.InitXMas22DunRepeat = function(self, xMas22Data, callback, delayEnterCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._xMas22Data = xMas22Data
  self._callback = callback
  self._dungeonLevelDic = (self._xMas22Data):GetSeasonDungeonInfo()
  self._starList = {}
  ;
  (self._itemPool):HideAll()
  local allNum = 0
  local unlockNum = 0
  for _,dungeonlevel in pairs(self._dungeonLevelDic) do
    local item = (self._itemPool):GetOne()
    item:InitXMas22ChallengeItem(dungeonlevel, self.__OnSelectChallengeCallback)
    local idx = dungeonlevel:GetDungeonIndex()
    ;
    (item.transform):SetParent(((self.ui).posList)[idx])
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R13 in 'UnsetPending'

    ;
    (item.transform).anchoredPosition = Vector2.zero
    allNum = allNum + 1
    local isLocked = not dungeonlevel:GetIsLevelUnlock()
    if not isLocked then
      unlockNum = (math.max)(idx, unlockNum)
    end
  end
  for i = 1, allNum do
    local isLocked = unlockNum < i
    local star = ((self.ui).obj_star):Instantiate(((self.ui).main).transform)
    if not isLocked or not (self.ui).starDarkColor then
      (star:GetComponent(typeof(((CS.UnityEngine).UI).Image))).color = (self.ui).starWhiteColor
      star:SetActive(true)
      -- DECOMPILER ERROR at PC97: Confused about usage of register: R12 in 'UnsetPending'

      ;
      (star.transform).anchoredPosition = (Vector2.New)(((((self.ui).posList)[i]).anchoredPosition).x, ((star.transform).anchoredPosition).y)
      ;
      (table.insert)(self._starList, star)
      if i > 1 and not isLocked then
        local note = ((self.ui).obj_note):Instantiate(((self.ui).main).transform)
        note:SetActive(true)
        local posX = (((((self.ui).posList)[i]).anchoredPosition).x - ((((self.ui).posList)[i - 1]).anchoredPosition).x) / 2 + ((((self.ui).posList)[i - 1]).anchoredPosition).x
        local posY = ((star.transform).anchoredPosition).y + (i % 2 == 0 and 12 or -8)
        -- DECOMPILER ERROR at PC154: Confused about usage of register: R15 in 'UnsetPending'

        ;
        (note.transform).anchoredPosition = (Vector2.New)(posX, posY)
      end
      -- DECOMPILER ERROR at PC155: LeaveBlock: unexpected jumping out IF_THEN_STMT

      -- DECOMPILER ERROR at PC155: LeaveBlock: unexpected jumping out IF_STMT

    end
  end
  local fillNum = 0.142 + (unlockNum - 1) * 0.179
  if fillNum > 0.85 then
    fillNum = 1
    ;
    ((self.ui).obj_img_MaxLine):SetActive(true)
  else
    ((self.ui).obj_img_MaxLine):SetActive(false)
  end
  -- DECOMPILER ERROR at PC175: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).fill).fillAmount = fillNum
  do
    if delayEnterCallback ~= nil then
      local lengthTime = (((self.ui).ani_root).clip).length
      self._delayTimerId = TimerManager:StartTimer(lengthTime, delayEnterCallback, nil, true)
    end
    -- DECOMPILER ERROR: 9 unprocessed JMP targets
  end
end

UIActXMas22DunRepeat.__OnSelectChallenge = function(self, dungenLevelData)
  -- function num : 0_2 , upvalues : _ENV
  local isLocked = not dungenLevelData:GetIsLevelUnlock()
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonLevelDetail, function(win)
    -- function num : 0_2_0 , upvalues : dungenLevelData, isLocked
    if win == nil then
      return 
    end
    win:InitDungeonLevelDetail(dungenLevelData, isLocked)
    win:SetDungeonLevelBgClose(true)
  end
)
end

UIActXMas22DunRepeat.OnCloseChallenge = function(self)
  -- function num : 0_3
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIActXMas22DunRepeat.OnDelete = function(self)
  -- function num : 0_4 , upvalues : _ENV, base
  UIManager:DeleteWindow(UIWindowTypeID.DungeonLevelDetail)
  if self._delayTimerId ~= nil then
    TimerManager:StopTimer(self._delayTimerId)
    self._delayTimerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIActXMas22DunRepeat

