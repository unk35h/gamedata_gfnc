-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDunTowerSelectItem = class("UINDunTowerSelectItem", UIBaseNode)
local base = UIBaseNode
local cs_TweenLoop = ((CS.DG).Tweening).LoopType
local cs_Ease = ((CS.DG).Tweening).Ease
UINDunTowerSelectItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_towerItem, self, self.OnSelectItemClick)
end

UINDunTowerSelectItem.InitTowerSelectItem = function(self, catId, clickEvent, name)
  -- function num : 0_1
  self.__catId = catId
  self.__clickEvent = clickEvent
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_TowerName).text = name
  ;
  ((self.ui).img_Tower):SetIndex(catId)
  ;
  ((self.ui).img_Icon):SetIndex(catId)
  self:SetTowerSelected(false, true)
end

UINDunTowerSelectItem.SetTowerSelected = function(self, selected, isinit)
  -- function num : 0_2 , upvalues : _ENV, cs_Ease, cs_TweenLoop
  local looptime = 9
  local delaytime = selected and 0.02 or 0.04
  local pos = ((self.transform).localPosition).y
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).cg_tower).alpha = selected and 1 or 0.6
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R6 in 'UnsetPending'

  if isinit then
    (((self.ui).img_Select).transform).localPosition = (Vector3.New)(174, ((self.transform).localPosition).y, 0)
    return 
  end
  self:__ClearTween()
  if selected then
    ((((self.ui).img_Select).transform):DOLocalMoveY(pos, 0.25)):SetEase(cs_Ease.OutQuad)
    ;
    (((((self.ui).img_Select):DOFade(0.3, 0.04)):From()):SetLoops(looptime + 2, cs_TweenLoop.Yoyo)):SetDelay(delaytime)
  end
  self:__PlayFrameShakeTween(looptime, delaytime)
end

UINDunTowerSelectItem.SetTowerReddot = function(self, active)
  -- function num : 0_3
  ((self.ui).redDot_tower):SetActive(active)
end

UINDunTowerSelectItem.SetTowerBluedot = function(self, active)
  -- function num : 0_4
  ((self.ui).blueDot_tower):SetActive(active)
end

UINDunTowerSelectItem.__PlayInitTween = function(self, __selectItem)
  -- function num : 0_5 , upvalues : cs_Ease, cs_TweenLoop
  local delaytime = (1 + self.__catId) * 0.05
  if self.__catId >= 1 then
    (((((((self.ui).img_IconAlpha).transform).parent):DOLocalMoveY(-30, 0.4)):From()):SetDelay((self.__catId - 1) * 0.1)):SetEase(cs_Ease.OutQuad)
    ;
    (((((self.ui).img_Select).transform):DOLocalMoveY(((__selectItem.transform).localPosition).y - 20, 0.3)):From()):SetEase(cs_Ease.OutQuad)
    ;
    (((((self.ui).img_Select):DOFade(0.3, 0.04)):From()):SetLoops(7, cs_TweenLoop.Restart)):SetDelay(delaytime)
  end
  ;
  ((((self.ui).cg_tower):DOFade(0, 0.3)):From()):SetDelay(self.__catId * 0.1)
  self:__PlayFrameShakeTween(7, delaytime)
end

UINDunTowerSelectItem.__PlayFrameShakeTween = function(self, looptime, delaytime)
  -- function num : 0_6 , upvalues : cs_TweenLoop
  (((((self.ui).img_IconAlpha):DOFade(0.3, 0.03)):From()):SetLoops(looptime, cs_TweenLoop.Restart)):SetDelay(delaytime)
  ;
  (((((self.ui).tex_TowerName):DOFade(0.4, 0.03)):From()):SetLoops(looptime, cs_TweenLoop.Restart)):SetDelay(delaytime)
  ;
  (((((self.ui).img_Frame):DOFade(0.34, 0.03)):From()):SetLoops(looptime, cs_TweenLoop.Restart)):SetDelay(delaytime)
end

UINDunTowerSelectItem.OnSelectItemClick = function(self)
  -- function num : 0_7
  if self.__clickEvent ~= nil and not ((self.ui).anim).isPlaying then
    (self.__clickEvent)(self.__catId, self)
  end
end

UINDunTowerSelectItem.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  ((((self.ui).img_IconAlpha).transform).parent):DOKill()
  ;
  (((self.ui).img_Select).transform):DOKill()
  ;
  ((self.ui).img_Select):DOKill()
  ;
  ((self.ui).img_IconAlpha):DOKill()
  ;
  ((self.ui).img_Frame):DOKill()
  ;
  ((self.ui).tex_TowerName):DOKill()
  ;
  ((self.ui).cg_tower):DOKill()
  ;
  (base.OnDelete)(self)
end

UINDunTowerSelectItem.__ClearTween = function(self)
  -- function num : 0_9
  ((((self.ui).img_IconAlpha).transform).parent):DOComplete()
  ;
  (((self.ui).img_Select).transform):DOComplete()
  ;
  ((self.ui).img_Select):DOComplete()
  ;
  ((self.ui).img_IconAlpha):DOComplete()
  ;
  ((self.ui).img_Frame):DOComplete()
  ;
  ((self.ui).tex_TowerName):DOComplete()
  ;
  ((self.ui).cg_tower):DOComplete()
end

return UINDunTowerSelectItem

