-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDmCheckInRoomSlotItem = class("UINDmCheckInRoomSlotItem", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
UINDmCheckInRoomSlotItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_IconBtn, self, self._OnClickRoot)
end

UINDmCheckInRoomSlotItem.InitDmCheckInRoomSlotItem = function(self, clickFunc, roomData, fntData)
  -- function num : 0_1 , upvalues : _ENV
  self.clickFunc = clickFunc
  self.roomData = roomData
  self.fntData = fntData
  if fntData == nil then
    (((self.ui).HeroAvator).gameObject):SetActive(false)
    ;
    (((self.ui).addOrEmpty).gameObject):SetActive(true)
    ;
    ((self.ui).addOrEmpty):SetIndex(1)
    return 
  end
  local heroId = fntData:GetFntParam()
  if heroId == 0 then
    (((self.ui).HeroAvator).gameObject):SetActive(false)
    ;
    (((self.ui).addOrEmpty).gameObject):SetActive(true)
    ;
    ((self.ui).addOrEmpty):SetIndex(0)
    return 
  end
  ;
  (((self.ui).HeroAvator).gameObject):SetActive(true)
  ;
  (((self.ui).addOrEmpty).gameObject):SetActive(false)
  local heroData = PlayerDataCenter:GetHeroData(heroId)
  -- DECOMPILER ERROR at PC70: Confused about usage of register: R6 in 'UnsetPending'

  if heroData ~= nil then
    ((self.ui).img_HeroIcon).sprite = CRH:GetHeroSkinSprite(heroData.dataId, heroData.skinId)
  end
end

UINDmCheckInRoomSlotItem._OnClickRoot = function(self)
  -- function num : 0_2 , upvalues : cs_MessageCommon, _ENV
  if self.fntData == nil then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(2025))
    return 
  end
  if self.clickFunc ~= nil then
    (self.clickFunc)(self.roomData)
  end
end

UINDmCheckInRoomSlotItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINDmCheckInRoomSlotItem

