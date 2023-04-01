-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventInvitationMain = class("UINEventInvitationMain", UIBaseNode)
local base = UIBaseNode
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local UINEventNInvitationStageItem = require("Game.ActivityInvitation.UI.UINEventNInvitationStageItem")
local UINEventInvitationPlayerItem = require("Game.ActivityInvitation.UI.UINEventInvitationPlayerItem")
UINEventInvitationMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventNInvitationStageItem, UINEventInvitationPlayerItem, UINUserHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Copy, self, self.OnClickCopy)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Invite, self, self.OnClickInvite)
  self._itemPool = (UIItemPool.New)(UINEventNInvitationStageItem, (self.ui).itemNode)
  ;
  ((self.ui).itemNode):SetActive(false)
  self._playerPool = (UIItemPool.New)(UINEventInvitationPlayerItem, (self.ui).playerNode)
  ;
  ((self.ui).playerNode):SetActive(false)
  self._resloader = ((CS.ResLoader).Create)()
  self._headItem = (UINUserHead.New)()
  ;
  (self._headItem):Init((self.ui).uINUserHead)
  self.__OnLookInvitationUserCallback = BindCallback(self, self.__OnLookInvitationUser)
  self.__OnRewardStageCallback = BindCallback(self, self.__OnRewardStage)
  self.RefreshInvitationMainCallback = BindCallback(self, self.RefreshInvitationMain)
  MsgCenter:AddListener(eMsgEventId.ActivityInvitation, self.RefreshInvitationMainCallback)
  self._emptyList = {(self.ui).empty}
end

UINEventInvitationMain.InitInvitationMain = function(self, invitationData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._invitationData = invitationData
  self._callback = callback
  ;
  (self._headItem):InitUserHeadUI((PlayerDataCenter.inforData):GetAvatarId(), (PlayerDataCenter.inforData):GetAvatarFrameId(), self._resloader)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).text_code).text = (self._invitationData):GetInvitationCode()
  self:RefreshInvitationMain()
end

UINEventInvitationMain.RefreshInvitationMain = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self._invitationData):IsInvitationReturnUser() then
    (((self.ui).btn_Invite).gameObject):SetActive(not (self._invitationData):IsInvitationReturnPicked())
    if ((self._itemPool).listItem)[1] == nil then
      local cfgs = (self._invitationData):GetInvitaionRewardCfg()
      for i,_ in ipairs(cfgs) do
        local item = (self._itemPool):GetOne()
        item:InitInvitationStageItem(i, self._invitationData, self.__OnRewardStageCallback)
      end
    else
      do
        for i,v in ipairs((self._itemPool).listItem) do
          v:RefreshInvitationStageItem()
        end
        do
          for i,v in ipairs((self._playerPool).listItem) do
            v:RefreshInvitationPlayerItem()
          end
          local invitees = (self._invitationData):GetInvitationInvitees()
          for i = #(self._playerPool).listItem + 1, #invitees do
            local item = (self._playerPool):GetOne()
            item:SetInvitationPlayerItem(invitees[i], self._resloader, self.__OnLookInvitationUserCallback)
          end
          local emptyCount = #(self._itemPool).listItem - #invitees
          for i = 1, emptyCount do
            local emptyUI = (self._emptyList)[i]
            if emptyUI == nil then
              emptyUI = ((self.ui).empty):Instantiate((((self.ui).empty).transform).parent)
              ;
              (table.insert)(self._emptyList, emptyUI)
            end
            emptyUI:SetActive(true)
            ;
            (emptyUI.transform):SetAsLastSibling()
          end
          for i = emptyCount + 1, #self._emptyList do
            ((self._emptyList)[i]):SetActive(false)
          end
          local curCount = #(self._playerPool).listItem
          local totalCount = #(self._itemPool).listItem
          -- DECOMPILER ERROR at PC130: Confused about usage of register: R5 in 'UnsetPending'

          ;
          ((self.ui).slider).value = (curCount - 1) / (totalCount - 1)
          ;
          ((self.ui).tex_stage):SetIndex(0, tostring(curCount), tostring(totalCount))
        end
      end
    end
  end
end

UINEventInvitationMain.OnClickCopy = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ((CS.UnityEngine).GUIUtility).systemCopyBuffer = (self._invitationData):GetInvitationCode()
  AudioManager:PlayAudioById(1124)
  ;
  ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(7703))
end

UINEventInvitationMain.OnClickInvite = function(self)
  -- function num : 0_4
  if self._callback ~= nil then
    (self._callback)()
  end
end

UINEventInvitationMain.__OnLookInvitationUser = function(self, uid)
  -- function num : 0_5 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.UserFreined, function(win)
    -- function num : 0_5_0 , upvalues : _ENV, uid
    if win == nil then
      return 
    end
    UIManager:HideWindow(UIWindowTypeID.ActivityFrameMain)
    win:InitUserFriend()
    win:OnClickSearch(uid)
    win:SetUserFriendCallback(function()
      -- function num : 0_5_0_0 , upvalues : _ENV
      UIManager:ShowWindowOnly(UIWindowTypeID.ActivityFrameMain)
    end
)
  end
)
end

UINEventInvitationMain.__OnRewardStage = function(self, index, item)
  -- function num : 0_6 , upvalues : _ENV
  (self._invitationData):ReqInvitationPicked(index, function()
    -- function num : 0_6_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefreshInvitationMain()
    end
  end
)
end

UINEventInvitationMain.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.ActivityInvitation, self.RefreshInvitationMainCallback)
  ;
  (base.OnDelete)(self)
end

return UINEventInvitationMain

