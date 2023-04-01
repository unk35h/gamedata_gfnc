-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommanderSkill = class("UINCommanderSkill", UIBaseNode)
local base = UIBaseNode
local CommanderSkillData = require("Game.CommanderSkill.CommanderSkillData")
UINCommanderSkill.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCommanderSkill.InitCommanderSkill = function(self, skillId, resloader)
  -- function num : 0_1 , upvalues : CommanderSkillData, _ENV
  local iconName = (CommanderSkillData.GetCmdSkillIconById)(skillId)
  if resloader ~= nil and iconName ~= nil then
    resloader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("CommanderSkillIcons"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV, iconName
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SkillIcon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, iconName)
  end
)
  end
end

UINCommanderSkill.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINCommanderSkill

