-- params : ...
-- function num : 0 , upvalues : _ENV
local DormFightCtrlBase = require("Game.Fight.Ctrl.DormFightCtrlBase")
local CS_AnimationEffectController_Ins = (CS.AnimationEffectController).Instance
local CS_AnimationEffectConfig = CS.AnimationEffectConfig
local DormFightEffectCtrl = class("DormFightEffectCtrl", DormFightCtrlBase)
DormFightEffectCtrl.ctor = function(self)
  -- function num : 0_0
end

DormFightEffectCtrl.AddFighterEffectByDormFightEffectId = function(self, fighterController, dormFightEffectId, resName, OriginResName)
  -- function num : 0_1 , upvalues : CS_AnimationEffectConfig, _ENV, CS_AnimationEffectController_Ins
  local animationEffectConfig = CS_AnimationEffectConfig()
  local cfg = (ConfigData.dorm_fight_fx)[dormFightEffectId]
  animationEffectConfig.EffectPath = (CS_AnimationEffectConfig.GenEffectSrcPath)(cfg.src_name, true, resName, OriginResName)
  animationEffectConfig.ResName = resName
  animationEffectConfig.OriginResName = OriginResName
  animationEffectConfig.BirthType = cfg.birth_type
  animationEffectConfig.BirthPoint = cfg.birth_point
  animationEffectConfig.BindPoint = cfg.bind_point
  animationEffectConfig.BindType = cfg.bind_type
  animationEffectConfig.Duration = cfg.exist_frame / 15
  animationEffectConfig.Layer = LayerMask.Character
  local effect = CS_AnimationEffectController_Ins:AddAnimationEffect(animationEffectConfig, fighterController.gameObject)
  effect:Play()
end

DormFightEffectCtrl.ClearFighterEffect = function(self, fighterController)
  -- function num : 0_2 , upvalues : _ENV, CS_AnimationEffectController_Ins
  if IsNull(fighterController) then
    return 
  end
  CS_AnimationEffectController_Ins:KillRoleEffect(fighterController.gameObject)
  CS_AnimationEffectController_Ins:RecycleRoleEffect(fighterController.gameObject)
end

DormFightEffectCtrl.OnFightEnd = function(self)
  -- function num : 0_3 , upvalues : CS_AnimationEffectController_Ins
  CS_AnimationEffectController_Ins:KillAllEffects()
  CS_AnimationEffectController_Ins:RecycleEffects()
end

return DormFightEffectCtrl

