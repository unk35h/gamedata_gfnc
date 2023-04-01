-- params : ...
-- function num : 0 , upvalues : _ENV
local UISpring23Story = class("UISpring23Story", UIBaseWindow)
local base = UIBaseWindow
local UINSpring23StoryMain = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryMain")
local UINSpring23StoryChar = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryChar")
local UINSpring23StoryPage = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryPage")
local UINSpring23StoryCharExtra = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryCharExtra")
local ActivitySpringStoryEnum = require("Game.ActivitySpring.Data.ActivitySpringStoryEnum")
local cs_ResLoader = CS.ResLoader
UISpring23Story.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23StoryPage, cs_ResLoader
  (UIUtil.SetTopStatus)(self, self.OnCloseSpring23Story)
  self._pagePool = (UIItemPool.New)(UINSpring23StoryPage, (self.ui).listItem)
  ;
  ((self.ui).listItem):SetActive(false)
  self._resloader = (cs_ResLoader.Create)()
  self.__OpenExtraCallback = BindCallback(self, self.__OpenExtra)
  self.__OnSelectPageCallback = BindCallback(self, self.__OnSelectPage)
  self.__OpenDetailCallback = BindCallback(self, self.__OpenDetail)
end

UISpring23Story.InitSpring23Story = function(self, springData, heroId, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._springStoryData = springData:GetSpringStoryData()
  self._callback = callback
  ;
  (self._pagePool):HideAll()
  for i = 1, 2 do
    local page = (self._pagePool):GetOne()
    local flag = true
    if i == 2 then
      flag = (self._springStoryData):IsSpringMaininteracterComplete()
    end
    page:InitSpring23StoryPage(i, flag, self.__OnSelectPageCallback)
  end
  ;
  ((((CS.UnityEngine).UI).LayoutRebuilder).ForceRebuildLayoutImmediate)((self.ui).story)
  self:__jumpWhenEnter(heroId)
end

UISpring23Story.__jumpWhenEnter = function(self, heroId)
  -- function num : 0_2 , upvalues : _ENV, ActivitySpringStoryEnum
  if heroId or 0 == 0 or not (self._springStoryData):IsSpringMaininteracterComplete() then
    self:__OnSelectPage(1, ((self._pagePool).listItem)[1])
    return 
  end
  local sideFinish = true
  local interactCfgs = (self._springStoryData):GetSpringStoryInteractCfg()
  for id,cfg in pairs(interactCfgs) do
    if cfg.interact_character == heroId and cfg.stage_id == (ActivitySpringStoryEnum.stageEnum).side and not (self._springStoryData):GetThisTalkStateById(id) then
      sideFinish = false
      break
    end
  end
  do
    self:__OnSelectPage(2, ((self._pagePool).listItem)[2])
    if sideFinish then
      (self._charWin):OnSpring23StoryShowExtra(heroId)
    end
  end
end

UISpring23Story.InitSpring23StoryReview = function(self, actId, callback)
  -- function num : 0_3 , upvalues : _ENV
  self._isReview = true
  self._actId = actId
  self._callback = callback
  ;
  (self._pagePool):HideAll()
  for i = 1, 2 do
    local page = (self._pagePool):GetOne()
    page:InitSpring23StoryPage(i, true, self.__OnSelectPageCallback)
  end
  ;
  ((((CS.UnityEngine).UI).LayoutRebuilder).ForceRebuildLayoutImmediate)((self.ui).story)
  self:__OnSelectPage(1, ((self._pagePool).listItem)[1])
end

UISpring23Story.__OnSelectPage = function(self, index, item)
  -- function num : 0_4 , upvalues : _ENV
  for i,v in ipairs((self._pagePool).listItem) do
    v:ActiveSpring23StoryPage(v == item)
  end
  ;
  ((self.ui).obj_Select):SetActive(true)
  local oldPos = (((self.ui).obj_Select).transform).position
  local parentPos = (item.transform).position
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).obj_Select).transform).position = (Vector3.New)(oldPos.x, parentPos.y, oldPos.z)
  if index == 1 then
    self:__EnterMain()
  else
    self:__EnterChar()
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UISpring23Story.__EnterMain = function(self)
  -- function num : 0_5 , upvalues : UINSpring23StoryMain
  if self._charWin ~= nil then
    (self._charWin):Hide()
  else
    ;
    ((self.ui).charStory):SetActive(false)
  end
  if self._mainWin == nil then
    self._mainWin = (UINSpring23StoryMain.New)()
    ;
    ((self.ui).mainStory):SetActive(true)
    ;
    (self._mainWin):Init((self.ui).mainStory)
    if self._isReview then
      (self._mainWin):InitSpring23StoryMainReview(self._actId, self._resloader, self.__OpenDetailCallback)
    else
      ;
      (self._mainWin):InitSpring23StoryMain(self._springStoryData, self._resloader, self.__OpenDetailCallback)
    end
  else
    ;
    (self._mainWin):Show()
  end
end

UISpring23Story.__EnterChar = function(self)
  -- function num : 0_6 , upvalues : UINSpring23StoryChar
  if self._mainWin ~= nil then
    (self._mainWin):Hide()
  else
    ;
    ((self.ui).mainStory):SetActive(false)
  end
  if self._charWin == nil then
    self._charWin = (UINSpring23StoryChar.New)()
    ;
    ((self.ui).charStory):SetActive(true)
    ;
    (self._charWin):Init((self.ui).charStory)
    if self._isReview then
      (self._charWin):InitSpring23StoryCharReview(self._actId, self._resloader, self.__OpenExtraCallback, self.__OpenDetailCallback)
    else
      ;
      (self._charWin):InitSpring23StoryChar(self._springStoryData, self._resloader, self.__OpenExtraCallback, self.__OpenDetailCallback)
    end
  else
    ;
    (self._charWin):Show()
  end
end

UISpring23Story.__OpenExtra = function(self, heroId, fixReward, ranReward)
  -- function num : 0_7 , upvalues : UINSpring23StoryCharExtra
  if self._isReview then
    return 
  end
  if self._extraWin == nil then
    self._extraWin = (UINSpring23StoryCharExtra.New)()
    ;
    ((self.ui).extraAwardWindow):SetActive(true)
    ;
    (self._extraWin):Init((self.ui).extraAwardWindow)
  else
    ;
    (self._extraWin):Show()
  end
  ;
  (self._extraWin):InitSpring23StoryCharExtra(self._springStoryData, heroId, fixReward, ranReward)
end

UISpring23Story.__OpenDetail = function(self, avgDetailData, item)
  -- function num : 0_8 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.AvgDetail, function(win)
    -- function num : 0_8_0 , upvalues : self, avgDetailData, item
    if win == nil then
      return 
    end
    local moveX, moveTime = win:GetAvgDetailDetailMoveWidthAndTime()
    self:__SetForAvgDetailData(avgDetailData, item, moveX, moveTime)
    win:InitAvgDetail(avgDetailData)
  end
)
end

UISpring23Story.__SetForAvgDetailData = function(self, avgDetailData, item, moveX, moveTime)
  -- function num : 0_9 , upvalues : _ENV
  if avgDetailData:GetAvgDetailCloseCallback() ~= nil then
    return 
  end
  local targetPointX = (((self.transform).sizeDelta).x - moveX) / 2
  local oriPoint = (self.transform):InverseTransformPoint((item.transform).position)
  moveX = (math.clamp)(oriPoint.x - targetPointX, 0, moveX)
  local SetAvgDetailCloseCallback = function()
    -- function num : 0_9_0 , upvalues : self, _ENV
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).detail).anchoredPosition = Vector2.zero
  end

  local SetAvgDetailOpenTweenBeginCallback = function()
    -- function num : 0_9_1 , upvalues : self, moveX, moveTime
    ((self.ui).detail):DOLocalMoveX(-moveX, moveTime)
  end

  local SetAvgDetailCloseTweenBeginCallback = function()
    -- function num : 0_9_2 , upvalues : self, moveTime
    ((self.ui).detail):DOLocalMoveX(0, moveTime)
  end

  avgDetailData:SetAvgDetailCloseCallback(SetAvgDetailCloseCallback)
  avgDetailData:SetAvgDetailOpenTweenBeginCallback(SetAvgDetailOpenTweenBeginCallback)
  avgDetailData:SetAvgDetailCloseTweenBeginCallback(SetAvgDetailCloseTweenBeginCallback)
  avgDetailData:SetAvgDetailCloseBgOpen(true)
end

UISpring23Story.OnCloseSpring23Story = function(self)
  -- function num : 0_10
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UISpring23Story.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base
  (self._resloader):Put2Pool()
  if self._charWin ~= nil then
    (self._charWin):Delete()
  end
  if self._mainWin ~= nil then
    (self._mainWin):Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UISpring23Story

