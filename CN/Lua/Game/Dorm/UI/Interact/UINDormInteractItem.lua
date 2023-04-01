-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDormInteractItem = class("UINDormInteractItem", UIBaseNode)
local DormEnum = require("Game.Dorm.DormEnum")
UINDormInteractItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Interact, self, self.OnInteractBtnClick)
end

UINDormInteractItem.InitInteractActionItem = function(self, interactAction, iconAtlas)
  -- function num : 0_1 , upvalues : _ENV
  self.interactAction = interactAction
  local desc, spriteName, title, hasNew = interactAction:GetActionData()
  local actionEnable = interactAction:GetInteractActionEnable()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Interact).text = desc
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_State).text = title
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = (AtlasUtil.GetResldSprite)(iconAtlas, spriteName)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).canvsGroup).alpha = actionEnable and 1 or 0.7
  if not hasNew or not (self.ui).col_HasNew then
    local buttomCol = Color.white
  end
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).img_Buttom).color = buttomCol
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_IsNew).enabled = hasNew
  if hasNew then
    (self.transform):SetAsFirstSibling()
  end
end

UINDormInteractItem.OnInteractBtnClick = function(self)
  -- function num : 0_2
  if self.interactAction ~= nil then
    (self.interactAction):InvokeInteractAction()
  end
end

UINDormInteractItem.OnDelete = function(self)
  -- function num : 0_3
end

return UINDormInteractItem

