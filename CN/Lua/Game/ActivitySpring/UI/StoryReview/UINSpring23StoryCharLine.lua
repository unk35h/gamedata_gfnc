-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23StoryCharLine = class("UINSpring23StoryCharLine", UIBaseNode)
local base = UIBaseNode
local UINSpring23StoryCharItem = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryCharItem")
UINSpring23StoryCharLine.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23StoryCharItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).extraItem, self, self.OnClickExtra)
  self._itemPool = (UIItemPool.New)(UINSpring23StoryCharItem, (self.ui).awardItem)
  ;
  ((self.ui).awardItem):SetActive(false)
end

UINSpring23StoryCharLine.InitSpring23StoryCharLine = function(self, springStoryData, heroId, charCfgList, resloader, extraClickFunc, avgDetailCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._heroId = heroId
  self._extraClickFunc = extraClickFunc
  local heroCfg = (ConfigData.hero_data)[self._heroId]
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(heroCfg.name)
  ;
  (self._itemPool):HideAll()
  for i,cfg in ipairs(charCfgList) do
    local item = (self._itemPool):GetOne()
    if springStoryData ~= nil then
      item:InitSpring23StoryItem(springStoryData, cfg, resloader, avgDetailCallback)
    else
      item:InitSpring23StoryItemReview(cfg, resloader, avgDetailCallback)
    end
  end
  ;
  (((self.ui).extraItem).transform):SetAsLastSibling()
  ;
  (((self.ui).extraItem).gameObject):SetActive(springStoryData ~= nil)
  local markCfg = charCfgList[1]
  local interactInfoCfg = (ConfigData.activity_spring_interact_info)[markCfg.story]
  resloader:LoadABAssetAsync(PathConsts:GetCharacterPicPath(interactInfoCfg.character), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).heroPic).texture = texture
  end
)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINSpring23StoryCharLine.ResetSpring23StoryCharLineAniState = function(self)
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

UINSpring23StoryCharLine.SetSpring23StoryCharLineTween = function(self, delayTime, sequeceTween)
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

UINSpring23StoryCharLine.OnClickExtra = function(self)
  -- function num : 0_4
  if self._extraClickFunc ~= nil then
    (self._extraClickFunc)(self._heroId)
  end
end

return UINSpring23StoryCharLine

