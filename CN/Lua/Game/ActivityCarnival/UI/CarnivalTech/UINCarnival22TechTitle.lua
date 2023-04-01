-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22TechTitle = class("UINCarnival22TechTitle", UIBaseNode)
local base = UIBaseNode
UINCarnival22TechTitle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Check, self, self.OnClickBranch)
end

UINCarnival22TechTitle.InitCarnivalTechTitle = function(self, carnivalData, branchId, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._carnivalData = carnivalData
  self._branchId = branchId
  self._callback = callback
  local techType = (self._carnivalData):GetCarnivalTechType()
  local branchCfg = ((ConfigData.activity_tech_branch)[techType])[self._branchId]
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_TitleCN).text = (LanguageUtil.GetLocaleText)(branchCfg.branch_name)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_TitleEN).text = branchCfg.branch_name_en
  self:RefreshCarnivalTechTitle()
end

UINCarnival22TechTitle.RefreshCarnivalTechTitle = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local techTypeDic = (self._carnivalData):GetCarnivalTech()
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

UINCarnival22TechTitle.SetCarnivalBranchReddot = function(self, flag)
  -- function num : 0_3
  ((self.ui).redDot):SetActive(flag)
end

UINCarnival22TechTitle.GetCarnivalBranchId = function(self)
  -- function num : 0_4
  return self._branchId
end

UINCarnival22TechTitle.OnClickBranch = function(self)
  -- function num : 0_5
  if self._callback ~= nil then
    (self._callback)(self._branchId)
  end
end

return UINCarnival22TechTitle

