-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSpring23HardLevel = class("UIActSpring23HardLevel", UIBaseWindow)
local base = UIBaseWindow
local UIActSpring23HardLevelItem = require("Game.ActivitySpring.UI.HardLevel.UINActSpring23HardLevelItem")
local SpringHardLevelData = require("Game.ActivitySpring.Dungeon.SpringDungeonLevelData")
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
local eActInteract23Spring = require("Game.ActivityLobby.Activity.2023Spring.eActInteract")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UIActSpring23HardLevel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UIActSpring23HardLevelItem
  (UIUtil.SetTopStatus)(self, self.OnCloseChallenge)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rank, self, self.OnClickRank)
  self._itemPool = (UIItemPool.New)(UIActSpring23HardLevelItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  self.__OnSelectChallengeCallback = BindCallback(self, self.__OnSelectChallenge)
  self.__BackFromeDetailCallback = BindCallback(self, self.__BackFromeDetail)
end

UIActSpring23HardLevel.InitSpring23HardLevel = function(self, spring23Data, callback, delayEnterCallback)
  -- function num : 0_1 , upvalues : cs_DoTween, _ENV
  self._spring23Data = spring23Data
  self._callback = callback
  local levelTypeCfg = (self._spring23Data):GetSpringHardLevelCfg()
  local dungeonIdList = levelTypeCfg.dungeon_levels
  ;
  (self._itemPool):HideAll()
  if self._showSe ~= nil then
    (self._showSe):Kill()
    self._showSe = nil
  end
  self._showSe = (cs_DoTween.Sequence)()
  for index,dungeonId in pairs(dungeonIdList) do
    do
      ;
      (self._showSe):AppendInterval(index ~= 1 and 0.1 or 0)
      ;
      (self._showSe):AppendCallback(function()
    -- function num : 0_1_0 , upvalues : self, dungeonId, index
    local item = (self._itemPool):GetOne()
    item:InitSpring23ChallengeItem(self._spring23Data, dungeonId, index, self.__OnSelectChallengeCallback)
  end
)
    end
  end
  if delayEnterCallback ~= nil then
    local lengthTime = (((self.ui).ani_root).clip).length
    self._delayTimerId = TimerManager:StartTimer(lengthTime, delayEnterCallback, nil, true)
  end
end

UIActSpring23HardLevel.__OnSelectChallenge = function(self, dungeonId)
  -- function num : 0_2 , upvalues : _ENV, SpringHardLevelData
  if self._selectDungeonId == dungeonId then
    return 
  end
  self._selectDungeonId = dungeonId
  local clickFunc = function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    for i,item in ipairs((self._itemPool).listItem) do
      if self._selectDungeonId == item:GetSpringChallengeDungeonId() then
        (((self.ui).selected).gameObject):SetActive(true)
        ;
        ((self.ui).selected):SetParent(item.transform)
        -- DECOMPILER ERROR at PC25: Confused about usage of register: R5 in 'UnsetPending'

        ;
        ((self.ui).selected).anchoredPosition = Vector2.zero
        ;
        ((self.ui).selected):SetAsFirstSibling()
        local detailWin = UIManager:GetWindow(UIWindowTypeID.DungeonLevelDetail)
        local screenX = (UIManager.BackgroundStretchSize).x
        local index = (self._spring23Data):GetSpringChallengeDungeonIndex(self._selectDungeonId)
        local spacing = ((self.ui).horizontalLayout).spacing
        local itemOffset = (index - 1) * (((item.transform).sizeDelta).x + spacing)
        if spacing + ((item.transform).sizeDelta).x / 2 < itemOffset then
          itemOffset = itemOffset - spacing - ((item.transform).sizeDelta).x / 2
        end
        if index - 1 <= 0 or not itemOffset - (screenX / 2 - detailWin:GetDLevelDetailWidthAndDuration()) / 2 then
          do
            (((self.ui).list):DOAnchorPos((Vector2.Temp)(-(itemOffset), (((self.ui).list).anchoredPosition).y), 0.4)):SetLink(((self.ui).list).gameObject)
            do break end
            -- DECOMPILER ERROR at PC94: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC94: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC94: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC94: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end

  local window = UIManager:GetWindow(UIWindowTypeID.DungeonLevelDetail)
  if window == nil then
    UIManager:ShowWindowAsync(UIWindowTypeID.DungeonLevelDetail, function(win)
    -- function num : 0_2_1 , upvalues : SpringHardLevelData, self, clickFunc
    if win == nil then
      return 
    end
    local dungeonLevel = (SpringHardLevelData.New)(self._selectDungeonId)
    dungeonLevel:SetSpringLevelPic(((self._spring23Data):GetSpringHardLevelCfg()).pic_small)
    win:InitDungeonLevelDetail(dungeonLevel, false)
    win:SetDungeonLevelBgClose(true)
    win:SetDunLevelDetaiHideEndEvent(self.__BackFromeDetailCallback)
    clickFunc()
  end
)
  else
    window:Show()
    local dungeonLevel = (SpringHardLevelData.New)(self._selectDungeonId)
    dungeonLevel:SetSpringLevelPic(((self._spring23Data):GetSpringHardLevelCfg()).pic_small)
    window:InitDungeonLevelDetail(dungeonLevel, false)
    clickFunc()
  end
end

UIActSpring23HardLevel.OnClickRank = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonRank, function(rankWindow)
    -- function num : 0_3_0 , upvalues : self
    if rankWindow == nil then
      return 
    end
    rankWindow:InitCommonRank((self._spring23Data):GetRankId())
  end
)
end

UIActSpring23HardLevel.SetRankTex = function(self, myRank)
  -- function num : 0_4 , upvalues : _ENV
  local inRank = myRank and myRank.inRank or false
  if inRank then
    ((self.ui).tex_Rank):SetIndex(0, tostring(myRank.rankParam))
  else
    ;
    ((self.ui).tex_Rank):SetIndex(1)
  end
end

UIActSpring23HardLevel.__BackFromeDetail = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if IsNull(self.transform) then
    return 
  end
  self._selectDungeonId = nil
  ;
  (((self.ui).selected).gameObject):SetActive(false)
  ;
  (((self.ui).list):DOAnchorPos((Vector2.Temp)(0, (((self.ui).list).anchoredPosition).y), 0.4)):SetLink(((self.ui).list).gameObject)
end

UIActSpring23HardLevel.OnCloseChallenge = function(self)
  -- function num : 0_6
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIActSpring23HardLevel.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  UIManager:DeleteWindow(UIWindowTypeID.DungeonLevelDetail)
  if self._delayTimerId ~= nil then
    TimerManager:StopTimer(self._delayTimerId)
    self._delayTimerId = nil
  end
  if self._showSe ~= nil then
    (self._showSe):Kill()
  end
  ;
  (base.OnDelete)(self)
end

return UIActSpring23HardLevel

