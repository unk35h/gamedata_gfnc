-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_24 = class("gs_24", LuaGridBase)
gs_24.config = {buff285 = 285}
gs_24.__InitGridInternal = function(self, cEffectGrid, x, y)
  -- function num : 0_0 , upvalues : _ENV
  (LuaGridBase.__InitGridInternal)(self, cEffectGrid, x, y)
  LuaSkillCtrl:MakeUpSceneData()
  if LuaSkillCtrl.sceneDummyExist then
    LuaSkillCtrl:ChangeSceneMap(x, y)
  end
end

gs_24.OnGridEnterRole = function(self, role)
  -- function num : 0_1 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, role, (self.config).buff285, 1, nil, true)
end

gs_24.OnGridBattleEnd = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  (LuaGridBase.OnGridBattleEnd)(self, role)
  self:RecoverGridMap()
end

gs_24.RecoverGridMap = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if LuaSkillCtrl.sceneDummyExist then
    LuaSkillCtrl:RecoverSceneMap(self.x, self.y)
  end
end

return gs_24

