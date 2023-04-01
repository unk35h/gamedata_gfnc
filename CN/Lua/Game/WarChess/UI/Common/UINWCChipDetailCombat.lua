-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.CommonUI.Chip.UINBaseChipDetail")
local UINWCChipDetailCombat = class("UINWCChipDetailCombat", base)
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_EaseLinear = (((CS.DG).Tweening).Ease).Linear
local UINHeroHeadItem = require("Game.CommonUI.Hero.UINHeroHeadItem")
UINWCChipDetailCombat.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, base, UINHeroHeadItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (base.OnInit)(self)
  self.heroHeadPool = (UIItemPool.New)(UINHeroHeadItem, (self.ui).obj_HeroHeadItem)
  ;
  ((self.ui).obj_HeroHeadItem):SetActive(false)
end

UINWCChipDetailCombat.InitWCChipDetailCombat = function(self, chipData, dynPlayer, resloader, isOwnData)
  -- function num : 0_1 , upvalues : base
  (base.InitBaseChipDetail)(self, nil, chipData, nil, resloader)
  self:_InitHeroHead(chipData, dynPlayer)
  self:_InitFightPower(chipData, dynPlayer, nil, isOwnData)
end

UINWCChipDetailCombat._InitHeroHead = function(self, chipData, dynPlayer)
  -- function num : 0_2 , upvalues : _ENV, cs_DoTween, cs_EaseLinear
  (self.heroHeadPool):HideAll()
  self:_SetTacticNodeActive(false)
  ;
  ((self.ui).obj_AllHero):SetActive(false)
  ;
  ((self.ui).obj_HeroMask):SetActive(false)
  if dynPlayer == nil then
    return 
  end
  if not chipData:IsConsumeSkillChip() or not 1 then
    self:_SetTacticNodeActive(true, chipData == nil or not chipData:IsValidDynPlayer() or 0)
    do return  end
    local validCharacters = chipData:GetValidRoleList(dynPlayer.heroList, eBattleRoleBelong.player, dynPlayer:GetSpecEffectMgr())
    local isAllHero = #dynPlayer.heroList <= #validCharacters
    ;
    (((self.ui).tran_heroHeadList).gameObject):SetActive(not isAllHero)
    ;
    ((self.ui).obj_AllHero):SetActive(isAllHero)
    if isAllHero then
      return 
    end
    ;
    ((self.ui).obj_HeroMask):SetActive(true)
    for _,dynHero in pairs(validCharacters) do
      local heroHeadItem = (self.heroHeadPool):GetOne()
      heroHeadItem:InitHeroHeadItem(dynHero.heroData, self.__resloader)
      heroHeadItem:Show()
    end
    ;
    (((CS.UnityEngine).Canvas).ForceUpdateCanvases)()
    local maskWidth = (((self.ui).tran_HeroHeadMask).rect).width
    local headListWidth = (((self.ui).tran_heroHeadList).rect).width
    -- DECOMPILER ERROR at PC102: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tran_heroHeadList).localPosition = Vector3.zero
    -- DECOMPILER ERROR at PC107: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tran_heroHeadList).anchoredPosition = Vector2.zero
    self:_ClearHeroHeadSequece()
    if headListWidth < maskWidth then
      return 
    end
    local sequece = (cs_DoTween.Sequence)()
    sequece:AppendInterval(1)
    sequece:Append(((((self.ui).tran_heroHeadList):DOLocalMoveX(maskWidth - headListWidth, 4)):SetRelative(true)):SetEase(cs_EaseLinear))
    sequece:AppendInterval(1)
    sequece:SetAutoKill(false)
    sequece:SetLoops(-1)
    self._heroHeadSeq = sequece
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
end

UINWCChipDetailCombat._ClearHeroHeadSequece = function(self)
  -- function num : 0_3
  if self._heroHeadSeq ~= nil then
    (self._heroHeadSeq):Kill()
    self._heroHeadSeq = nil
  end
end

UINWCChipDetailCombat._InitFightPower = function(self, chipData, dynPlayer, powerType, isOwnData)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).obj_PowerNode):SetActive(dynPlayer == nil)
  if dynPlayer == nil then
    return 
  end
  self.fightPower = 0
  if powerType == eChipDetailPowerType.Add or powerType == nil then
    ((self.ui).obj_PowerNode):SetActive(true)
    self.fightPower = dynPlayer:GetChipDiscardFightPower(chipData)
    ;
    ((self.ui).tex_Power):SetIndex(0, GetPreciseDecimalStr(self.fightPower, 1))
  elseif powerType == eChipDetailPowerType.Subtract then
    ((self.ui).obj_PowerNode):SetActive(true)
    self.fightPower = dynPlayer:GetChipDiscardFightPower(chipData)
    ;
    ((self.ui).tex_Power):SetIndex(1, GetPreciseDecimalStr(self.fightPower, 1))
  else
    ((self.ui).obj_PowerNode):SetActive(false)
  end
  if self.fightPower == 0 then
    self:SetAddSuitFxActive(false)
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UINWCChipDetailCombat._SetTacticNodeActive = function(self, active, index)
  -- function num : 0_5
  ((self.ui).obj_TacticNode):SetActive(active)
  if not index then
    ((self.ui).text_TacticNode):SetIndex(not active or 0)
    ;
    ((self.ui).textEn_TacticNode):SetIndex(index or 0)
  end
end

UINWCChipDetailCombat.GetWCChipDetailPanelData = function(self)
  -- function num : 0_6
  return self._chipData
end

UINWCChipDetailCombat.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  self:_ClearHeroHeadSequece()
  ;
  (base.OnDelete)(self)
end

return UINWCChipDetailCombat

