-- params : ...
-- function num : 0 , upvalues : _ENV
local PlayerBonusElem = class("PlayerBonusElem")
local InitFunc1Para = function(self)
  -- function num : 0_0
  self.totalData = 0
end

local InitFunc2Para = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.totalData = (table.GetDefaulValueTable)(0)
end

local InitFunc3Para = function(self)
  -- function num : 0_2
  self.totalData = {}
end

local InitFuncDic = {[eLogicType.ResourceLimit] = function(self)
  -- function num : 0_3 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.FactoryPipelie] = function(self)
  -- function num : 0_4 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.GlobalExpCeiling] = function(self)
  -- function num : 0_5 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.ResOutputEfficiency] = function(self)
  -- function num : 0_6 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.BuildQueue] = function(self)
  -- function num : 0_7 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.BuildSpeed] = function(self)
  -- function num : 0_8 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.GlobalExpRatio] = function(self)
  -- function num : 0_9 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.OverClock] = function(self)
  -- function num : 0_10 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.OverClockFreeNum] = function(self)
  -- function num : 0_11 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.FocusPointCeiling] = function(self)
  -- function num : 0_12 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.BattleExpBonus] = function(self)
  -- function num : 0_13 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.DynSkillUpgrade] = function(self)
  -- function num : 0_14 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.DynPlayerAttrBuff] = function(self)
  -- function num : 0_15 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.DungeonRewardRate] = function(self)
  -- function num : 0_16
  self.totalData = {}
  self.dungeonActivityIdDic = {}
end
, [eLogicType.HeroLevelCeiling] = function(self)
  -- function num : 0_17 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.AutoRecoverItem] = function(self)
  -- function num : 0_18 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.DungeonCountAdd] = function(self)
  -- function num : 0_19 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.FactoryEfficiency] = function(self)
  -- function num : 0_20 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.ResOutputCeiling] = function(self)
  -- function num : 0_21 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.ChipCeilingCostReduce] = function(self)
  -- function num : 0_22 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.EpInitItemAddtion] = function(self)
  -- function num : 0_23 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.EpBattleRoomGetExr] = function(self)
  -- function num : 0_24 , upvalues : InitFunc2Para
  InitFunc2Para(self)
end
, [eLogicType.SupportCountAddtion] = function(self)
  -- function num : 0_25 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.HpRecoverInRecoveryRoom] = function(self)
  -- function num : 0_26 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.OverClockCountAddtion] = function(self)
  -- function num : 0_27 , upvalues : InitFunc1Para
  InitFunc1Para(self)
end
, [eLogicType.Activity_PointMultRate] = InitFunc3Para, [eLogicType.Activity_Stamina2PointMultRate] = InitFunc3Para, [eLogicType.Activity_EffiMultRate] = InitFunc2Para, [eLogicType.Activity_ChipGroupLevel] = InitFunc3Para, [eLogicType.Activity_UnlockBuff] = function(self)
  -- function num : 0_28 , upvalues : InitFunc3Para
  InitFunc3Para(self)
end
, [eLogicType.Activity_DeleteBuff] = function(self)
  -- function num : 0_29 , upvalues : InitFunc3Para
  InitFunc3Para(self)
end
, [eLogicType.Activity_PowTestChipGroupLimitAdd] = InitFunc3Para, [eLogicType.Activity_ChipGroupCarryLimitAdd] = InitFunc2Para, [eLogicType.DungeonShareRewardRate] = function(self, uid, para1, para2, para3)
  -- function num : 0_30
  self.totalData = {}
  self.dungeonActivityIdDic = {}
end
}
local InstallFunc1Para = function(self, uid, para1, para2, para3)
  -- function num : 0_31
  local ori = (self.categoryDataDic)[uid]
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = para1
  if ori ~= nil then
    self.totalData = self.totalData - ori
  end
  self.totalData = self.totalData + para1
end

local InstallFunc2Para = function(self, uid, para1, para2, para3)
  -- function num : 0_32
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  local ori = data[para1] or 0
  data[para1] = para2
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R7 in 'UnsetPending'

  if ori <= para2 then
    (self.totalData)[para1] = (self.totalData)[para1] + para2 - ori
  else
    local diff = ori - para2
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R8 in 'UnsetPending'

    if diff < (self.totalData)[para1] then
      (self.totalData)[para1] = (self.totalData)[para1] - diff
    else
      -- DECOMPILER ERROR at PC34: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.totalData)[para1] = nil
    end
  end
end

local InstallFunc2ParaMaxValue = function(self, uid, para1, para2, para3)
  -- function num : 0_33
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  local ori = data[para1] or 0
  data[para1] = para2
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R7 in 'UnsetPending'

  if ori <= para2 then
    (self.totalData)[para1] = para2
  end
end

local InstallFunc3Para = function(self, uid, para1, para2, para3)
  -- function num : 0_34
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  if data[para1] == nil then
    data[para1] = {}
  end
  local ori = (data[para1])[para2] or 0
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (data[para1])[para2] = para3
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

  if (self.totalData)[para1] == nil then
    (self.totalData)[para1] = {}
  end
  local oriTotal = ((self.totalData)[para1])[para2] or 0
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R8 in 'UnsetPending'

  if ori <= para3 then
    ((self.totalData)[para1])[para2] = oriTotal + para3 - ori
  else
    local diff = ori - para3
    -- DECOMPILER ERROR at PC47: Confused about usage of register: R9 in 'UnsetPending'

    if diff < oriTotal then
      ((self.totalData)[para1])[para2] = oriTotal - diff
    else
      -- DECOMPILER ERROR at PC51: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self.totalData)[para1])[para2] = nil
    end
  end
end

local InstallFunc3ParaMaxValue = function(self, uid, para1, para2, para3)
  -- function num : 0_35
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  if data[para1] == nil then
    data[para1] = {}
  end
  local ori = (data[para1])[para2] or 0
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (data[para1])[para2] = para3
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R7 in 'UnsetPending'

  if ori <= para3 then
    if (self.totalData)[para1] == nil then
      (self.totalData)[para1] = {}
    end
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.totalData)[para1])[para2] = para3
  end
end

local InstallFuncDic = {[eLogicType.ResourceLimit] = function(self, uid, para1, para2, para3)
  -- function num : 0_36 , upvalues : InstallFunc2Para, _ENV
  InstallFunc2Para(self, uid, para1, para2, para3)
  ;
  (PlayerDataCenter.playerBonus):AddPlayerBonusBroadcast("warehouse")
end
, [eLogicType.CampBuff] = function(self, uid, para1, para2, para3)
  -- function num : 0_37 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  if data[para1] == nil then
    data[para1] = {}
  end
  if (data[para1])[para2] ~= nil then
    (PlayerDataCenter.attributeBonus):RemoveCampBonus(para1, para2, (data[para1])[para2])
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (data[para1])[para2] = para3
  ;
  (PlayerDataCenter.attributeBonus):AddCampBonus(para1, para2, para3)
end
, [eLogicType.CareerBuff] = function(self, uid, para1, para2, para3)
  -- function num : 0_38 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  if data[para1] == nil then
    data[para1] = {}
  end
  if (data[para1])[para2] ~= nil then
    (PlayerDataCenter.attributeBonus):RemoveCareerBonus(para1, para2, (data[para1])[para2])
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (data[para1])[para2] = para3
  ;
  (PlayerDataCenter.attributeBonus):AddCareerBonus(para1, para2, para3)
end
, [eLogicType.FactoryPipelie] = function(self, uid, para1, para2, para3)
  -- function num : 0_39 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.GlobalExpCeiling] = function(self, uid, para1, para2, para3)
  -- function num : 0_40 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.ResOutputEfficiency] = function(self, uid, para1, para2, para3)
  -- function num : 0_41 , upvalues : InstallFunc2Para
  InstallFunc2Para(self, uid, para1, para2, para3)
end
, [eLogicType.BuildQueue] = function(self, uid, para1, para2, para3)
  -- function num : 0_42 , upvalues : InstallFunc2Para
  InstallFunc2Para(self, uid, para1, para2, para3)
end
, [eLogicType.BuildSpeed] = function(self, uid, para1, para2, para3)
  -- function num : 0_43 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.GlobalExpRatio] = function(self, uid, para1, para2, para3)
  -- function num : 0_44 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.AllHeroBuff] = function(self, uid, para1, para2, para3)
  -- function num : 0_45 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  if data[para1] ~= nil then
    (PlayerDataCenter.attributeBonus):RemoveAllBonus(para1, data[para1])
  end
  data[para1] = para2
  ;
  (PlayerDataCenter.attributeBonus):AddAllBonus(para1, para2)
end
, [eLogicType.OverClock] = function(self, uid, para1, para2, para3)
  -- function num : 0_46 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  local ori = data[para1] or 0
  data[para1] = (math.max)(ori, para2)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.totalData)[para1] = (math.max)(para2, (self.totalData)[para1] or 0)
end
, [eLogicType.OverClockFreeNum] = function(self, uid, para1, para2, para3)
  -- function num : 0_47 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.FocusPointCeiling] = function(self, uid, para1, para2, para3)
  -- function num : 0_48 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.BattleExpBonus] = function(self, uid, para1, para2, para3)
  -- function num : 0_49 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.DynSkillUpgrade] = function(self, uid, para1, para2, para3)
  -- function num : 0_50 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.DynPlayerAttrBuff] = function(self, uid, para1, para2, para3)
  -- function num : 0_51 , upvalues : InstallFunc2Para
  InstallFunc2Para(self, uid, para1, para2, para3)
end
, [eLogicType.DungeonRewardRate] = function(self, uid, para1, para2, para3)
  -- function num : 0_52 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  if data[para1] == nil then
    data[para1] = {}
  end
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (data[para1])[para2] = (math.max)((data[para1])[para2] or 0, para3)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R6 in 'UnsetPending'

  if (self.totalData)[para1] == nil then
    (self.totalData)[para1] = {}
  end
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.totalData)[para1])[para2] = (math.max)(para3, ((self.totalData)[para1])[para2] or 0)
  local moduelId = uid >> 32
  if moduelId == proto_csmsg_SystemFunctionID.SystemFunctionID_Double_Active then
    local activitiId = uid & CommonUtil.UInt32Max
    -- DECOMPILER ERROR at PC58: Confused about usage of register: R8 in 'UnsetPending'

    if not (self.dungeonActivityIdDic)[para1] then
      (self.dungeonActivityIdDic)[para1] = {}
      -- DECOMPILER ERROR at PC67: Confused about usage of register: R8 in 'UnsetPending'

      if not ((self.dungeonActivityIdDic)[para1])[activitiId] then
        ((self.dungeonActivityIdDic)[para1])[activitiId] = {}
        -- DECOMPILER ERROR at PC70: Confused about usage of register: R8 in 'UnsetPending'

        ;
        ((self.dungeonActivityIdDic)[para1])[activitiId] = true
      end
    end
  end
end
, [eLogicType.HeroLevelCeiling] = function(self, uid, para1, para2, para3)
  -- function num : 0_53 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.AutoRecoverItem] = function(self, uid, para1, para2, para3)
  -- function num : 0_54 , upvalues : InstallFunc2Para, _ENV
  InstallFunc2Para(self, uid, para1, para2, para3)
  ;
  (PlayerDataCenter.playerBonus):AddPlayerBonusBroadcast("AutoRecoverItem")
end
, [eLogicType.DungeonCountAdd] = function(self, uid, para1, para2, para3)
  -- function num : 0_55 , upvalues : InstallFunc2Para
  InstallFunc2Para(self, uid, para1, para2, para3)
end
, [eLogicType.FactoryEfficiency] = function(self, uid, para1, para2, para3)
  -- function num : 0_56 , upvalues : InstallFunc2Para
  InstallFunc2Para(self, uid, para1, para2, para3)
end
, [eLogicType.ResOutputCeiling] = function(self, uid, para1, para2, para3)
  -- function num : 0_57 , upvalues : InstallFunc2Para
  InstallFunc2Para(self, uid, para1, para2, para3)
end
, [eLogicType.ChipCeilingCostReduce] = function(self, uid, para1, para2, para3)
  -- function num : 0_58 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.EpInitItemAddtion] = function(self, uid, para1, para2, para3)
  -- function num : 0_59 , upvalues : InstallFunc2Para
  InstallFunc2Para(self, uid, para1, para2, para3)
end
, [eLogicType.EpBattleRoomGetExr] = function(self, uid, para1, para2, para3)
  -- function num : 0_60 , upvalues : InstallFunc2Para
  InstallFunc2Para(self, uid, para1, para2, para3)
end
, [eLogicType.SupportCountAddtion] = function(self, uid, para1, para2, para3)
  -- function num : 0_61 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.HpRecoverInRecoveryRoom] = function(self, uid, para1, para2, para3)
  -- function num : 0_62 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.OverClockCountAddtion] = function(self, uid, para1, para2, para3)
  -- function num : 0_63 , upvalues : InstallFunc1Para
  InstallFunc1Para(self, uid, para1, para2, para3)
end
, [eLogicType.Activity_PointMultRate] = InstallFunc3Para, [eLogicType.Activity_Stamina2PointMultRate] = InstallFunc3ParaMaxValue, [eLogicType.Activity_EffiMultRate] = InstallFunc2ParaMaxValue, [eLogicType.Activity_ChipGroupLevel] = InstallFunc3ParaMaxValue, [eLogicType.Activity_UnlockBuff] = function(self, uid, para1, para2, para3)
  -- function num : 0_64
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  local ori = data[para1] or 0
  data[para1] = para2
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

  if (self.totalData)[para1] == nil then
    (self.totalData)[para1] = {}
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.totalData)[para1])[para2] = true
end
, [eLogicType.Activity_DeleteBuff] = function(self, uid, para1, para2, para3)
  -- function num : 0_65
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    data = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.categoryDataDic)[uid] = data
  end
  local ori = data[para1] or 0
  data[para1] = para2
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

  if (self.totalData)[para1] == nil then
    (self.totalData)[para1] = {}
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.totalData)[para1])[para2] = true
end
, [eLogicType.Activity_PowTestChipGroupLimitAdd] = InstallFunc3ParaMaxValue, [eLogicType.Activity_ChipGroupCarryLimitAdd] = InstallFunc2ParaMaxValue, [eLogicType.DungeonShareRewardRate] = function(self, uid, para1, para2, para3)
  -- function num : 0_66 , upvalues : InstallFunc3ParaMaxValue, _ENV
  InstallFunc3ParaMaxValue(self, uid, para1, para2, para3)
  local moduelId = uid >> 32
  if moduelId == proto_csmsg_SystemFunctionID.SystemFunctionID_Double_Active then
    local activitiId = uid & CommonUtil.UInt32Max
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R7 in 'UnsetPending'

    if not (self.dungeonActivityIdDic)[para1] then
      (self.dungeonActivityIdDic)[para1] = {}
      -- DECOMPILER ERROR at PC30: Confused about usage of register: R7 in 'UnsetPending'

      if not ((self.dungeonActivityIdDic)[para1])[activitiId] then
        ((self.dungeonActivityIdDic)[para1])[activitiId] = {}
        -- DECOMPILER ERROR at PC33: Confused about usage of register: R7 in 'UnsetPending'

        ;
        ((self.dungeonActivityIdDic)[para1])[activitiId] = true
      end
    end
  end
end
}
local uninstallFunc1Para = function(self, uid)
  -- function num : 0_67 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  self.totalData = (math.max)(0, self.totalData - data)
end

local uninstallFunc2Para = function(self, uid)
  -- function num : 0_68 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  for k,v in pairs(data) do
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R8 in 'UnsetPending'

    if v < (self.totalData)[k] then
      (self.totalData)[k] = (self.totalData)[k] - v
    else
      -- DECOMPILER ERROR at PC34: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.totalData)[k] = nil
    end
  end
end

local uninstallFunc2ParaMaxValue = function(self, uid)
  -- function num : 0_69 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  for para1,para2 in pairs(data) do
    local maxValue = nil
    for uid,catData in pairs(self.categoryDataDic) do
      if not maxValue then
        do
          maxValue = (math.max)(catData[para1] == nil or 0, catData[para1])
          -- DECOMPILER ERROR at PC39: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC39: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.totalData)[para1] = maxValue
  end
end

local uninstallFunc3Para = function(self, uid)
  -- function num : 0_70 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  for para1,para2Table in pairs(data) do
    for para2,para3 in pairs(para2Table) do
      local totalV = ((self.totalData)[para1])[para2] or 0
      -- DECOMPILER ERROR at PC38: Confused about usage of register: R14 in 'UnsetPending'

      if para3 < totalV then
        ((self.totalData)[para1])[para2] = totalV - para3
      else
        -- DECOMPILER ERROR at PC42: Confused about usage of register: R14 in 'UnsetPending'

        ;
        ((self.totalData)[para1])[para2] = nil
      end
    end
  end
end

local uninstallFunc3ParaMaxValue = function(self, uid)
  -- function num : 0_71 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  for para1,para2Table in pairs(data) do
    for para2,para3 in pairs(para2Table) do
      local maxValue = nil
      for uid,catData in pairs(self.categoryDataDic) do
        if not maxValue then
          do
            maxValue = (math.max)((catData[para1])[para2] == nil or 0, (catData[para1])[para2])
            -- DECOMPILER ERROR at PC45: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC45: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R14 in 'UnsetPending'

      ;
      ((self.totalData)[para1])[para2] = maxValue
    end
  end
end

local UninstallFuncDic = {[eLogicType.ResourceLimit] = function(self, uid)
  -- function num : 0_72 , upvalues : uninstallFunc2Para, _ENV
  uninstallFunc2Para(self, uid)
  ;
  (PlayerDataCenter.playerBonus):AddPlayerBonusBroadcast("warehouse")
end
, [eLogicType.CampBuff] = function(self, uid)
  -- function num : 0_73 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  for para1,v in pairs(data) do
    for para2,para3 in pairs(v) do
      (PlayerDataCenter.attributeBonus):RemoveCampBonus(para1, para2, para3)
    end
  end
end
, [eLogicType.CareerBuff] = function(self, uid)
  -- function num : 0_74 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  for para1,v in pairs(data) do
    for para2,para3 in pairs(v) do
      (PlayerDataCenter.attributeBonus):RemoveCareerBonus(para1, para2, para3)
    end
  end
end
, [eLogicType.FactoryPipelie] = function(self, uid)
  -- function num : 0_75 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.GlobalExpCeiling] = function(self, uid)
  -- function num : 0_76 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.ResOutputEfficiency] = function(self, uid)
  -- function num : 0_77 , upvalues : uninstallFunc2Para
  uninstallFunc2Para(self, uid)
end
, [eLogicType.BuildQueue] = function(self, uid)
  -- function num : 0_78 , upvalues : uninstallFunc2Para
  uninstallFunc2Para(self, uid)
end
, [eLogicType.BuildSpeed] = function(self, uid)
  -- function num : 0_79 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.GlobalExpRatio] = function(self, uid)
  -- function num : 0_80 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.AllHeroBuff] = function(self, uid)
  -- function num : 0_81 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  for para1,para2 in pairs(data) do
    (PlayerDataCenter.attributeBonus):RemoveAllBonus(para1, para2)
  end
end
, [eLogicType.OverClock] = function(self, uid)
  -- function num : 0_82 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  for para1,oldPara2 in pairs(data) do
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R8 in 'UnsetPending'

    (self.totalData)[para1] = 0
    for uid,data in pairs(self.categoryDataDic) do
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R13 in 'UnsetPending'

      if not (self.totalData)[para1] then
        do
          (self.totalData)[para1] = (math.max)(data[para1], data[para1] == nil or 0)
          -- DECOMPILER ERROR at PC43: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC43: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end
, [eLogicType.OverClockFreeNum] = function(self, uid)
  -- function num : 0_83 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.FocusPointCeiling] = function(self, uid)
  -- function num : 0_84 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.BattleExpBonus] = function(self, uid)
  -- function num : 0_85 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.DynSkillUpgrade] = function(self, uid)
  -- function num : 0_86 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.DynPlayerAttrBuff] = function(self, uid)
  -- function num : 0_87 , upvalues : uninstallFunc2Para
  uninstallFunc2Para(self, uid)
end
, [eLogicType.DungeonRewardRate] = function(self, uid)
  -- function num : 0_88 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
  for para1,weekNumDic in pairs(data) do
    for para2,_ in pairs(weekNumDic) do
      -- DECOMPILER ERROR at PC29: Confused about usage of register: R13 in 'UnsetPending'

      ((self.totalData)[para1])[para2] = 0
    end
  end
  for uid,para1Dic in pairs(self.categoryDataDic) do
    for para1,para2Dic in pairs(para1Dic) do
      for para2,para3 in pairs(para2Dic) do
        -- DECOMPILER ERROR at PC58: Confused about usage of register: R18 in 'UnsetPending'

        ;
        ((self.totalData)[para1])[para2] = (math.max)(para3, ((self.totalData)[para1])[para2] or 0)
      end
    end
  end
  local moduelId = uid >> 32
  if moduelId == proto_csmsg_SystemFunctionID.SystemFunctionID_Double_Active then
    local activitiId = uid & CommonUtil.UInt32Max
    for para1,v in pairs(data) do
      -- DECOMPILER ERROR at PC83: Confused about usage of register: R10 in 'UnsetPending'

      if (self.dungeonActivityIdDic)[para1] ~= nil then
        ((self.dungeonActivityIdDic)[para1])[activitiId] = nil
      end
      -- DECOMPILER ERROR at PC92: Confused about usage of register: R10 in 'UnsetPending'

      if (table.IsEmptyTable)((self.dungeonActivityIdDic)[para1]) then
        (self.dungeonActivityIdDic)[para1] = nil
      end
    end
  end
end
, [eLogicType.HeroLevelCeiling] = function(self, uid)
  -- function num : 0_89 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.AutoRecoverItem] = function(self, uid)
  -- function num : 0_90 , upvalues : uninstallFunc2Para, _ENV
  uninstallFunc2Para(self, uid)
  ;
  (PlayerDataCenter.playerBonus):AddPlayerBonusBroadcast("AutoRecoverItem")
end
, [eLogicType.DungeonCountAdd] = function(self, uid)
  -- function num : 0_91 , upvalues : uninstallFunc2Para
  uninstallFunc2Para(self, uid)
end
, [eLogicType.FactoryEfficiency] = function(self, uid)
  -- function num : 0_92 , upvalues : uninstallFunc2Para
  uninstallFunc2Para(self, uid)
end
, [eLogicType.ResOutputCeiling] = function(self, uid)
  -- function num : 0_93 , upvalues : uninstallFunc2Para
  uninstallFunc2Para(self, uid)
end
, [eLogicType.ChipCeilingCostReduce] = function(self, uid)
  -- function num : 0_94 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.EpInitItemAddtion] = function(self, uid)
  -- function num : 0_95 , upvalues : uninstallFunc2Para
  uninstallFunc2Para(self, uid)
end
, [eLogicType.EpBattleRoomGetExr] = function(self, uid)
  -- function num : 0_96 , upvalues : uninstallFunc2Para
  uninstallFunc2Para(self, uid)
end
, [eLogicType.SupportCountAddtion] = function(self, uid)
  -- function num : 0_97 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.HpRecoverInRecoveryRoom] = function(self, uid)
  -- function num : 0_98 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.OverClockCountAddtion] = function(self, uid)
  -- function num : 0_99 , upvalues : uninstallFunc1Para
  uninstallFunc1Para(self, uid)
end
, [eLogicType.Activity_PointMultRate] = uninstallFunc3Para, [eLogicType.Activity_Stamina2PointMultRate] = uninstallFunc3ParaMaxValue, [eLogicType.Activity_EffiMultRate] = uninstallFunc2ParaMaxValue, [eLogicType.Activity_ChipGroupLevel] = uninstallFunc3ParaMaxValue, [eLogicType.Activity_UnlockBuff] = function(self, uid)
  -- function num : 0_100 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  for para1,para2 in pairs(data) do
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R8 in 'UnsetPending'

    ((self.totalData)[para1])[para2] = nil
  end
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
end
, [eLogicType.Activity_DeleteBuff] = function(self, uid)
  -- function num : 0_101 , upvalues : _ENV
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  for para1,para2Table in pairs(data) do
    for para2,_ in pairs(para2Table) do
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R13 in 'UnsetPending'

      ((self.totalData)[para1])[para2] = nil
    end
  end
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.categoryDataDic)[uid] = nil
end
, [eLogicType.Activity_PowTestChipGroupLimitAdd] = uninstallFunc3ParaMaxValue, [eLogicType.Activity_ChipGroupCarryLimitAdd] = uninstallFunc2ParaMaxValue, [eLogicType.DungeonShareRewardRate] = function(self, uid)
  -- function num : 0_102 , upvalues : _ENV, uninstallFunc3ParaMaxValue
  local data = (self.categoryDataDic)[uid]
  if data == nil then
    error((string.format)("No categoryData, uid = %s, logic = %s, module = %s, id = %s", self.logic, uid, uid >> 32, uid & CommonUtil.UInt32Max))
    return 
  end
  uninstallFunc3ParaMaxValue(self, uid)
  local moduelId = uid >> 32
  if moduelId == proto_csmsg_SystemFunctionID.SystemFunctionID_Double_Active then
    local activitiId = uid & CommonUtil.UInt32Max
    for para1,v in pairs(data) do
      -- DECOMPILER ERROR at PC39: Confused about usage of register: R10 in 'UnsetPending'

      if (self.dungeonActivityIdDic)[para1] ~= nil then
        ((self.dungeonActivityIdDic)[para1])[activitiId] = nil
      end
      -- DECOMPILER ERROR at PC48: Confused about usage of register: R10 in 'UnsetPending'

      if (table.IsEmptyTable)((self.dungeonActivityIdDic)[para1]) then
        (self.dungeonActivityIdDic)[para1] = nil
      end
    end
  end
end
}
PlayerBonusElem.ctor = function(self)
  -- function num : 0_103
  self.categoryDataDic = {}
  self.totalData = nil
end

PlayerBonusElem.InitPlayerBonusElem = function(self, logic)
  -- function num : 0_104 , upvalues : InitFuncDic
  self.logic = logic
  local initFunc = InitFuncDic[logic]
  if initFunc == nil then
    return 
  end
  initFunc(self)
end

PlayerBonusElem.InstallBonus = function(self, uid, para1, para2, para3)
  -- function num : 0_105 , upvalues : InstallFuncDic
  local installFunc = InstallFuncDic[self.logic]
  if installFunc == nil then
    return 
  end
  installFunc(self, uid, para1, para2, para3)
end

PlayerBonusElem.UninstallBonus = function(self, uid)
  -- function num : 0_106 , upvalues : UninstallFuncDic
  local uninstallFunc = UninstallFuncDic[self.logic]
  if uninstallFunc == nil then
    return 
  end
  uninstallFunc(self, uid)
end

return PlayerBonusElem

