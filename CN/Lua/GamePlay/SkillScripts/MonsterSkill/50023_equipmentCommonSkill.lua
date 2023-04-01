-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_50023 = class("bs_50023", LuaSkillBase)
local base = LuaSkillBase
bs_50023.config = {}
local SyncAttrList = {eHeroAttr.pow, eHeroAttr.def, eHeroAttr.crit, eHeroAttr.critDamage, eHeroAttr.sunder, eHeroAttr.damage_increase, eHeroAttr.injury_reduce, eHeroAttr.heal, eHeroAttr.treatment, eHeroAttr.skill_intensity, eHeroAttr.magic_res, eHeroAttr.magic_pen}
bs_50023.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:OnAfterBattleStart()
end

bs_50023.OnSyncAttrFromHost = function(self, caster)
  -- function num : 0_1 , upvalues : _ENV, SyncAttrList
  local hostEntity = caster
  if hostEntity == nil or hostEntity.hp <= 0 then
    return over
  end
  for i,v in ipairs(SyncAttrList) do
    local attrValue = hostEntity:GetRealProperty(v)
    local curValue = (self.caster):GetRealProperty(v)
    ;
    (self.caster):AddRoleProperty(v, attrValue - curValue, eHeroAttrType.Origin)
  end
end

return bs_50023

