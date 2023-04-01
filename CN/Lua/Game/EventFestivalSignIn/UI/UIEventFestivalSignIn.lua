-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventFestivalSignIn = class("UIEventFestivalSignIn", UIBaseWindow)
local base = UIBaseWindow
local UINEventFestivalSignList = require("Game.EventFestivalSignIn.UI.UINEventFestivalSignList")
UIEventFestivalSignIn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Background, self, self.OnClickClose)
  ;
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  self.resloader = ((CS.ResLoader).Create)()
end

UIEventFestivalSignIn.InitEventFestivalSignIn = function(self, id, isShowCloseBtn)
  -- function num : 0_1 , upvalues : _ENV
  ;
  (((self.ui).btn_Background).gameObject):SetActive(isShowCloseBtn or false)
  self._isShowCloseBtn = isShowCloseBtn
  local signData = ((PlayerDataCenter.eventNoviceSignData).dataDic)[id]
  signData:SetPoped()
  local signCfg = signData:GetSignCfg()
  self:_LoadSignList(signData, signCfg.list_style, isShowCloseBtn)
  local path = PathConsts:GetFestivalSignPath(signCfg.sign_prefab)
  ;
  (self.resloader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_1_0 , upvalues : _ENV, self, path, signData
    if IsNull(prefab) then
      return 
    end
    local go = prefab:Instantiate((self.ui).reHolder)
    local bind = {}
    ;
    (UIUtil.LuaUIBindingTable)(go.transform, bind)
    if IsNull(bind.tex_Time) then
      error("bind.tex_Time is nil, path:" .. path)
      return 
    end
    local dateFormat = (bind.tex_Time).text
    local startTs = signData:GetActivityBornTime()
    local endTs = signData:GetActivityDestroyTime()
    local startTimeStr = (os.date)(dateFormat, startTs)
    local endTimeStr = (os.date)(dateFormat, endTs)
    local text = startTimeStr .. "-" .. endTimeStr
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (bind.tex_Time).text = text
  end
)
  self:_LoadBackgroundPic(signCfg)
end

UIEventFestivalSignIn._LoadSignList = function(self, signData, prefabName, isShowCloseBtn)
  -- function num : 0_2 , upvalues : _ENV, UINEventFestivalSignList
  local path = PathConsts:GetFestivalSignPath(prefabName)
  ;
  (self.resloader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_2_0 , upvalues : _ENV, self, UINEventFestivalSignList, signData, isShowCloseBtn
    if IsNull(prefab) then
      return 
    end
    local go = prefab:Instantiate((self.ui).rightHolder)
    local signListNode = (UINEventFestivalSignList.New)()
    signListNode:Init(go)
    signListNode:InitEventFestivalSignList(signData, isShowCloseBtn, BindCallback(self, self.OnClickClose))
    self.signListNode = signListNode
  end
)
end

UIEventFestivalSignIn.UpdUIFestivalSignIn = function(self)
  -- function num : 0_3
  if self.signListNode ~= nil then
    (self.signListNode):UpdUIFestivalSignInList()
  end
end

UIEventFestivalSignIn.SetCloseCallback = function(self, callback)
  -- function num : 0_4
  self.closeCallback = callback
end

UIEventFestivalSignIn.FestivalSignOutOfDate = function(self)
  -- function num : 0_5 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_5_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    win:ShowTextBoxWithConfirm(ConfigData:GetTipContent(6033), function()
      -- function num : 0_5_0_0 , upvalues : self, _ENV
      if self._isShowCloseBtn then
        self:OnClickClose()
      else
        ;
        (UIUtil.OnClickBack)()
      end
    end
)
  end
)
end

UIEventFestivalSignIn._LoadBackgroundPic = function(self, signCfg)
  -- function num : 0_6 , upvalues : _ENV
  local path = PathConsts:GetFestivalBgPath(signCfg.BG_name)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Bg).enabled = false
  ;
  (self.resloader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_6_0 , upvalues : _ENV, self, signCfg
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

    if texture ~= nil and not IsNull(self.gameObject) then
      ((self.ui).img_Bg).enabled = true
      -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_Bg).texture = texture
      local x = (signCfg.BG_pos)[1] or 0
      local y = (signCfg.BG_pos)[2] or 0
      local z = (signCfg.BG_pos)[3] or 0
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (((self.ui).img_Bg).transform).anchoredPosition = (Vector3.New)(x, y, z)
      local w = (signCfg.BG_size)[1] or 0
      local h = (signCfg.BG_size)[2] or 0
      -- DECOMPILER ERROR at PC56: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (((self.ui).img_Bg).transform).sizeDelta = (Vector2.New)(w, h)
    end
  end
)
end

UIEventFestivalSignIn.BackAction = function(self)
  -- function num : 0_7
  self:Delete()
end

UIEventFestivalSignIn.OnClickClose = function(self)
  -- function num : 0_8 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIEventFestivalSignIn.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  (self.resloader):Put2Pool()
  self.resloader = nil
  if self.signListNode ~= nil then
    (self.signListNode):Delete()
  end
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  ;
  (base.OnDelete)(self)
end

return UIEventFestivalSignIn

