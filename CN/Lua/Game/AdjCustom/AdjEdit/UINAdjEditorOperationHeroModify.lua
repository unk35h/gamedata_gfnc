-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjEditorOperationHeroModify = class("UINAdjEditorOperationHeroModify", UIBaseNode)
local base = UIBaseNode
local baseScaleShowRadio = 100
UINAdjEditorOperationHeroModify.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, baseScaleShowRadio
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).slider, self, self.OnChangeSlider)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReSetPos, self, self.OnClickResetPos)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_IsMain, self, self.OnClickChangeMain)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickSelect)
  self._negativeScaleRadio = ((ConfigData.game_config).adjCustonSizeLimit)[1]
  self._positiveScaleRadio = ((ConfigData.game_config).adjCustonSizeLimit)[2]
  self._ignoreSlier = true
  -- DECOMPILER ERROR at PC49: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).slider).minValue = self._negativeScaleRadio * baseScaleShowRadio
  -- DECOMPILER ERROR at PC55: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).slider).maxValue = self._positiveScaleRadio * baseScaleShowRadio
  self._ignoreSlier = nil
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).textMin).text = tostring(self._negativeScaleRadio) .. "x"
  -- DECOMPILER ERROR at PC72: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).textMax).text = tostring(self._positiveScaleRadio) .. "x"
end

UINAdjEditorOperationHeroModify.InitAdjHeroModify = function(self, editorMain, heroModifyData)
  -- function num : 0_1 , upvalues : _ENV
  self._editorMain = editorMain
  self._heroModifyData = heroModifyData
  self._heroId = heroModifyData.dataId
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = ConfigData:GetHeroNameById(self._heroId)
  ;
  ((self.ui).mult):SetActive((self._editorMain):GetAdjCurCount() > 1)
  ;
  ((self.ui).img_Sel):SetActive(false)
  self:RefreshAdjHeroState()
  self:RefreshAdjHeroModify()
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINAdjEditorOperationHeroModify.RefreshAdjHeroModify = function(self)
  -- function num : 0_2 , upvalues : baseScaleShowRadio, _ENV
  self._ignoreSlier = true
  local showScale = (self._heroModifyData).size or 1
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).slider).value = showScale * baseScaleShowRadio
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_CurSize).text = tostring(showScale) .. "x"
  self._ignoreSlier = nil
  local _, isSelect = (self._editorMain):IsAdjHeroIdInPreset(self._heroId)
  if (self._heroModifyData).pos == nil and (self._heroModifyData).size == nil then
    do
      local canReset = not isSelect
      ;
      (((self.ui).btn_ReSetPos).gameObject):SetActive(canReset)
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end
end

UINAdjEditorOperationHeroModify.RefreshAdjHeroState = function(self)
  -- function num : 0_3
  local _, isSelect = (self._editorMain):IsAdjHeroIdInPreset(self._heroId)
  ;
  ((self.ui).img_Sel):SetActive(isSelect)
  ;
  (((self.ui).img_IsMain).gameObject):SetActive((self._editorMain):GetAdjMainHeroId() == self._heroId)
  if (self._heroModifyData).pos == nil and (self._heroModifyData).size == nil then
    do
      local canReset = not isSelect
      ;
      (((self.ui).btn_ReSetPos).gameObject):SetActive(canReset)
      ;
      (((self.ui).btn_ReSetPos).gameObject):SetActive(false)
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
end

UINAdjEditorOperationHeroModify.OnClickResetPos = function(self)
  -- function num : 0_4
  (self._editorMain):ResetAdjEditHeroPostion(self._heroId)
  self:RefreshAdjHeroModify()
end

UINAdjEditorOperationHeroModify.OnChangeSlider = function(self, value)
  -- function num : 0_5 , upvalues : baseScaleShowRadio, _ENV
  if self._ignoreSlier then
    return 
  end
  value = value / baseScaleShowRadio
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_CurSize).text = tostring(value) .. "x"
  ;
  (self._editorMain):SetAdjEditHeroScale(self._heroId, value)
end

UINAdjEditorOperationHeroModify.OnClickChangeMain = function(self)
  -- function num : 0_6
  if (self._editorMain):GetAdjMainHeroId() == self._heroId then
    return 
  end
  ;
  (self._editorMain):ChangeAdjMainHero()
end

UINAdjEditorOperationHeroModify.OnClickSelect = function(self)
  -- function num : 0_7
  local curCount = (self._editorMain):GetAdjCurCount()
  if curCount <= 1 then
    return 
  end
  local heroIndexDic = (self._editorMain):GetAdjEditAdjIndexDic()
  for modifyIndex = 1, curCount do
    if heroIndexDic[modifyIndex] == self._heroId then
      (self._editorMain):ChangeAdjModifyIndex(modifyIndex)
      break
    end
  end
end

return UINAdjEditorOperationHeroModify

