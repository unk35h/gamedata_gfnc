-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHandBookMain = class("UIHandBookMain", UIBaseWindow)
local base = UIBaseWindow
local eEnterType = (require("Game.HandBook.HandBookEnum")).eEnterType
local cs_Tweening = (CS.DG).Tweening
local CS_ClientConsts = CS.ClientConsts
UIHandBookMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, CS_ClientConsts
  (UIUtil.SetTopStatus)(self, self.OnCloseHandBook)
  ;
  (UIUtil.AddButtonListener)((self.ui).heroRelation, self, self.OnClickHero)
  ;
  (UIUtil.AddButtonListener)((self.ui).skin, self, self.OnClickSkin)
  ;
  (UIUtil.AddButtonListener)((self.ui).activity, self, self.OnClickActivity)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).skin_slider).value = 0
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).hero_slider).value = 0
  self._lockedStateDic = {}
  if (CS.ClientConsts).IsAudit then
    for i,v in ipairs((self.ui).lockObjs) do
      v:SetActive(false)
    end
  end
  do
    if CS_ClientConsts.IsAudit then
      (((self.ui).activity).gameObject):SetActive(false)
    end
  end
end

UIHandBookMain.InitHandBookMain = function(self)
  -- function num : 0_1 , upvalues : _ENV, eEnterType
  self._hbCtrl = ControllerManager:GetController(ControllerTypeId.HandBook, true)
  self._refreshFunc = {[eEnterType.Hero] = BindCallback(self, self.__RefreshHBMainHero), [eEnterType.Skin] = BindCallback(self, self.__RefreshHBMainSkin), [eEnterType.Activity] = BindCallback(self, self.__RefreshHBMainActivity)}
  self._isInInit = true
  for enterType,cfg in pairs(ConfigData.handbook) do
    local flag = (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para1)
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R7 in 'UnsetPending'

    if not flag then
      (self._lockedStateDic)[enterType] = true
    end
    local refreshFunc = (self._refreshFunc)[enterType]
    if refreshFunc ~= nil then
      refreshFunc(true)
    else
      error("入口刷新方法不存在")
    end
  end
  self._isInInit = false
end

UIHandBookMain.OnClickHero = function(self)
  -- function num : 0_2 , upvalues : eEnterType
  if (self._lockedStateDic)[eEnterType.Hero] then
    return 
  end
  ;
  (self._hbCtrl):OpenHandBookHeroIndex()
end

UIHandBookMain.OnClickSkin = function(self)
  -- function num : 0_3 , upvalues : eEnterType
  if (self._lockedStateDic)[eEnterType.Skin] then
    return 
  end
  ;
  (self._hbCtrl):OpenHandBookHeroSkinTheme()
end

UIHandBookMain.OnClickActivity = function(self)
  -- function num : 0_4 , upvalues : eEnterType
  if (self._lockedStateDic)[eEnterType.Activity] then
    return 
  end
  ;
  (self._hbCtrl):OpenHandBookActivity((((self.ui).activity).transform).position)
end

UIHandBookMain.__GetLockedDes = function(self, enterType)
  -- function num : 0_5 , upvalues : _ENV
  local cfg = (ConfigData.handbook)[enterType]
  local des = (CheckCondition.GetUnlockInfoLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para1)
  return des
end

UIHandBookMain.CheckAndRefreshCollect = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for enterType,_ in pairs(self._lockedStateDic) do
    local cfg = (ConfigData.handbook)[enterType]
    local flag = (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para1)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

    if flag then
      (self._lockedStateDic)[enterType] = nil
      ;
      ((self._refreshFunc)[enterType])(true)
    end
  end
end

UIHandBookMain.RefreshHBCollectByType = function(self, enterType)
  -- function num : 0_7
  if not (self._lockedStateDic)[enterType] then
    ((self._refreshFunc)[enterType])()
  end
end

UIHandBookMain.__RefreshHBMainHero = function(self, isRefreshActive)
  -- function num : 0_8 , upvalues : eEnterType, _ENV, cs_Tweening
  local enterType = eEnterType.Hero
  local flag = not (self._lockedStateDic)[enterType]
  local cfg = (ConfigData.handbook)[enterType]
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

  if self._isInInit then
    ((self.ui).hero_hBNameCN).text = (LanguageUtil.GetLocaleText)(cfg.title)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).hero_hBNameEN).text = (LanguageUtil.GetLocaleText)(cfg.title_en)
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

    if not flag then
      ((self.ui).tex_hero_LockDes).text = self:__GetLockedDes(enterType)
    end
  end
  if isRefreshActive then
    ((self.ui).hero_lock):SetActive(not flag)
    ;
    (((self.ui).hero_slider).gameObject):SetActive(flag)
    if flag then
      (((self.ui).hero_tex_Percent).gameObject):SetActive(cfg.collect_bar)
      if flag and cfg.collect_bar then
        local count, totalCount = (self._hbCtrl):GetHBHeroAllCollect()
        local process = count / (totalCount or 1)
        process = (math.clamp)(process, 0, 1)
        -- DECOMPILER ERROR at PC82: Confused about usage of register: R8 in 'UnsetPending'

        ;
        ((self.ui).hero_tex_Percent).text = tostring((math.ceil)(process * 100)) .. "%"
        ;
        ((self.ui).hero_slider):DOComplete()
        ;
        (((self.ui).hero_slider):DOValue(process, 0.5)):SetEase((cs_Tweening.Ease).OutQuad)
      end
    end
  end
end

UIHandBookMain.__RefreshHBMainSkin = function(self, isRefreshActive)
  -- function num : 0_9 , upvalues : eEnterType, _ENV, cs_Tweening
  local enterType = eEnterType.Skin
  local flag = not (self._lockedStateDic)[enterType]
  local cfg = (ConfigData.handbook)[enterType]
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

  if self._isInInit then
    ((self.ui).skin_hBNameCN).text = (LanguageUtil.GetLocaleText)(cfg.title)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).skin_hBNameEN).text = (LanguageUtil.GetLocaleText)(cfg.title_en)
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

    if not flag then
      ((self.ui).tex_skin_LockDes).text = self:__GetLockedDes(enterType)
    end
  end
  if isRefreshActive then
    ((self.ui).skin_lock):SetActive(not flag)
    ;
    (((self.ui).skin_slider).gameObject):SetActive(flag)
    if flag then
      (((self.ui).skin_tex_Percent).gameObject):SetActive(cfg.collect_bar)
      if flag and cfg.collect_bar then
        local count, totalCount = (self._hbCtrl):GetHBSkinAllCollect()
        local process = count / (totalCount or 1)
        process = (math.clamp)(process, 0, 1)
        -- DECOMPILER ERROR at PC82: Confused about usage of register: R8 in 'UnsetPending'

        ;
        ((self.ui).skin_tex_Percent).text = tostring((math.floor)(process * 100)) .. "%"
        ;
        ((self.ui).skin_slider):DOComplete()
        ;
        (((self.ui).skin_slider):DOValue(process, 0.5)):SetEase((cs_Tweening.Ease).OutQuad)
      end
    end
  end
end

UIHandBookMain.__RefreshHBMainActivity = function(self, isRefreshActive)
  -- function num : 0_10 , upvalues : eEnterType, _ENV
  local enterType = eEnterType.Activity
  local flag = not (self._lockedStateDic)[enterType]
  do
    if self._isInInit then
      local cfg = (ConfigData.handbook)[enterType]
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).act_hBNameCN).text = (LanguageUtil.GetLocaleText)(cfg.title)
      -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).act_hBNameEN).text = (LanguageUtil.GetLocaleText)(cfg.title_en)
      -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

      if not flag then
        ((self.ui).tex_act_LockDes).text = self:__GetLockedDes(enterType)
      end
    end
    if isRefreshActive then
      ((self.ui).act_lock):SetActive(not flag)
    end
  end
end

UIHandBookMain.OnCloseHandBook = function(self)
  -- function num : 0_11 , upvalues : _ENV
  self:OnCloseWin()
  self:Delete()
  UIManager:DeleteWindow(UIWindowTypeID.HandBookBackground)
  ControllerManager:DeleteController(ControllerTypeId.HandBook)
end

return UIHandBookMain

