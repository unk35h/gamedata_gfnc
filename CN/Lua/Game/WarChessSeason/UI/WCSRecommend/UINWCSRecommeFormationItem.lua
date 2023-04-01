-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWCSRecommeFormationItem = class("UINWCSRecommeFormationItem", UIBaseNode)
local base = UIBaseNode
UINWCSRecommeFormationItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.heroHeadHolder = ((self.ui).obj_MainTeam).transform
  self.skillHolder = ((self.ui).obj_SkillList).transform
end

UINWCSRecommeFormationItem.InitWCSRecommeFormationItem = function(self, recommendTeam, recommendSkillData, getHeroHeadCallback, getSkillItemCallBack, resloder)
  -- function num : 0_1 , upvalues : _ENV
  for iHero = 1, 5 do
    local heroId = recommendTeam[iHero]
    getHeroHeadCallback(heroId, self.heroHeadHolder)
  end
  for iSkill = 1, 3 do
    local skillId = (recommendSkillData.recommendSkillList)[iSkill]
    getSkillItemCallBack(skillId, self.skillHolder)
  end
  local skillTreeId = recommendSkillData.recommendSkillTreeId
  local treeCfg = (ConfigData.commander_skill)[skillTreeId]
  if treeCfg == nil then
    (((self.ui).img_ComSkillIcon).gameObject):SetActive(false)
    ;
    ((self.ui).tex_ComSkillName):SetIndex(1)
  else
    local treeName = (LanguageUtil.GetLocaleText)(treeCfg.name)
    ;
    ((self.ui).tex_ComSkillName):SetIndex(0, treeName)
    ;
    (((self.ui).img_ComSkillIcon).gameObject):SetActive(false)
    resloder:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("CommanderSkillIcons"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV, treeCfg
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_ComSkillIcon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, treeCfg.icon)
    ;
    (((self.ui).img_ComSkillIcon).gameObject):SetActive(true)
  end
)
  end
end

return UINWCSRecommeFormationItem

