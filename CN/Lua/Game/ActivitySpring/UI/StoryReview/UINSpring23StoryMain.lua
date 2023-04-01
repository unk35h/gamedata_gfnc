-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23StoryMain = class("UINSpring23StoryMain", UIBaseNode)
local base = UIBaseNode
local UINSpring23StoryMainLine = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryMainLine")
local CS_DOTween = ((CS.DG).Tweening).DOTween
UINSpring23StoryMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23StoryMainLine
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_rect, self, self.OnCliCkRect)
  self._itemPool = (UIItemPool.New)(UINSpring23StoryMainLine, (self.ui).mainStoryItem)
  ;
  ((self.ui).mainStoryItem):SetActive(false)
end

UINSpring23StoryMain.InitSpring23StoryMain = function(self, springStoryData, resloader, detailCallback)
  -- function num : 0_1
  local actId = springStoryData:GetSpringStoryActId()
  self:__Init(actId, springStoryData, resloader, detailCallback)
end

UINSpring23StoryMain.InitSpring23StoryMainReview = function(self, actId, resloader, detailCallback)
  -- function num : 0_2
  self:__Init(actId, nil, resloader, detailCallback)
end

UINSpring23StoryMain.__Init = function(self, actId, springStoryData, resloader, detailCallback)
  -- function num : 0_3 , upvalues : _ENV
  local cfgList = (ConfigData.activity_spring_main_story)[actId]
  ;
  (self._itemPool):HideAll()
  for i,v in ipairs(cfgList) do
    local item = (self._itemPool):GetOne()
    item:InitSpring23StoryMainLine(springStoryData, v, resloader, detailCallback)
  end
  self:__SetEnterTween()
end

UINSpring23StoryMain.OnCliCkRect = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if (UIUtil.CheckTopIsWindow)(UIWindowTypeID.AvgDetail) then
    (UIUtil.OnClickBack)()
  end
end

UINSpring23StoryMain.OnShow = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnShow)(self)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).btn_rect).transform).anchoredPosition = Vector2.zero
  if self._tween ~= nil then
    self:__SetEnterTween()
  end
end

UINSpring23StoryMain.__SetEnterTween = function(self)
  -- function num : 0_6 , upvalues : _ENV, CS_DOTween
  if self._tween ~= nil then
    (self._tween):Kill()
  end
  for i,v in ipairs((self._itemPool).listItem) do
    v:ResetSpring23StoryMainLineAniState()
  end
  self._tween = (CS_DOTween.Sequence)()
  for i,v in ipairs((self._itemPool).listItem) do
    v:SetSpring23StoryMainLineTween((i - 1) * 0.1, self._tween)
  end
  ;
  (self._tween):PlayForward()
end

UINSpring23StoryMain.__PlayEnterTween = function(self)
  -- function num : 0_7 , upvalues : _ENV
  for i,v in ipairs((self._itemPool).listItem) do
    v:ResetSpring23StoryMainLineAniState()
  end
  ;
  (self._tween):Restart()
  ;
  (self._tween):PlayForward()
end

UINSpring23StoryMain.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnDelete)(self)
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
end

return UINSpring23StoryMain

