-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDormReplaceHero = class("UIDormReplaceHero", UIBaseWindow)
local base = UIBaseWindow
local DormUtil = require("Game.Dorm.DormUtil")
UIDormReplaceHero.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.Delete)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self.Delete)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
end

UIDormReplaceHero.InitDmReplaceHero = function(self, otherRoomData, heroData, roomdata, confimFunc)
  -- function num : 0_1 , upvalues : _ENV, DormUtil
  self.confimFunc = confimFunc
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Hero).sprite = CRH:GetHeroSkinSprite(heroData.dataId, heroData.skinId)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).Text_BeforName).text = (string.format)("%02d", otherRoomData:GetDmRoomIndex()) .. "-" .. otherRoomData:GetName()
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).Text_AfterName).text = (string.format)("%02d", roomdata:GetDmRoomIndex()) .. "-" .. roomdata:GetName()
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).img_beforepos).transform).anchoredPosition = (DormUtil.ToRectTransformPos)(otherRoomData.x, otherRoomData.y)
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).img_afterpos).transform).localPosition = (DormUtil.ToRectTransformPos)(roomdata.x, roomdata.y)
end

UIDormReplaceHero.OnClickConfirm = function(self)
  -- function num : 0_2
  if self.confimFunc ~= nil then
    (self.confimFunc)()
  end
  self:Delete()
end

UIDormReplaceHero.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UIDormReplaceHero

