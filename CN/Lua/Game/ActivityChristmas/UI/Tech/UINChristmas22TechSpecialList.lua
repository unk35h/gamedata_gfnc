-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22TechSpecialList = class("UINChristmas22TechSpecialList", UIBaseNode)
local base = UIBaseNode
local UINChristmas22TechSpecialItem = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechSpecialItem")
UINChristmas22TechSpecialList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINChristmas22TechSpecialItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).closeBg, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.Hide)
  self._itemPool = (UIItemPool.New)(UINChristmas22TechSpecialItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
end

UINChristmas22TechSpecialList.SetChristmas22LogicDesType = function(self, desType)
  -- function num : 0_1
  self._desType = desType
end

UINChristmas22TechSpecialList.InitChristmas22TechSpecialList = function(self, actTechTree, specialBranchId, resloader, callback)
  -- function num : 0_2 , upvalues : _ENV
  local techDic = (actTechTree:GetTechDataDic())[specialBranchId]
  if techDic == nil then
    error("tech list error")
    return 
  end
  local techList = {}
  for k,techData in pairs(techDic) do
    (table.insert)(techList, techData)
  end
  ;
  (table.sort)(techList, function(a, b)
    -- function num : 0_2_0
    do return a:GetTechId() < b:GetTechId() end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  ;
  (self._itemPool):HideAll()
  for i,techData in ipairs(techList) do
    local item = (self._itemPool):GetOne()
    item:SetChristmas22LogicDesType(self._desType)
    item:InitChristmas22TechSpecialItem(techData, resloader, callback)
  end
end

UINChristmas22TechSpecialList.RefreshChristmas22TechSpecialList = function(self)
  -- function num : 0_3 , upvalues : _ENV
  for i,v in ipairs((self._itemPool).listItem) do
    v:RefreshChristmas22TechSpecialItem()
  end
end

return UINChristmas22TechSpecialList

