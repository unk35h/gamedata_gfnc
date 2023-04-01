-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSpring23HardLevelItem = class("UINActSpring23HardLevelItem", UIBaseNode)
local base = UINActSpring23HardLevelItem
UINActSpring23HardLevelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).item, self, self.OnClickChallenge)
end

UINActSpring23HardLevelItem.InitSpring23ChallengeItem = function(self, springData, dungeonId, index, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._springData = springData
  self._dungeonCfg = (ConfigData.battle_dungeon)[dungeonId]
  self._callback = callback
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_QuestName).text = (LanguageUtil.GetLocaleText)((self._dungeonCfg).name)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_LockDes).text = (CheckCondition.GetUnlockInfoLua)((self._dungeonCfg).pre_condition, (self._dungeonCfg).pre_para1, (self._dungeonCfg).pre_para2)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = tostring(index)
  self:__Refresh()
end

UINActSpring23HardLevelItem.__Refresh = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isUnlock = (CheckCondition.CheckLua)((self._dungeonCfg).pre_condition, (self._dungeonCfg).pre_para1, (self._dungeonCfg).pre_para2)
  if not isUnlock then
    ((self.ui).text_Time):SetIndex(1)
    ;
    ((self.ui).obj_Lock):SetActive(true)
    return 
  end
  local finishiTime = (self._springData):GetSpringChallengeRecord((self._dungeonCfg).id)
  ;
  ((self.ui).obj_Lock):SetActive(false)
  if finishiTime or 0 == 0 then
    ((self.ui).text_Time):SetIndex(1)
  else
    if CommonUtil.UInt32Max <= finishiTime then
      ((self.ui).text_Time):SetIndex(2)
    else
      finishiTime = finishiTime / BattleUtil.LogicFrameCount
      local min = (math.floor)(finishiTime / 60)
      local sec = finishiTime % 60
      ;
      ((self.ui).text_Time):SetIndex(0, (string.format)("%02d", min), (string.format)("%.03f", sec))
    end
  end
end

UINActSpring23HardLevelItem.GetSpringChallengeDungeonId = function(self)
  -- function num : 0_3
  return (self._dungeonCfg).id
end

UINActSpring23HardLevelItem.OnClickChallenge = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local unlock = (CheckCondition.CheckLua)((self._dungeonCfg).pre_condition, (self._dungeonCfg).pre_para1, (self._dungeonCfg).pre_para2)
  if unlock and self._callback ~= nil then
    (self._callback)((self._dungeonCfg).id)
  end
end

return UINActSpring23HardLevelItem

