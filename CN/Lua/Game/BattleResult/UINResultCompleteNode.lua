-- params : ...
-- function num : 0 , upvalues : _ENV
local UINResultCompleteNode = class("UINResultCompleteNode", UIBaseNode)
UINResultCompleteNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINResultCompleteNode.InitResultCompleteTime = function(self, frame, isCheat, isNew)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_ErrorIcon, self, self.__OnBtnErrorIcon)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_FloatingBG, self, self.__OnBtnFloatingBG)
  ;
  (((self.ui).btn_ErrorIcon).gameObject):SetActive(true)
  ;
  ((self.ui).completeTime):SetIndex(0)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = (BattleUtil.FrameToTimeString)(frame, true)
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(8801))
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Content).text = (LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(8802))
  if isNew then
    ((self.ui).img_NewIcon):SetActive(not isCheat)
    ;
    ((self.ui).img_Error):SetActive(isCheat)
    self.isShowFloatingFrame = false
    ;
    ((self.ui).obj_floatingFrame):SetActive(self.isShowFloatingFrame)
    ;
    (((self.ui).btn_FloatingBG).gameObject):SetActive(self.isShowFloatingFrame)
  end
end

UINResultCompleteNode.InitResultCompleteItem = function(self, index, des, isNew)
  -- function num : 0_2
  (((self.ui).btn_ErrorIcon).gameObject):SetActive(false)
  ;
  ((self.ui).completeTime):SetIndex(index)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = des
  ;
  ((self.ui).img_NewIcon):SetActive(isNew or false)
end

UINResultCompleteNode.__OnBtnErrorIcon = function(self)
  -- function num : 0_3
  self.isShowFloatingFrame = not self.isShowFloatingFrame
  ;
  ((self.ui).obj_floatingFrame):SetActive(self.isShowFloatingFrame)
  ;
  (((self.ui).btn_FloatingBG).gameObject):SetActive(self.isShowFloatingFrame)
end

UINResultCompleteNode.__OnBtnFloatingBG = function(self)
  -- function num : 0_4
  self.isShowFloatingFrame = false
  ;
  ((self.ui).obj_floatingFrame):SetActive(self.isShowFloatingFrame)
  ;
  (((self.ui).btn_FloatingBG).gameObject):SetActive(self.isShowFloatingFrame)
end

return UINResultCompleteNode

