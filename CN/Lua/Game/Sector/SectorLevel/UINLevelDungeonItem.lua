-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLevelDungeonItem = class("UINLevelDungeonItem", UIBaseNode)
local base = UIBaseNode
UINLevelDungeonItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickDungeonLevel)
end

UINLevelDungeonItem.InitLevelDungeon = function(self, dungeonLevelData, index, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._dungeonLevelData = dungeonLevelData
  self._callback = callback
  ;
  ((self.ui).tex_LevelNumber):SetIndex(0, tostring(index))
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Tile).text = dungeonLevelData:GetDungeonLevelName()
  self:RefreshLevelDungeonState()
end

UINLevelDungeonItem.SetLevelDungeonBlueReddotFunc = function(self, reddotfunc)
  -- function num : 0_2
  self._reddotfunc = reddotfunc
  self:RefreshLevelDungeonReddot()
end

UINLevelDungeonItem.SetLevelDungonSelect = function(self, flag)
  -- function num : 0_3
end

UINLevelDungeonItem.RefreshLevelDungeonState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local locked = not (self._dungeonLevelData):GetIsLevelUnlock()
  ;
  ((self.ui).obj_Locked):SetActive(locked)
  local battleCount = PlayerDataCenter:GetTotalBattleTimes((self._dungeonLevelData):GetDungeonLevelStageId())
  ;
  ((self.ui).img_Complete):SetActive(battleCount > 0)
  if locked then
    local cond, pre1, pre2 = (self._dungeonLevelData):GetLevelUnlockConditionCfg()
    local des = (CheckCondition.GetUnlockInfoLua)(cond, pre1, pre2)
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_Condition).text = des
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINLevelDungeonItem.RefreshLevelDungeonReddot = function(self)
  -- function num : 0_5
  ((self.ui).blueDot):SetActive(self._reddotfunc ~= nil and ((self._reddotfunc ~= nil and (self._reddotfunc)((self._dungeonLevelData):GetDungeonLevelStageId()))))
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINLevelDungeonItem.GetSectorLevelDungeon = function(self)
  -- function num : 0_6
  return self._dungeonLevelData
end

UINLevelDungeonItem.OnClickDungeonLevel = function(self)
  -- function num : 0_7
  if self._callback ~= nil then
    (self._callback)(self)
  end
end

return UINLevelDungeonItem

