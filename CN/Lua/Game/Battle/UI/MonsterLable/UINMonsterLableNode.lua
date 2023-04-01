-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMonsterLableNode = class("UINMonsterLableNode", UIBaseNode)
local base = UIBaseNode
local resLoader = nil
local resLoaderUserNum = 0
UINMonsterLableNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINMonsterLableNode.RefreshMonsterLable = function(self, dynBattleRole)
  -- function num : 0_1 , upvalues : _ENV
  if dynBattleRole == nil then
    self:Hide()
  end
  self:Show()
  local monsterLableCfg = dynBattleRole:GetMonsterLableCfg()
  local monsterLableThemeCfg = (ConfigData.monster_lable_theme)[monsterLableCfg.label_theme]
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_monsterLable).text = (LanguageUtil.GetLocaleText)(monsterLableCfg.label_name)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite(monsterLableThemeCfg.icon, CommonAtlasType.SkillIcon)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_monsterLable).color = (Color.IntArray2Color)(monsterLableThemeCfg.color)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_monsterLableBg).color = (Color.IntArray2Color)(monsterLableThemeCfg.bg)
end

UINMonsterLableNode.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINMonsterLableNode

