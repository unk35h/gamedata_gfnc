-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFormationChioceCareerTog = class("UINFormationChioceCareerTog", UIBaseNode)
local base = UIBaseNode
UINFormationChioceCareerTog.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Filtrate, self, self.OnValueChangeCareer)
  self._allFilterSprite = ((self.ui).img_Icon).sprite
  self._allFilterDes = ((self.ui).tex_Naem).text
end

UINFormationChioceCareerTog.InitCareerTog = function(self, careerId, onValueChange)
  -- function num : 0_1 , upvalues : _ENV
  self._OnValueChange = onValueChange
  self.__refreshCallback = self.OnValueChangeCareer
  self.careerId = careerId
  ;
  ((self.ui).obj_HasEvaluation):SetActive(false)
  local careerCfg = (ConfigData.career)[self.careerId]
  ;
  (((self.ui).img_Icon).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

  if careerCfg ~= nil then
    ((self.ui).img_Icon).sprite = CRH:GetSprite(careerCfg.icon, CommonAtlasType.CareerCamp)
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Naem).text = (LanguageUtil.GetLocaleText)(careerCfg.name)
  else
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = self._allFilterSprite
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Naem).text = self._allFilterDes
  end
end

UINFormationChioceCareerTog.InitCompany = function(self, companyId, onValueChange)
  -- function num : 0_2 , upvalues : _ENV
  self._OnValueChange = onValueChange
  self.__refreshCallback = self.OnValueChangeCompany
  ;
  ((self.ui).obj_HasEvaluation):SetActive(false)
  self.companyId = companyId
  local companyCfg = (ConfigData.camp)[companyId]
  if companyCfg ~= nil then
    (((self.ui).img_Icon).gameObject):SetActive(false)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = CRH:GetSprite(companyCfg.icon, CommonAtlasType.CareerCamp)
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Naem).text = (LanguageUtil.GetLocaleText)(companyCfg.editor_filter_name)
  else
    ;
    (((self.ui).img_Icon).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = self._allFilterSprite
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Naem).text = self._allFilterDes
  end
end

UINFormationChioceCareerTog.SetEvaluation = function(self, isAdvantage)
  -- function num : 0_3
  ((self.ui).obj_HasEvaluation):SetActive(isAdvantage)
end

UINFormationChioceCareerTog.OnValueChangeCareer = function(self, flag)
  -- function num : 0_4 , upvalues : _ENV
  if flag and self._OnValueChange ~= nil then
    if not self._notClickTog then
      if self.careerId == 0 then
        AudioManager:PlayAudioById(4100)
      else
        local careerCfg = (ConfigData.career)[self.careerId]
        AudioManager:PlayAudioById(careerCfg.click_audio)
      end
    end
    do
      ;
      (self._OnValueChange)(self.careerId, self)
    end
  end
end

UINFormationChioceCareerTog.OnValueChangeCompany = function(self, flag)
  -- function num : 0_5 , upvalues : _ENV
  if flag and self._OnValueChange ~= nil then
    if not self._notClickTog then
      if self.companyId == 0 then
        AudioManager:PlayAudioById(4100)
      else
        local campCfg = (ConfigData.camp)[self.companyId]
        AudioManager:PlayAudioById(campCfg.camp_audio)
      end
    end
    do
      ;
      (self._OnValueChange)(self.companyId, self)
    end
  end
end

UINFormationChioceCareerTog.SetTogState = function(self, flag)
  -- function num : 0_6
  if ((self.ui).tog_Filtrate).isOn == flag then
    self._notClickTog = true
    ;
    (self.__refreshCallback)(self, flag)
    self._notClickTog = false
  else
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tog_Filtrate).isOn = flag
  end
end

return UINFormationChioceCareerTog

