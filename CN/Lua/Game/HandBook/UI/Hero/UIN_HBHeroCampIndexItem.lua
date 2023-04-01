-- params : ...
-- function num : 0 , upvalues : _ENV
local UIN_HBHeroCampIndexItem = class("UIN_HBHeroCampIndexItem", UIBaseNode)
local base = UIBaseNode
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_DoTweenLoopType = ((CS.DG).Tweening).LoopType
UIN_HBHeroCampIndexItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_item, self, self.__OnClick)
end

UIN_HBHeroCampIndexItem.InitCampIndexItem = function(self, campCfg, handBookCtrl)
  -- function num : 0_1 , upvalues : _ENV
  self.campId = campCfg.id
  self.handBookCtrl = handBookCtrl
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_CampIcon).sprite = CRH:GetSprite(campCfg.icon, CommonAtlasType.CareerCamp)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Camp).text = (LanguageUtil.GetLocaleText)(campCfg.name)
  self:HBCIIRefreshCollectRate()
end

UIN_HBHeroCampIndexItem.HBCIIRefreshCollectRate = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local collectRate, totalNum = (self.handBookCtrl):GetCampHeroCollectNum(self.campId)
  ;
  ((self.ui).tex_Count):SetIndex(0, tostring(collectRate), tostring(totalNum))
end

UIN_HBHeroCampIndexItem.__OnClick = function(self)
  -- function num : 0_3 , upvalues : _ENV
  AudioManager:PlayAudioById(1221)
  UIManager:ShowWindowAsync(UIWindowTypeID.HandBookHeroCampHeroList, function(win)
    -- function num : 0_3_0 , upvalues : self, _ENV
    win:InitHBHeroHeroList(self.campId)
    UIManager:HideWindow(UIWindowTypeID.HandBookHeroCampIndex)
  end
)
end

UIN_HBHeroCampIndexItem.DoHBCampIndexItemZoomOutTween = function(self, index, totalNum)
  -- function num : 0_4 , upvalues : cs_DoTween, _ENV, cs_DoTweenLoopType
  local sequence = (cs_DoTween.Sequence)()
  local mid = totalNum // 2 + 1
  local step = mid - index
  local flag = step > 0 and 1 or -1
  if step == 0 then
    flag = 0
  end
  local absStrp = (math.abs)(step)
  local assTime = absStrp * 0.1
  if flag ~= 0 then
    local pos = (self.transform).localPosition
    local fromPos = (Vector3.New)(pos.x + step * 150 + (step - flag) * 70, pos.y, pos.z)
    sequence:Append(((self.transform):DOLocalMove(fromPos, 0.35 + assTime)):From())
  end
  do
    local scale = 0.85 ^ (absStrp + 1)
    sequence:Join(((self.transform):DOScale(scale, 0.35 + assTime)):From())
    local alpha = 1 - absStrp / (mid - 1)
    if alpha < 0.99 then
      sequence:Join((((self.ui).cg_item):DOFade(alpha, 0.5 + assTime)):From())
    end
    sequence:Join((((((self.ui).img_CampIcon).transform):DOLocalMoveY(0, 0.35)):From()):SetDelay(0.4 + assTime / 2))
    sequence:Join(((((self.ui).cg_progress).transform):DOLocalMoveY(-170, 0.3)):From())
    sequence:Join((((self.ui).cg_progress):DOFade(0, 0.3)):From())
    sequence:Join((((((self.ui).img_btnBg):DOFade(0.4, 0.1)):From()):SetLoops(3, cs_DoTweenLoopType.Yoyo)):SetDelay(assTime / 2))
    self.__sequence = sequence
  end
end

UIN_HBHeroCampIndexItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  if self.__sequence ~= nil then
    (self.__sequence):Kill()
    self.__sequence = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIN_HBHeroCampIndexItem

