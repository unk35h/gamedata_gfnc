-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFlappyAwardPanel = class("UINFlappyAwardPanel", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINFlappyAwardPanel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.awardPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).obj_award)
end

UINFlappyAwardPanel.ShowAwardList = function(self, awardList, fbConfig, titleIndex)
  -- function num : 0_1 , upvalues : _ENV
  if fbConfig ~= nil then
    ((self.ui).text_title):SetIndex(titleIndex, tostring(fbConfig.join_rewards_score))
  else
    ;
    ((self.ui).text_title):SetIndex(titleIndex)
  end
  ;
  (self.awardPool):HideAll()
  if awardList == nil or #awardList <= 0 then
    return 
  end
  for _,v in ipairs(awardList) do
    local awardItem = (self.awardPool):GetOne()
    do
      local itemCfg = (ConfigData.item)[v.itemId]
      awardItem:InitItemWithCount(itemCfg, v.count, function()
    -- function num : 0_1_0 , upvalues : _ENV, itemCfg
    UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
      -- function num : 0_1_0_0 , upvalues : itemCfg
      if win ~= nil then
        win:SetNotNeedAnyJump(true)
        win:InitCommonItemDetail(itemCfg)
      end
    end
)
  end
)
    end
  end
end

UINFlappyAwardPanel.UpdatePosAndTips = function(self, progress, percent, totalWidth)
  -- function num : 0_2 , upvalues : _ENV
  local pos = ((self.ui).rectTrans).anchoredPosition
  pos.x = totalWidth * percent / 100
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).rectTrans).anchoredPosition = pos
  ;
  ((self.ui).tex_Rate):SetIndex(0, tostring(percent))
  if percent <= progress // 100 then
    ((self.ui).obj_isPicked):SetActive(true)
  end
end

UINFlappyAwardPanel.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINFlappyAwardPanel

