-- params : ...
-- function num : 0 , upvalues : _ENV
local HotfixEffectGrid = class("HotfixEffectGrid", HotfixBase)
local BattleEfcGridController = CS.BattleEfcGridController
local CS_BattleManager_Ins = (CS.BattleManager).Instance
local LoadNeutralResource = function(self, effectGrid)
  -- function num : 0_0 , upvalues : _ENV, CS_BattleManager_Ins
  (self.effectGridDic):Add(effectGrid.coord, effectGrid)
  ;
  (self.effectGridsList):Add(effectGrid)
  if LuaSkillCtrl.IsInVerify then
    return 
  end
  local battleController = CS_BattleManager_Ins.CurBattleController
  if battleController.LoadedBattleMapObj then
    local pos = (battleController.battleFieldData):GetGridUnityPos(effectGrid.x, effectGrid.y)
    local efcGameObject = self:GetGridEfcInsFromCache(effectGrid.dataId)
    if not IsNull(efcGameObject) then
      (efcGameObject.transform):SetParent(self.neutralHolder, false)
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (efcGameObject.transform).position = pos
      effectGrid:AddEfcGameObjs(efcGameObject)
    else
      effectGrid:LoadGridFacadeDirectly((CS_BattleManager_Ins.BattlePrepareResHandle).resLoader, self.neutralHolder, pos)
    end
  end
end

HotfixEffectGrid.Register = function(self)
  -- function num : 0_1 , upvalues : BattleEfcGridController, LoadNeutralResource
  self:RegisterHotfix(BattleEfcGridController, "LoadNeutralResource", LoadNeutralResource)
end

return HotfixEffectGrid

