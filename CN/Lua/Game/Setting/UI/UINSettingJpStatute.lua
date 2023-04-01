-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINSettingJpStatute = class("UINSettingJpStatute", base)
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
local cs_Application = (CS.UnityEngine).Application
UINSettingJpStatute.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Return, self, self._OnClickWebReturn)
  for k,btn in ipairs((self.ui).btn_UrlList) do
    do
      (UIUtil.AddButtonListener)(btn, self, function()
    -- function num : 0_0_0 , upvalues : self, k, _ENV
    local url = ((self.ui).str_UrlList)[k]
    if (string.IsNullOrEmpty)(url) then
      error("url IsNullOrEmpty")
      return 
    end
    if GameSystemInfo.Platform == (GameSystemInfo.PlatformType).Windows then
      (((CS.UnityEngine).Application).OpenURL)(url)
    else
      ;
      ((self.ui).uniWebViewGo):SetActive(true)
      ;
      ((self.ui).uniWebView):SetZoomEnabled(false)
      ;
      ((self.ui).uniWebView):SetBackButtonEnabled(false)
      ;
      ((self.ui).uniWebView):Load(url)
      ;
      ((self.ui).uniWebView):Show(false)
      self._initUniwebview = true
    end
  end
)
    end
  end
  self._OnItemChangeFunc = BindCallback(self, self._OnItemChange)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
end

UINSettingJpStatute.InitSettingJpStatute = function(self)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).tex_CountPaid):SetIndex(0, tostring(PlayerDataCenter:GetItemCoutNoMerge(ConstGlobalItem.PaidQZ)))
  ;
  ((self.ui).tex_CountFree):SetIndex(0, tostring(PlayerDataCenter:GetItemCoutNoMerge(ConstGlobalItem.PaidItem)))
end

UINSettingJpStatute._OnItemChange = function(self, itemUpdateDic)
  -- function num : 0_2 , upvalues : _ENV
  if itemUpdateDic[ConstGlobalItem.PaidQZ] ~= nil then
    ((self.ui).tex_CountPaid):SetIndex(0, tostring(PlayerDataCenter:GetItemCoutNoMerge(ConstGlobalItem.PaidQZ)))
  end
  if itemUpdateDic[ConstGlobalItem.PaidItem] ~= nil then
    ((self.ui).tex_CountFree):SetIndex(0, tostring(PlayerDataCenter:GetItemCoutNoMerge(ConstGlobalItem.PaidItem)))
  end
end

UINSettingJpStatute._OnClickWebReturn = function(self)
  -- function num : 0_3
  ((self.ui).uniWebView):Hide()
  ;
  ((self.ui).uniWebViewGo):SetActive(false)
end

UINSettingJpStatute.OnHide = function(self)
  -- function num : 0_4 , upvalues : base
  if self._initUniwebview then
    ((self.ui).uniWebView):CleanCache()
  end
  ;
  (base.OnHide)(self)
end

UINSettingJpStatute.OnDelete = function(self)
  -- function num : 0_5 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  ;
  (base.OnDelete)(self)
end

return UINSettingJpStatute

