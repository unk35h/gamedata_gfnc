-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100702 = require("GamePlay.SkillScripts.RoleSkill.100702_ChelseaSkill")
local bs_100705 = class("bs_100705", bs_100702)
local base = bs_100702
bs_100705.config = {weaponLv = 2, buffId_Dj = 100701, HurtConfigId = 2, buffId_BingDong = 1178, buffId_cs = 100702, configId = 2}
bs_100705.config = setmetatable(bs_100705.config, {__index = base.config})
bs_100705.ctor = function(self)
  -- function num : 0_0
end

bs_100705.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBeforeAddBuffTrigger("bs_100705_1", 1, self.OnBeforeAddBuff, nil, nil, nil, not (self.caster).belongNum, nil, nil, eBuffFeatureType.BeatBack)
  self:AddAfterAddBuffTrigger("bs_100705_2", 2, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).buffId_BingDong)
  self:AddLuaTrigger(eSkillLuaTrigger.OnChelseaStun, self.OnChelseaStun)
  self.targetlist = {}
  self.extar_time = ((self.caster).recordTable)["100706_time"]
end

bs_100705.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum ~= (self.caster).belongNum and target:GetBuffTier((self.config).buffId_Dj) > 0 then
    context.active = false
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[4]}, true)
    skillResult:EndResult()
  end
end

bs_100705.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  if target:GetBuffTier((self.config).buffId_cs) > 0 then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_Dj, 1, nil)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

    if (self.targetlist)[target] ~= nil then
      ((self.targetlist)[target]).left = (self.arglist)[6]
    else
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.targetlist)[target] = LuaSkillCtrl:StartTimer(nil, (self.arglist)[6], function()
    -- function num : 0_3_0 , upvalues : target, self, _ENV
    if target:GetBuffTier((self.config).buffId_Dj) > 0 then
      LuaSkillCtrl:DispelBuff(target, (self.config).buffId_Dj)
      -- DECOMPILER ERROR at PC15: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (self.targetlist)[target] = nil
    end
  end
)
    end
  end
end

bs_100705.OnChelseaStun = function(self, target)
  -- function num : 0_4
  if target ~= nil and target.hp > 0 then
    local time = ((self.targetlist)[target]).left + self.extar_time
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.targetlist)[target]).left = time
  end
end

bs_100705.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_100705.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  self.targetlist = nil
end

return bs_100705

