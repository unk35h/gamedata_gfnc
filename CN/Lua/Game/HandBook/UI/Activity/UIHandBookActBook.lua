-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHandBookActBook = class("UIHandBookActBook", UIBaseWindow)
local base = UIBaseWindow
local UINHandBookActTag = require("Game.HandBook.UI.Activity.UINHandBookActTag")
local eActivityClass = (require("Game.HandBook.HandBookEnum")).eActivityClass
local cs_Tweening = (CS.DG).Tweening
local CS_DOTween = ((CS.DG).Tweening).DOTween
local eEnterType = (require("Game.HandBook.HandBookEnum")).eEnterType
UIHandBookActBook.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHandBookActTag, eActivityClass, eEnterType
  (UIUtil.SetTopStatus)(self, self.OnCloseActBook)
  self._tagPool = (UIItemPool.New)(UINHandBookActTag, (self.ui).btn_ActItem)
  ;
  ((self.ui).btn_ActItem):SetActive(false)
  self._tagFuncTable = {[eActivityClass.LargeScale] = BindCallback(self, self.OnClickLagerAct), [eActivityClass.Festival] = BindCallback(self, self.OnClickFesAct), [eActivityClass.HeroGrow] = BindCallback(self, self.OnClickExcAct)}
  self._cfg = ConfigData.handbook_activity
  local enterType = eEnterType.Activity
  local cfg = (ConfigData.handbook)[enterType]
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).hBNameCN).text = (LanguageUtil.GetLocaleText)(cfg.title)
  -- DECOMPILER ERROR at PC57: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).hBNameEN).text = (LanguageUtil.GetLocaleText)(cfg.title_en)
end

UIHandBookActBook.InitHandBookActBook = function(self, worldPos, callback)
  -- function num : 0_1 , upvalues : _ENV, cs_Tweening
  self._hbCtrl = ControllerManager:GetController(ControllerTypeId.HandBook)
  self._callback = callback
  ;
  (self._tagPool):HideAll()
  for i,cfg in ipairs(self._cfg) do
    local func = (self._tagFuncTable)[i]
    if func ~= nil then
      local parentTr = ((self.ui).posRects)[i]
      if parentTr ~= nil then
        local tagName = (LanguageUtil.GetLocaleText)(cfg.activity_class)
        local item = (self._tagPool):GetOne()
        item:InitHandBookActTag(tagName, func)
        ;
        (item.transform):SetParent(parentTr)
        -- DECOMPILER ERROR at PC41: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (item.transform).anchoredPosition = Vector2.zero
        item:PlayBookTagAni(i * 0.033)
      end
    end
  end
  ;
  ((self.ui).uI_HandBookActBook):Play()
  ;
  ((((self.ui).activityBook):DOMove(worldPos, 0.2)):From()):SetEase((cs_Tweening.Ease).OutCirc)
  ;
  ((((self.ui).activityBook):DOScale((Vector2.New)(1.73, 1.84), 0.2)):From()):SetEase((cs_Tweening.Ease).OutCirc)
end

UIHandBookActBook._CheckActBookValid = function(self, activityClassId)
  -- function num : 0_2 , upvalues : _ENV
  local bookCfg = (ConfigData.handbook_activity)[activityClassId]
  if bookCfg == nil or bookCfg.content_count <= 0 then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(170))
    return false
  end
  return true
end

UIHandBookActBook.OnClickLagerAct = function(self)
  -- function num : 0_3 , upvalues : eActivityClass, _ENV
  if not self:_CheckActBookValid(eActivityClass.LargeScale) then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HandBookActBookFes, function(win)
    -- function num : 0_3_0 , upvalues : _ENV, self, eActivityClass
    if IsNull(win) then
      return 
    end
    self:__HideActBook()
    ;
    (self._hbCtrl):SetHBViewSetLayer(2, (LanguageUtil.GetLocaleText)(((self._cfg)[eActivityClass.LargeScale]).activity_class))
    win:InitActBookFes(eActivityClass.LargeScale, function()
      -- function num : 0_3_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:__ShowActBook()
        ;
        (self._hbCtrl):SetHBViewSetLayer(1)
      end
    end
)
  end
)
end

UIHandBookActBook.OnClickFesAct = function(self)
  -- function num : 0_4 , upvalues : eActivityClass, _ENV
  if not self:_CheckActBookValid(eActivityClass.Festival) then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HandBookActBookFes, function(win)
    -- function num : 0_4_0 , upvalues : _ENV, self, eActivityClass
    if IsNull(win) then
      return 
    end
    self:__HideActBook()
    ;
    (self._hbCtrl):SetHBViewSetLayer(2, (LanguageUtil.GetLocaleText)(((self._cfg)[eActivityClass.Festival]).activity_class))
    win:InitActBookFes(eActivityClass.Festival, function()
      -- function num : 0_4_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:__ShowActBook()
        ;
        (self._hbCtrl):SetHBViewSetLayer(1)
      end
    end
)
  end
)
end

UIHandBookActBook.OnClickExcAct = function(self)
  -- function num : 0_5 , upvalues : eActivityClass, _ENV
  if not self:_CheckActBookValid(eActivityClass.HeroGrow) then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HandBookActBookEx, function(win)
    -- function num : 0_5_0 , upvalues : _ENV, self, eActivityClass
    if IsNull(win) then
      return 
    end
    self:__HideActBook()
    ;
    (self._hbCtrl):SetHBViewSetLayer(2, (LanguageUtil.GetLocaleText)(((self._cfg)[eActivityClass.HeroGrow]).activity_class))
    win:InitActBookEx(eActivityClass.HeroGrow, function()
      -- function num : 0_5_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:__ShowActBook()
        ;
        (self._hbCtrl):SetHBViewSetLayer(1)
      end
    end
)
  end
)
end

UIHandBookActBook.__HideActBook = function(self)
  -- function num : 0_6 , upvalues : CS_DOTween, _ENV
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
  self._tween = (CS_DOTween.Sequence)()
  ;
  (self._tween):Append(((self.ui).canvasGroup):DOFade(0.2, 0.1))
  ;
  (self._tween):Join((((self.ui).canvasGroup).transform):DOScale(0.8, 0.1))
  ;
  (self._tween):AppendCallback(function()
    -- function num : 0_6_0 , upvalues : self, _ENV
    (self._tween):Kill()
    self._tween = nil
    self:Hide()
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).canvasGroup).alpha = 1
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (((self.ui).canvasGroup).transform).localScale = Vector3.one
  end
)
end

UIHandBookActBook.__ShowActBook = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if not self.active then
    self:Show()
  else
    ;
    (self._tween):Kill()
    self._tween = nil
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).canvasGroup).alpha = 1
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (((self.ui).canvasGroup).transform).localScale = Vector3.one
  end
end

UIHandBookActBook.OnCloseActBook = function(self)
  -- function num : 0_8
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIHandBookActBook.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  (self._tagPool):DeleteAll()
  ;
  ((self.ui).activityBook):DOComplete()
  ;
  ((self.ui).canvasGroup):DOComplete()
  ;
  (((self.ui).canvasGroup).transform):DOComplete()
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIHandBookActBook

