-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23StoryCharExtra = class("UINSpring23StoryCharExtra", UIBaseNode)
local base = UIBaseNode
local UINSpring23StoryCharExtraItem = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryCharExtraItem")
UINSpring23StoryCharExtra.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23StoryCharExtraItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).finalItem, self, self.OnClickShowRewardDetail)
  self._itemPool = (UIItemPool.New)(UINSpring23StoryCharExtraItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  ;
  (((self.ui).finalItem).gameObject):SetActive(true)
end

UINSpring23StoryCharExtra.InitSpring23StoryCharExtra = function(self, springStoryData, heroId, fixCfgList, ranCfg)
  -- function num : 0_1 , upvalues : _ENV
  local heroCfg = (ConfigData.hero_data)[heroId]
  local finalItemId = (ranCfg.important_reward_ids)[1]
  self._finalItemCfg = (ConfigData.item)[finalItemId]
  ;
  ((self.ui).tex_Title):SetIndex(0, (LanguageUtil.GetLocaleText)(heroCfg.name))
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).img_Award).sprite = CRH:GetSpriteByItemId(finalItemId)
  ;
  (self._itemPool):HideAll()
  for i,v in ipairs(fixCfgList) do
    local item = (self._itemPool):GetOne()
    local flag = springStoryData:GetThisTalkStateById(v.id)
    item:InitSpring23StoryCharExtraItem(R16_PC42, i, flag)
  end
  ;
  (((self._itemPool).listItem)[#fixCfgList]):HideSpring23StoryCharExtraItemBar()
  ;
  (((self.ui).finalItem).transform):SetAsLastSibling()
  local pos = ((self.ui).rect).anchoredPosition
  pos.x = 0
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).rect).anchoredPosition = pos
end

UINSpring23StoryCharExtra.OnClickShowRewardDetail = function(self)
  -- function num : 0_2 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_2_0 , upvalues : self
    if win ~= nil then
      win:InitCommonItemDetail(self._finalItemCfg)
    end
  end
)
end

return UINSpring23StoryCharExtra

