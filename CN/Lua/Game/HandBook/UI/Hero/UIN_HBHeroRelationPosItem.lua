-- params : ...
-- function num : 0 , upvalues : _ENV
local UIN_HBHeroRelationPosItem = class("UIN_HBHeroRelationPosItem", UIBaseNode)
local base = UIBaseNode
local cs_DoTweenLoopType = ((CS.DG).Tweening).LoopType
UIN_HBHeroRelationPosItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__orgPos = (self.transform).position
  self.__nearLine = ((((self.ui).obj_relationship).transform):Find("Line_near")).transform
  self.__farLine = ((((self.ui).obj_relationship).transform):Find("Line_far")).transform
  self.__relationship = ((((self.ui).obj_relationship).transform):Find("Relationship")).transform
  self.__end = ((((self.ui).obj_line).transform):Find("End")).transform
  self.__lineCG = ((self.ui).obj_line):GetComponent(typeof((CS.UnityEngine).CanvasGroup))
  self.__lineSmallSize = (Vector2.New)(0, ((((self.ui).obj_line).transform).sizeDelta).y)
end

UIN_HBHeroRelationPosItem.InitHBRHHead = function(self, index)
  -- function num : 0_1 , upvalues : _ENV
  self.index = index
  self.isRight = index <= 3
  self.isHorizontal = index == 2 or index == 5
  local flag = self.isRight and 1 or -1
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__farLine).anchoredPosition = (Vector2.New)(flag * 13, 0)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__nearLine).anchoredPosition = (Vector2.New)(flag * -13, 0)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIN_HBHeroRelationPosItem.HideAll = function(self)
  -- function num : 0_2
  ((self.ui).obj_ray):SetActive(false)
  ;
  ((self.ui).obj_line):SetActive(false)
  self.heroHeadItem = nil
end

UIN_HBHeroRelationPosItem.SetHeroHead = function(self, heroHeadItem, cfg, mainHeroId)
  -- function num : 0_3 , upvalues : _ENV
  self.heroId = cfg.related_hero
  self.mainHeroId = mainHeroId
  self.heroHeadItem = heroHeadItem
  self.cfg = cfg
  ;
  ((self.ui).obj_ray):SetActive(true)
  ;
  ((self.ui).obj_line):SetActive(true)
  self:__AdjustRay()
  ;
  (heroHeadItem.transform):SetParent(self.transform, false)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (heroHeadItem.transform).localPosition = Vector3.zero
end

UIN_HBHeroRelationPosItem.__AdjustLine2Center = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local fullSzie = (((self.ui).obj_line).transform).sizeDelta
  local relationSize = (self.__relationship).sizeDelta
  local gap = 13
  local flag = self.isRight and 1 or -1
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R5 in 'UnsetPending'

  if self.isHorizontal then
    (self.__relationship).anchoredPosition = (Vector2.New)(flag * fullSzie.x / 2, 0)
    local lineLength = (fullSzie.x - relationSize.x) / 2 + gap
    local size = (Vector2.New)(lineLength, 32)
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.__farLine).sizeDelta = size
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.__nearLine).sizeDelta = size
  else
    do
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.__relationship).anchoredPosition = (Vector2.New)(flag * (fullSzie.x - 100), 0)
      -- DECOMPILER ERROR at PC59: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.__farLine).sizeDelta = (Vector2.New)(100 - relationSize.x / 2 + gap, 32)
      -- DECOMPILER ERROR at PC71: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.__nearLine).sizeDelta = (Vector2.New)(fullSzie.x - relationSize.x / 2 - 100 + gap, 32)
    end
  end
end

UIN_HBHeroRelationPosItem.__AdjustRay = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local heroRelationDic = (ConfigData.hero_relationship)[self.heroId]
  if heroRelationDic == nil then
    ((self.ui).obj_ray):SetActive(false)
  end
  local isHaveOtherRelation = false
  for index,cfg in pairs(heroRelationDic) do
    if cfg.related_hero ~= self.mainHeroId then
      isHaveOtherRelation = true
      break
    end
  end
  do
    ;
    ((self.ui).obj_ray):SetActive(isHaveOtherRelation)
  end
end

UIN_HBHeroRelationPosItem.PlayLineScale = function(self)
  -- function num : 0_6 , upvalues : _ENV, cs_DoTweenLoopType
  self:__ClearTween()
  ;
  ((self.ui).obj_normal):SetActive(true)
  ;
  ((self.ui).obj_relationship):SetActive(false)
  ;
  (((((self.ui).obj_line).transform):DOSizeDelta(self.__lineSmallSize, 0.5)):From()):OnComplete(function()
    -- function num : 0_6_0 , upvalues : self, _ENV
    local isHaveDes = (self.cfg).line_des ~= nil and (self.cfg).line_des ~= 0
    ;
    ((self.ui).obj_normal):SetActive(not isHaveDes)
    ;
    ((self.ui).obj_relationship):SetActive(isHaveDes)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R1 in 'UnsetPending'

    if isHaveDes then
      ((self.ui).tex_Relationship).text = (LanguageUtil.GetLocaleText)((self.cfg).line_des)
      ;
      ((((CS.UnityEngine).UI).LayoutRebuilder).ForceRebuildLayoutImmediate)(self.__relationship)
      self:__AdjustLine2Center()
      ;
      ((((self.ui).obj_relationship).transform):DOScaleY(0.2, 0.2)):From()
    end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
)
  ;
  (((self.__end):DOLocalMoveX(0, 0.2)):From()):SetDelay(0.3)
  ;
  (((self.__lineCG):DOFade(0, 0.1)):From()):SetLoops(3, cs_DoTweenLoopType.Restart)
  ;
  (((((self.ui).obj_ray).transform):DOScale(0, 0.3)):From()):SetDelay(0.5)
end

UIN_HBHeroRelationPosItem.__ClearTween = function(self)
  -- function num : 0_7
  (((self.ui).obj_line).transform):DOComplete()
  ;
  (((self.ui).obj_relationship).transform):DOComplete()
  ;
  (self.__end):DOComplete()
  ;
  (self.__lineCG):DOComplete()
  ;
  (((self.ui).obj_ray).transform):DOComplete()
end

UIN_HBHeroRelationPosItem.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  self:__ClearTween()
  ;
  (base.OnDelete)(self)
end

return UIN_HBHeroRelationPosItem

