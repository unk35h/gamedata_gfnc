-- params : ...
-- function num : 0 , upvalues : _ENV
local UINUnlockedTechLine = class("UINUnlockedTechLine", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
UINUnlockedTechLine.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AvgItem, self, self.OnClickTechAvgBtn)
end

UINUnlockedTechLine.RefreshRowItem = function(self, SectorIIData, lineData, resLoader)
  -- function num : 0_1
  self.sectorIIData = SectorIIData
  self.lineData = lineData
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).text_name).text = lineData:GetRowName()
  self:RefreshRowTechAvg()
end

UINUnlockedTechLine.RefreshRowTechAvg = function(self)
  -- function num : 0_2
  local isHaveAvg = (self.lineData):GetIsHaveTechAvg()
  ;
  (((self.ui).btn_AvgItem).gameObject):SetActive(isHaveAvg)
  ;
  ((self.ui).obj_lineAvg2Tech):SetActive(isHaveAvg)
  if not isHaveAvg then
    return 
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_chapter).text = (self.lineData):GetIsTechAvgName()
  local isUnlock = (self.lineData):GetIsTechAvgUnlock()
  local isComplete = (self.lineData):GetIsTechAvgCompleted()
  ;
  ((self.ui).obj_AvgLock):SetActive(not isUnlock)
  ;
  ((self.ui).obj_AvgComplete):SetActive(isComplete)
  if isUnlock then
    ((self.ui).Obj_AvgBlueDot):SetActive(not isComplete)
  end
end

UINUnlockedTechLine.OnClickTechAvgBtn = function(self)
  -- function num : 0_3 , upvalues : cs_MessageCommon, _ENV
  do
    if not (self.lineData):GetIsTechAvgUnlock() then
      local unlockCondition = (self.lineData):GetTechAvgUnlockInfo()
      ;
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(unlockCondition)
      return 
    end
    local avgCfg = (self.lineData):GetIsTechAvgCfg()
    ;
    (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(avgCfg.script_id, avgCfg.id, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    (AvgUtil.ShowMainCamera)(true)
    ;
    (self.lineData):RefreshTechAvgState()
    self:RefreshRowTechAvg()
    ;
    (self.sectorIIData):RefreshSectorIIReddot4TechAvg()
  end
)
    ;
    (AvgUtil.ShowMainCamera)(false)
  end
end

UINUnlockedTechLine.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINUnlockedTechLine

