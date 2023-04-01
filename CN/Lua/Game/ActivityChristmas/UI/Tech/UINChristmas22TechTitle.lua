-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22TechTitle = class("UINChristmas22TechTitle", UIBaseNode)
local base = UIBaseNode
UINChristmas22TechTitle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Check, self, self.OnClickTitle)
end

UINChristmas22TechTitle.InitChristmas22TechTitle = function(self, actTechTree, branchId, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = actTechTree
  self._branchId = branchId
  self._callback = callback
  local techType = (self._data):GetTreeId()
  local branchCfg = ((ConfigData.activity_tech_branch)[techType])[self._branchId]
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_TitleCN).text = (LanguageUtil.GetLocaleText)(branchCfg.branch_name)
  self:RefreshChristmas22TechTitle()
end

UINChristmas22TechTitle.RefreshChristmas22TechTitle = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local techTypeDic = (self._data):GetTechDataDic()
  local techDic = techTypeDic[self._branchId]
  local curLevel = 0
  local totalLevel = 0
  for _,techData in pairs(techDic) do
    if not techData:IsActTechAutoUnlock() then
      curLevel = curLevel + techData:GetCurLevel()
      totalLevel = totalLevel + techData:GetMaxLevel()
    end
  end
  ;
  ((self.ui).tex_Count):SetIndex(0, tostring(curLevel), tostring(totalLevel))
end

UINChristmas22TechTitle.OnClickTitle = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._branchId)
  end
end

return UINChristmas22TechTitle

