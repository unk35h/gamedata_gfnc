-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23StoryMainLine = class("UINSpring23StoryMainLine", UIBaseNode)
local base = UIBaseNode
local UINSpring23StoryMainItem = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryMainItem")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
UINSpring23StoryMainLine.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23StoryMainItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINSpring23StoryMainItem, (self.ui).awardItem)
  ;
  ((self.ui).awardItem):SetActive(false)
end

UINSpring23StoryMainLine.InitSpring23StoryMainLine = function(self, springStoryData, mainStoryCfg, resloader, detailCallback)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  if mainStoryCfg.id < 10 then
    ((self.ui).tex_Num).text = "0" .. tostring(mainStoryCfg.id)
  else
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Num).text = tostring(mainStoryCfg.id)
  end
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(mainStoryCfg.name)
  ;
  (self._itemPool):HideAll()
  if (mainStoryCfg.interact_id)[1] ~= nil then
    for i,interactId in ipairs(mainStoryCfg.interact_id) do
      local interactCfg = ((ConfigData.activity_spring_interact)[mainStoryCfg.activity_id])[interactId]
      local item = (self._itemPool):GetOne()
      if springStoryData ~= nil then
        item:InitSpring23StoryItem(springStoryData, interactCfg, resloader, detailCallback)
      else
        item:InitSpring23StoryItemReview(interactCfg, resloader, detailCallback)
      end
    end
  else
    do
      local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
      local actFrameId = (((ConfigData.activity).actTypeMapping)[(ActivityFrameEnum.eActivityType).Spring])[mainStoryCfg.activity_id]
      local lobbyCfg = (ConfigData.activity_lobby)[actFrameId]
      local item = (self._itemPool):GetOne()
      if springStoryData ~= nil then
        item:InitSpring23StoryItemJustAvg(lobbyCfg.first_avg, resloader, detailCallback)
      else
        item:InitSpring23StoryItemJustAvgReview(lobbyCfg.first_avg, resloader, detailCallback)
      end
    end
  end
end

UINSpring23StoryMainLine.ResetSpring23StoryMainLineAniState = function(self)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).ani_root):Stop()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup_root).alpha = 0
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).detail).anchoredPosition = Vector2.zero
  for i,v in ipairs((self._itemPool).listItem) do
    v:ResetSpring23StoryItemAniState()
  end
end

UINSpring23StoryMainLine.SetSpring23StoryMainLineTween = function(self, delayTime, sequeceTween)
  -- function num : 0_3 , upvalues : _ENV
  sequeceTween:InsertCallback(delayTime, function()
    -- function num : 0_3_0 , upvalues : self
    ((self.ui).ani_root):Play()
  end
)
  sequeceTween:Insert(delayTime, ((((self.ui).detail):DOLocalMoveY(-50, 0.5)):From()):SetAutoKill(false))
  for i,v in ipairs((self._itemPool).listItem) do
    v:SetSpring23StoryItemTween(delayTime + (i - 1) * 0.1, sequeceTween)
  end
end

return UINSpring23StoryMainLine

