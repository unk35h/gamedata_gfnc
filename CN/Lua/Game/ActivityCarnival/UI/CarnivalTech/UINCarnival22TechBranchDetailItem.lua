-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22TechBranchDetailItem = class("UINCarnival22TechBranchDetailItem", UIBaseNode)
local base = UIBaseNode
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
UINCarnival22TechBranchDetailItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._defalultDesColor = ((self.ui).tex_Des).color
end

UINCarnival22TechBranchDetailItem.InitBranchEft = function(self, actTechData)
  -- function num : 0_1 , upvalues : _ENV, CommonLogicUtil
  self._actTechData = actTechData
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (self._actTechData):GetAWTechName()
  local logicArray, para1Array, para2Array, para3Array = (self._actTechData):GetTechLogic(1)
  local intro = ""
  for index,logic in ipairs(logicArray) do
    local para1 = para1Array[index]
    local para2 = para2Array[index]
    local para3 = para3Array[index]
    local longDes, shortDes, valueDes = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3)
    if (string.IsNullOrEmpty)(intro) then
      intro = longDes
    else
      intro = intro .. "\n" .. longDes
    end
  end
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = intro
  self:RefreshBranchEft()
end

UINCarnival22TechBranchDetailItem.RefreshBranchEft = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isActive = (self._actTechData):GetCurLevel() > 0
  ;
  ((self.ui).obj_IsActive):SetActive(isActive)
  ;
  ((self.ui).obj_Locked):SetActive(not isActive)
  if not isActive then
    local preConditionList = (self._actTechData):GetAWTechUnlockInfo(1)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_locked).text = (preConditionList[1]).lockReason
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = (self.ui).color_locked_text
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Des).color = (self.ui).color_locked_text
  else
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R2 in 'UnsetPending'

    ((self.ui).tex_Name).color = Color.white
    -- DECOMPILER ERROR at PC47: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Des).color = self._defalultDesColor
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINCarnival22TechBranchDetailItem.RefreshBranchDetailItemReddot = function(self, flag)
  -- function num : 0_3
  ((self.ui).redDot):SetActive(flag)
end

UINCarnival22TechBranchDetailItem.GetBranchDetailItemId = function(self)
  -- function num : 0_4
  return (self._actTechData):GetTechId()
end

return UINCarnival22TechBranchDetailItem

