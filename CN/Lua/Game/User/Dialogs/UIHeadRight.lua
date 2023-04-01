-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHeadRight = class("UIHeadRight", UIBaseNode)
local base = UIBaseNode
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
UIHeadRight.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnChangeConfirm)
  self.isHead = true
  self.infoUI = UIManager:GetWindow(UIWindowTypeID.UserInfo)
  self.savedHeadItem = nil
  self.savedHeadFrameItem = nil
  self.userHeadNode = (UINUserHead.New)()
  ;
  (self.userHeadNode):Init((self.ui).obj_UINUserHead)
end

UIHeadRight.BindHeadRightResloader = function(self, resloader)
  -- function num : 0_1
  self.resloader = resloader
end

UIHeadRight.BindCloseFun = function(self, onCloseCallback)
  -- function num : 0_2
  self._onCloseCallback = onCloseCallback
end

UIHeadRight.OnChangeConfirm = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.infoUI == nil then
    self.infoUI = UIManager:GetWindow(UIWindowTypeID.UserInfo)
  end
  if self.savedHeadItem ~= nil and (self.savedHeadItem).id ~= (PlayerDataCenter.inforData).avatarId then
    if PlayerDataCenter:IsItemOutTime((self.savedHeadItem).id) then
      ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(6041))
    else
      ;
      (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_User_AvatarModify((self.savedHeadItem).id, function()
    -- function num : 0_3_0 , upvalues : self
    (self.infoUI):RefreshUserHead((self.savedHeadItem).id)
  end
)
    end
  end
  if self.savedHeadFrameItem ~= nil and (self.savedHeadFrameItem).id ~= (PlayerDataCenter.inforData).avatarFrameId then
    if PlayerDataCenter:IsItemOutTime((self.savedHeadItem).id) then
      ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(6041))
    else
      ;
      (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_User_AvatarFrameMod((self.savedHeadFrameItem).id, function()
    -- function num : 0_3_1 , upvalues : self
    (self.infoUI):RefreshUserHeadFrame((self.savedHeadFrameItem).id)
  end
)
    end
  end
  ;
  (self._onCloseCallback)()
end

UIHeadRight.SaveHead = function(self, itemHeadCfg)
  -- function num : 0_4
  if itemHeadCfg == nil or (self.itemHeadCfg).count == 0 then
    self.savedHeadItem = nil
    return 
  end
  self.savedHeadItem = itemHeadCfg
end

UIHeadRight.SaveHeadFrame = function(self, itemHeadFrameCfg)
  -- function num : 0_5
  if itemHeadFrameCfg == nil or (self.itemHeadFrameCfg).count == 0 then
    self.savedHeadFrameItem = nil
    return 
  end
  self.savedHeadFrameItem = itemHeadFrameCfg
end

UIHeadRight.changeHeadState = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self.itemHeadCfg ~= nil and (self.itemHeadCfg).cfg ~= nil then
    (self.userHeadNode):InitBaseHead((self.itemHeadCfg).id, self.resloader)
  else
    return 
  end
  if (self.itemHeadCfg).count == 0 then
    (((self.ui).btn_Confirm).gameObject):SetActive(false)
    ;
    ((self.ui).img_Locked):SetActive(true)
    ;
    (((self.ui).tex_CurEquip).gameObject):SetActive(false)
  else
    ;
    (((self.ui).btn_Confirm).gameObject):SetActive(true)
    ;
    ((self.ui).img_Locked):SetActive(false)
    ;
    (((self.ui).tex_CurEquip).gameObject):SetActive(true)
  end
  ;
  (((self.ui).tex_Condition).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Condition).text = (LanguageUtil.GetLocaleText)(((self.itemHeadCfg).cfg).describe_name)
  -- DECOMPILER ERROR at PC77: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (LanguageUtil.GetLocaleText)(((self.itemHeadCfg).cfg).name)
  self.outTime = (self.itemHeadCfg).outTime
  if self.outTime ~= -1 then
    ((self.ui).obj_time):SetActive(true)
    self:StartUpdateTimeText()
  else
    ;
    ((self.ui).obj_time):SetActive(false)
  end
end

UIHeadRight.changeHeadFrameState = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.itemHeadFrameCfg ~= nil and (self.itemHeadFrameCfg).cfg ~= nil then
    (self.userHeadNode):InitBaseHeadFrame((self.itemHeadFrameCfg).id, self.resloader)
  else
    return 
  end
  if (self.itemHeadFrameCfg).count == 0 then
    (((self.ui).btn_Confirm).gameObject):SetActive(false)
    ;
    ((self.ui).img_Locked):SetActive(true)
    ;
    (((self.ui).tex_CurEquip).gameObject):SetActive(false)
  else
    ;
    (((self.ui).btn_Confirm).gameObject):SetActive(true)
    ;
    ((self.ui).img_Locked):SetActive(false)
    ;
    (((self.ui).tex_CurEquip).gameObject):SetActive(true)
  end
  ;
  (((self.ui).tex_Condition).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Condition).text = (LanguageUtil.GetLocaleText)(((self.itemHeadFrameCfg).cfg).achieve_name)
  -- DECOMPILER ERROR at PC77: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (LanguageUtil.GetLocaleText)(((self.itemHeadFrameCfg).cfg).name)
  self.outTime = (self.itemHeadFrameCfg).outTime
  if self.outTime ~= -1 then
    ((self.ui).obj_time):SetActive(true)
    self:StartUpdateTimeText()
  else
    ;
    ((self.ui).obj_time):SetActive(false)
  end
end

UIHeadRight.StartUpdateTimeText = function(self)
  -- function num : 0_8 , upvalues : _ENV
  TimerManager:StopTimer(self.LimitTimeItemTimerId)
  self.LimitTimeItemTimerId = TimerManager:StartTimer(5, self.RefreshTime, self, false, false)
  self:RefreshTime()
end

UIHeadRight.RefreshTime = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local diffTime = self.outTime - PlayerDataCenter.timestamp
  if diffTime > 0 then
    local d, h, m, s = TimeUtil:TimestampToTimeInter(diffTime, false, true)
    if d > 0 then
      ((self.ui).tex_time):SetIndex(0, tostring(d), tostring(h))
    else
      if h > 0 then
        ((self.ui).tex_time):SetIndex(1, tostring(h), tostring(m))
      else
        if m > 0 then
          ((self.ui).tex_time):SetIndex(2, tostring(m))
        else
          ;
          ((self.ui).tex_time):SetIndex(2, tostring(1))
        end
      end
    end
  else
    do
      TimerManager:StopTimer(self.LimitTimeItemTimerId)
      ;
      ((self.ui).tex_time):SetIndex(3)
    end
  end
end

UIHeadRight.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  TimerManager:StopTimer(self.LimitTimeItemTimerId)
  ;
  (base.OnDelete)(self)
end

return UIHeadRight

