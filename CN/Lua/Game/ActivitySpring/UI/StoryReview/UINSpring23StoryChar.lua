-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23StoryChar = class("UINSpring23StoryChar", UIBaseNode)
local base = UIBaseNode
local UINSpring23StoryCharLine = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryCharLine")
local ActivitySpringStoryEnum = require("Game.ActivitySpring.Data.ActivitySpringStoryEnum")
local CS_DOTween = ((CS.DG).Tweening).DOTween
UINSpring23StoryChar.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23StoryCharLine
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_rect, self, self.OnCliCkRect)
  self._itemPool = (UIItemPool.New)(UINSpring23StoryCharLine, (self.ui).charStoryItem)
  ;
  ((self.ui).charStoryItem):SetActive(false)
  self.__OnShowExtraCallback = BindCallback(self, self.OnSpring23StoryShowExtra)
end

UINSpring23StoryChar.InitSpring23StoryChar = function(self, springStoryData, resloader, extraClickFunc, avgDetailCallback)
  -- function num : 0_1
  local actId = springStoryData:GetSpringStoryActId()
  self:__Init(actId, springStoryData, resloader, extraClickFunc, avgDetailCallback)
end

UINSpring23StoryChar.InitSpring23StoryCharReview = function(self, actId, resloader, extraClickFunc, avgDetailCallback)
  -- function num : 0_2
  self:__Init(actId, nil, resloader, extraClickFunc, avgDetailCallback)
end

UINSpring23StoryChar.__Init = function(self, actId, springStoryData, resloader, extraClickFunc, avgDetailCallback)
  -- function num : 0_3 , upvalues : _ENV
  self._extraClickFunc = extraClickFunc
  local storyCfg = (ConfigData.activity_spring_interact)[actId]
  self._heroStoryData = {}
  self._heroSort = {}
  for k,v in pairs(storyCfg) do
    self:__AddheroTable(v)
  end
  self:__SortHeroTable()
  ;
  (self._itemPool):HideAll()
  for i,heroId in ipairs(self._heroSort) do
    local item = (self._itemPool):GetOne()
    item:InitSpring23StoryCharLine(springStoryData, heroId, ((self._heroStoryData)[heroId]).side, resloader, self.__OnShowExtraCallback, avgDetailCallback)
  end
  self:__SetEnterTween()
end

UINSpring23StoryChar.__AddheroTable = function(self, interactCfg)
  -- function num : 0_4 , upvalues : ActivitySpringStoryEnum, _ENV
  local heroId = interactCfg.interact_character
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  if (self._heroStoryData)[heroId] == nil then
    (self._heroStoryData)[heroId] = {
side = {}
, 
fixReward = {}
, ranReward = nil}
  end
  if interactCfg.stage_id == (ActivitySpringStoryEnum.stageEnum).side then
    (table.insert)(((self._heroStoryData)[heroId]).side, interactCfg)
  else
    if interactCfg.stage_id == (ActivitySpringStoryEnum.stageEnum).fixReward then
      (table.insert)(((self._heroStoryData)[heroId]).fixReward, interactCfg)
    else
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R3 in 'UnsetPending'

      if interactCfg.stage_id == (ActivitySpringStoryEnum.stageEnum).ranReward then
        ((self._heroStoryData)[heroId]).ranReward = interactCfg
      end
    end
  end
end

UINSpring23StoryChar.__SortHeroTable = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local heroWeight = {}
  for k,v in pairs(self._heroStoryData) do
    (table.sort)(v.side, function(a, b)
    -- function num : 0_5_0
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
    ;
    (table.sort)(v.fixReward, function(a, b)
    -- function num : 0_5_1
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
    ;
    (table.insert)(self._heroSort, k)
    heroWeight[k] = ((v.side)[1]).id
  end
  ;
  (table.sort)(self._heroSort, function(a, b)
    -- function num : 0_5_2 , upvalues : heroWeight
    do return heroWeight[a] < heroWeight[b] end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
end

UINSpring23StoryChar.OnShow = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnShow)(self)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).btn_rect).transform).anchoredPosition = Vector2.zero
  if self._tween ~= nil then
    self:__SetEnterTween()
  end
end

UINSpring23StoryChar.__SetEnterTween = function(self)
  -- function num : 0_7 , upvalues : _ENV, CS_DOTween
  if self._tween ~= nil then
    (self._tween):Kill()
  end
  for i,v in ipairs((self._itemPool).listItem) do
    v:ResetSpring23StoryCharLineAniState()
  end
  self._tween = (CS_DOTween.Sequence)()
  for i,v in ipairs((self._itemPool).listItem) do
    v:SetSpring23StoryCharLineTween((i - 1) * 0.1, self._tween)
  end
  ;
  (self._tween):PlayForward()
end

UINSpring23StoryChar.__PlayEnterTween = function(self)
  -- function num : 0_8 , upvalues : _ENV
  for i,v in ipairs((self._itemPool).listItem) do
    v:ResetSpring23StoryCharLineAniState()
  end
  ;
  (self._tween):Restart()
  ;
  (self._tween):PlayForward()
end

UINSpring23StoryChar.OnSpring23StoryShowExtra = function(self, heroId)
  -- function num : 0_9
  if self._extraClickFunc ~= nil then
    local heroStory = (self._heroStoryData)[heroId]
    ;
    (self._extraClickFunc)(heroId, heroStory.fixReward, heroStory.ranReward)
  end
end

UINSpring23StoryChar.OnCliCkRect = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if (UIUtil.CheckTopIsWindow)(UIWindowTypeID.AvgDetail) then
    (UIUtil.OnClickBackByUiTab)(self)
  end
end

UINSpring23StoryChar.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnDelete)(self)
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
end

return UINSpring23StoryChar

