-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.CommonUI.Chip.UINBaseChipDetail")
local UINWCChipDetail = class("UINWCChipDetail", base)
local cs_PropertyNameHash = ((CS.UGUIExtend).Ui3DModifier).propertyNameHash
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
UINWCChipDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, base, cs_PropertyNameHash
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (base.OnInit)(self)
  self.defaultChipSize = (Vector3.New)((self.ui).v_Scale, (self.ui).v_Scale, (self.ui).v_Scale)
  self._selected = true
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Select, self, self._OnBtnWCChipSelected)
  if not IsNull((self.ui).root) then
    self._defaultRootPos = ((self.ui).root).localPosition
    self._refreshRootPos = (Vector3.New)((self._defaultRootPos).x, (self._defaultRootPos).y + 60, (self._defaultRootPos).z)
  end
  self.effPrefabDic = {}
  self.dissolveMat = (((CS.UnityEngine).Object).Instantiate)((self.ui).Mat_fXMImage)
  self.initDissolveMat = true
  do
    if self.initDissolveMat and not IsNull(((self.ui).modifier).material) then
      local matrix = (((self.ui).modifier).material):GetMatrix(cs_PropertyNameHash)
      ;
      (self.dissolveMat):SetMatrix(cs_PropertyNameHash, matrix)
      self.initDissolveMat = false
    end
    for i = 1, #(self.ui).Img_ButtomList do
      local image = ((self.ui).Img_ButtomList)[i]
      if not IsNull(image) then
        image.material = self.dissolveMat
      end
    end
    ;
    ((self.ui).Obj_discard):SetActive(false)
    ;
    (base.SetBaseBackground)(self, ((self.ui).Fad_Item).transform)
    self:SetIsSellOutActive(false)
  end
end

UINWCChipDetail.InitWCChipDetail = function(self, index, chipData, resloader, selectEvent, isNeedPrice)
  -- function num : 0_1 , upvalues : base
  (base.InitBaseChipDetail)(self, index, chipData, nil, resloader)
  self._selectEvent = selectEvent
  if isNeedPrice then
    self.price = chipData:GetChipBuyPriceForWarChess()
  end
end

UINWCChipDetail.GetWCChipDetailPanelData = function(self)
  -- function num : 0_2
  return self._chipData
end

UINWCChipDetail.SetWCChipSelectState = function(self, selected, time)
  -- function num : 0_3 , upvalues : cs_Ease, _ENV
  local tweenTime = time == nil and 0 or 0.3
  if self._selected == selected then
    return 
  end
  self._selected = selected
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Description).raycastTarget = selected and true or false
  ;
  (((self.ui).img_unSelected):DOFade(self._selected and 0 or 0.4, tweenTime)):SetEase(cs_Ease.OutQuad)
  if self._selected then
    ((self.transform):DOScale((Vector3.New)(1, 1, 1), tweenTime)):SetEase(cs_Ease.OutQuad)
  else
    ;
    ((self.transform):DOScale(self.defaultChipSize, tweenTime)):SetEase(cs_Ease.OutQuad)
  end
end

UINWCChipDetail.InitWCChipSelectState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self._selected = false
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Description).raycastTarget = false
  ;
  (((self.ui).img_unSelected).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_unSelected).color = (Color.New)(0, 0, 0, 0)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).localScale = self.defaultChipSize
end

UINWCChipDetail.SetIsSellOutActive = function(self, bActive)
  -- function num : 0_5
  if (self.ui).obj_isSellout ~= nil and ((self.ui).obj_isSellout).activeSelf ~= bActive then
    ((self.ui).obj_isSellout):SetActive(bActive)
  end
end

UINWCChipDetail._OnBtnWCChipSelected = function(self)
  -- function num : 0_6
  if self._selectEvent ~= nil then
    (self._selectEvent)(self, self._chipData)
  end
end

UINWCChipDetail.ShowWCChipDetailEff = function(self, xRotate)
  -- function num : 0_7 , upvalues : _ENV
  if self.effItemData ~= nil then
    ((self.effItemData).go):SetActive(false)
    ;
    ((self.effItemData).eff):Stop()
  end
  if not (self.level):HasFlashTween() then
    return 
  end
  local quality = (self._chipData):GetQuality()
  local path = ChipDetailEffPatch[quality]
  local effItemData = (self.effPrefabDic)[quality]
  if effItemData ~= nil then
    (effItemData.eff):Play()
    ;
    (effItemData.go):SetActive(true)
    self.effItemData = effItemData
    return 
  end
  ;
  (self._resloader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_7_0 , upvalues : _ENV, self, effItemData, xRotate, quality
    if IsNull(prefab) then
      return 
    end
    if self.ui == nil then
      return 
    end
    if (self.ui).tran_EffHolder == nil or IsNull(((self.ui).tran_EffHolder).gameObject) then
      return 
    end
    effItemData = {}
    local go = prefab:Instantiate((self.ui).tran_EffHolder)
    local particleSystem = go:GetComponentInChildren(typeof((CS.UnityEngine).ParticleSystem))
    particleSystem:Stop()
    ;
    (go.transform):Rotate((Vector3.New)(xRotate or 0, 0, 0))
    particleSystem:Play()
    effItemData.go = go
    effItemData.eff = particleSystem
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.effPrefabDic)[quality] = effItemData
    self.effItemData = effItemData
  end
)
end

UINWCChipDetail.OnDissolveTweenCompleteAction = function(self, Action)
  -- function num : 0_8
  self.onDissolveTweenComplete = Action
end

UINWCChipDetail.PlayDissolveTween = function(self)
  -- function num : 0_9 , upvalues : cs_DoTween
  self:InitDissolveTweenSetting()
  if self.dissolveSeq ~= nil then
    (self.dissolveSeq):Restart()
    return 
  end
  local dissolveSeq = (cs_DoTween.Sequence)()
  dissolveSeq:SetAutoKill(false)
  dissolveSeq:SetLink(self.gameObject)
  dissolveSeq:InsertCallback(0, function()
    -- function num : 0_9_0 , upvalues : self
    ((self.dissolveMat):DOFloat(0, "_add", 0.35)):SetLink(self.gameObject)
    ;
    ((self.dissolveMat):DOFloat(0.36, "_DissolutionAlpha", 0.35)):SetLink(self.gameObject)
  end
)
  dissolveSeq:AppendInterval(0.35)
  dissolveSeq:AppendCallback(function()
    -- function num : 0_9_1 , upvalues : self
    ((self.dissolveMat):DOFloat(0.5, "_add", 0.35)):SetLink(self.gameObject)
    ;
    ((self.dissolveMat):DOFloat(0, "_DissolutionAlpha", 0.35)):SetLink(self.gameObject)
    ;
    (((self.ui).Fad_Item):DOFade(0, 0.35)):SetLink(self.gameObject)
    ;
    ((self.ui).Obj_discard):SetActive(true)
  end
)
  dissolveSeq:AppendInterval((((self.ui).Ani_discard).clip).length)
  dissolveSeq:OnComplete(function()
    -- function num : 0_9_2 , upvalues : self
    ((self.ui).Obj_discard):SetActive(false)
    if self.onDissolveTweenComplete ~= nil then
      (self.onDissolveTweenComplete)(self.index)
    end
  end
)
  self.dissolveSeq = dissolveSeq
end

UINWCChipDetail.InitDissolveTweenSetting = function(self)
  -- function num : 0_10
  ((self.ui).Obj_discard):SetActive(false)
  ;
  ((self.ui).Fad_Item):DOKill()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).Fad_Item).alpha = 1
  ;
  (self.dissolveMat):DOKill()
  ;
  (self.dissolveMat):SetFloat("_add", 1)
  ;
  (self.dissolveMat):SetFloat("_DissolutionAlpha", 0)
end

UINWCChipDetail.UnSelectAlpha = function(self, boolean)
  -- function num : 0_11
end

UINWCChipDetail.SetSelectAnima = function(self, active)
  -- function num : 0_12
end

UINWCChipDetail.KillDOTween = function(self)
  -- function num : 0_13
  ((self.ui).img_unSelected):DOKill()
  ;
  (self.transform):DOKill()
end

UINWCChipDetail.OnHide = function(self)
  -- function num : 0_14 , upvalues : base
  (base.OnHide)(self)
end

UINWCChipDetail.OnDelete = function(self)
  -- function num : 0_15 , upvalues : base
  self:KillDOTween()
  ;
  (base.OnDelete)(self)
end

return UINWCChipDetail

