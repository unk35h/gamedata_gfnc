-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChangeName = class("UIChangeName", UIBaseNode)
local base = UIBaseNode
local CS_MessageCommon = CS.MessageCommon
local RenameHelper = require("Game.CommonUI.Rename.RenameHelper")
UIChangeName.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.CloseFunction)
  local num = PlayerDataCenter:GetItemCount((ConfigData.game_config).changeNameItemId)
  num = num + PlayerDataCenter:GetItemCount((ConfigData.game_config).limitTimeChangeNameItemId)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_RenameCard).text = num
  local maxInputNum = (ConfigData.game_config).playerNameLengthLimit
  self.characterLimit = maxInputNum
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).username_inputField).characterLimit = maxInputNum
  ;
  ((self.ui).tex_textTips_1):SetIndex(0, tostring(maxInputNum))
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnChangeNameConfirm)
end

UIChangeName.OnChangeNameConfirm = function(self)
  -- function num : 0_1 , upvalues : _ENV, CS_MessageCommon, RenameHelper
  local inputUserName = ((self.ui).username_inputField).text
  if (string.IsNullOrEmpty)(inputUserName) then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.login_EmptyName))
    return 
  end
  if inputUserName == (PlayerDataCenter.inforData):GetUserName() then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(176))
    return 
  end
  local inputLength = RenameHelper:GetNameLength(inputUserName)
  if self.characterLimit < inputLength then
    inputUserName = RenameHelper:ClampNameInLength(inputUserName, self.characterLimit)
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).username_inputField).text = inputUserName
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_1_0 , upvalues : _ENV, inputUserName, self
    if win == nil then
      return 
    end
    local confimFunc = function()
      -- function num : 0_1_0_0 , upvalues : _ENV, inputUserName, self
      (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_User_UserNameModify(inputUserName, function()
        -- function num : 0_1_0_0_0 , upvalues : self, _ENV
        if not self.isFromStore then
          local infoUI = UIManager:GetWindow(UIWindowTypeID.UserInfo)
          if infoUI ~= nil then
            infoUI:RefreshPlayerInfo()
          end
        end
      end
)
      ;
      (self.CloseFunction)()
    end

    win:ShowTextBoxWithYesAndNo((string.format)(ConfigData:GetTipContent(175), inputUserName), confimFunc)
  end
)
end

UIChangeName.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UIChangeName

