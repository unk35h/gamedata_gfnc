-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpecWeaponSkillCompare = class("UINSpecWeaponSkillCompare", UIBaseNode)
local base = UIBaseNode
local UINSpecWeaponSkillComItem = require("Game.SpecWeapon.UI.UINSpecWeaponSkillComItem")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local cs_MessageCommon = CS.MessageCommon
local cs_Edge = ((CS.UnityEngine).RectTransform).Edge
UINSpecWeaponSkillCompare.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpecWeaponSkillComItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.Hide)
  self._oriSkillItem = (UINSpecWeaponSkillComItem.New)()
  ;
  (self._oriSkillItem):Init((self.ui).skillBeforeState)
  self._nowSkillItem = (UINSpecWeaponSkillComItem.New)()
  ;
  (self._nowSkillItem):Init((self.ui).skillAfterState)
  self.__OnShowStartCdTimeTipCallback = BindCallback(self, self.__OnShowStartCdTimeTip)
  self.__OnHideStartCdTimeTipCallback = BindCallback(self, self.__OnHideStartCdTimeTip)
  self.__OnShowIntroClickCallback = BindCallback(self, self.__OnShowIntroClick)
  ;
  (self._oriSkillItem):InjectSpecWeaponSkillComItem(self.__OnShowStartCdTimeTipCallback, self.__OnHideStartCdTimeTipCallback, self.__OnShowIntroClickCallback)
  ;
  (self._nowSkillItem):InjectSpecWeaponSkillComItem(self.__OnShowStartCdTimeTipCallback, self.__OnHideStartCdTimeTipCallback, self.__OnShowIntroClickCallback)
end

UINSpecWeaponSkillCompare.BindCompareHideFuncOnce = function(self, func)
  -- function num : 0_1
  self._hideFunc = func
end

UINSpecWeaponSkillCompare.SpecWeaponSkillCompare = function(self, oriSkillData, nowSkillData, resloader)
  -- function num : 0_2
  ((self.ui).tex_HasUpgrade):SetActive(false)
  ;
  ((self.ui).tex_before):SetActive(true)
  ;
  ((self.ui).tex_After):SetActive(true)
  ;
  ((self.ui).afterSkillNode):SetActive(true)
  ;
  (self._oriSkillItem):InitSpecWeaponSkillComItem(oriSkillData, resloader)
  ;
  (self._nowSkillItem):InitSpecWeaponSkillComItem(nowSkillData, resloader)
end

UINSpecWeaponSkillCompare.SpecWeaponSkillNewStep = function(self, skillData, resloader)
  -- function num : 0_3
  ((self.ui).tex_HasUpgrade):SetActive(true)
  ;
  ((self.ui).tex_before):SetActive(false)
  ;
  ((self.ui).tex_After):SetActive(false)
  ;
  ((self.ui).afterSkillNode):SetActive(false)
  ;
  (self._oriSkillItem):InitSpecWeaponSkillComItem(skillData, resloader)
  ;
  (self._oriSkillItem):PlaySpecWeaponTween()
end

UINSpecWeaponSkillCompare.__OnShowStartCdTimeTip = function(self, upgradeItem)
  -- function num : 0_4 , upvalues : _ENV, HAType, VAType
  local win = UIManager:ShowWindow(UIWindowTypeID.FloatingFrame)
  win:SetTitleAndContext(ConfigData:GetTipContent(617), ConfigData:GetTipContent(616))
  win:FloatTo(upgradeItem.transform, HAType.left, VAType.up)
end

UINSpecWeaponSkillCompare.__OnHideStartCdTimeTip = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.FloatingFrame)
  if win ~= nil then
    win:Hide()
    win:Clean3DModifier()
  end
end

UINSpecWeaponSkillCompare.__OnShowIntroClick = function(self, skillData, holder)
  -- function num : 0_6 , upvalues : _ENV, cs_Edge
  UIManager:ShowWindowAsync(UIWindowTypeID.RichIntro, function(win)
    -- function num : 0_6_0 , upvalues : self, holder, skillData, cs_Edge
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

    if win ~= nil then
      ((self.ui).holder).position = holder.position
      win:ShowIntroBySkillData((self.ui).holder, skillData, nil, nil, nil, nil, 1)
      win:SetIntroListPosition(cs_Edge.Right, cs_Edge.Top)
    end
  end
)
end

UINSpecWeaponSkillCompare.OnHide = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnHide)(self)
  if self._hideFunc ~= nil then
    (self._hideFunc)()
    self._hideFunc = nil
  end
end

return UINSpecWeaponSkillCompare

