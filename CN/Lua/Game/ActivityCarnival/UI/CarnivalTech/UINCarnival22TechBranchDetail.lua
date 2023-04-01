-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22TechBranchDetail = class("UINCarnival22TechBranchDetail", UIBaseNode)
local base = UIBaseNode
local UINCarnival22TechBranchDetailItem = require("Game.ActivityCarnival.UI.CarnivalTech.UINCarnival22TechBranchDetailItem")
local ActivityCarnivalEnum = require("Game.ActivityCarnival.ActivityCarnivalEnum")
UINCarnival22TechBranchDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCarnival22TechBranchDetailItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BG, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reset, self, self.OnClickReset)
  self._itemPool = (UIItemPool.New)(UINCarnival22TechBranchDetailItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  self._colorGray = ((self.ui).img_resetBottom).color
end

UINCarnival22TechBranchDetail.InitBranchDetail = function(self, carnivalData, branchId, resetFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._carnivalData = carnivalData
  self._branchId = branchId
  self._resetFunc = resetFunc
  local techDic = ((self._carnivalData):GetCarnivalTech())[self._branchId]
  ;
  (self._itemPool):HideAll()
  local techList = {}
  for _,techData in pairs(techDic) do
    if techData:IsActTechAutoUnlock() then
      (table.insert)(techList, techData)
    end
  end
  ;
  (table.sort)(techList, function(a, b)
    -- function num : 0_1_0
    do return a:GetTechId() < b:GetTechId() end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  for _,techData in ipairs(techList) do
    local item = (self._itemPool):GetOne()
    item:InitBranchEft(techData)
  end
  local techType = (self._carnivalData):GetCarnivalTechType()
  self.branchCfg = ((ConfigData.activity_tech_branch)[techType])[branchId]
  -- DECOMPILER ERROR at PC59: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_TitleCN).text = (LanguageUtil.GetLocaleText)((self.branchCfg).branch_name)
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_TitleEN).text = (self.branchCfg).branch_name_en
  -- DECOMPILER ERROR at PC72: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_cost).text = tostring(((self.branchCfg).revertCostNums)[1])
  -- DECOMPILER ERROR at PC82: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).icon_cost).sprite = CRH:GetSpriteByItemId(((self.branchCfg).revertCostIds)[1], true)
  self:__RefreshLevelState()
  self:__RefreshCost()
  self:__RefreshReddot()
end

UINCarnival22TechBranchDetail.__RefreshCost = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,itemId in ipairs((self.branchCfg).revertCostIds) do
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

    if PlayerDataCenter:GetItemCount(itemId) < ((self.branchCfg).revertCostNums)[i] then
      ((self.ui).tex_cost).color = Color.red
      -- DECOMPILER ERROR at PC23: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self.ui).img_resetBottom).color = (self.ui).color_gray
      return 
    end
  end
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_cost).color = Color.white
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_resetBottom).color = self._colorGray
end

UINCarnival22TechBranchDetail.RefreshBranchDetail = function(self)
  -- function num : 0_3 , upvalues : _ENV
  for _,techItem in ipairs((self._itemPool).listItem) do
    techItem:RefreshBranchEft()
  end
  self:__RefreshLevelState()
  self:__RefreshCost()
  self:__RefreshReddot()
end

UINCarnival22TechBranchDetail.__RefreshLevelState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local techDic = ((self._carnivalData):GetCarnivalTech())[self._branchId]
  local curLevel = 0
  local totalLevel = 0
  for _,techData in pairs(techDic) do
    if not techData:IsActTechAutoUnlock() then
      curLevel = curLevel + techData:GetCurLevel()
      totalLevel = totalLevel + techData:GetMaxLevel()
    end
  end
  ;
  ((self.ui).tex_Level):SetIndex(0, tostring(curLevel), tostring(totalLevel))
  self._curLevel = curLevel
end

UINCarnival22TechBranchDetail.__RefreshReddot = function(self)
  -- function num : 0_5 , upvalues : ActivityCarnivalEnum, _ENV
  local reddot = (self._carnivalData):GetActivityReddot()
  if reddot ~= nil then
    reddot = reddot:GetChild((ActivityCarnivalEnum.eActivityCarnivalReddot).AutoTech)
    if reddot ~= nil then
      reddot = reddot:GetChild(self._branchId)
    end
  end
  if reddot == nil then
    for i,v in ipairs((self._itemPool).listItem) do
      v:RefreshBranchDetailItemReddot(false)
    end
    return 
  end
  for i,v in ipairs((self._itemPool).listItem) do
    local childReddot = reddot:GetChild(v:GetBranchDetailItemId())
    v:RefreshBranchDetailItemReddot(childReddot ~= nil and childReddot:GetRedDotCount() > 0)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINCarnival22TechBranchDetail.OnClickReset = function(self)
  -- function num : 0_6
  if self._curLevel == 0 then
    return 
  end
  if self._resetFunc ~= nil then
    (self._resetFunc)(self._branchId)
  end
end

UINCarnival22TechBranchDetail.OnHide = function(self)
  -- function num : 0_7 , upvalues : ActivityCarnivalEnum, base
  local reddot = (self._carnivalData):GetActivityReddot()
  if reddot ~= nil then
    reddot = reddot:GetChild((ActivityCarnivalEnum.eActivityCarnivalReddot).AutoTech)
    if reddot ~= nil then
      reddot:RemoveChild(self._branchId)
    end
  end
  ;
  (base.OnHide)(self)
end

return UINCarnival22TechBranchDetail

