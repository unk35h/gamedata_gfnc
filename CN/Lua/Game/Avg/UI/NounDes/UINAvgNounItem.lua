-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAvgNounItem = class("UINAvgNounItem", UIBaseNode)
local UINAvgNounDetailNode = require("Game.Avg.UI.NounDes.UINAvgNounDetailNode")
local base = UIBaseNode
local cs_Ease = ((CS.DG).Tweening).Ease
UINAvgNounItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_nounItem, self, self.OnClickBtn)
end

UINAvgNounItem.InitNounItem = function(self, nounId, SetDetailNode, SetSelect)
  -- function num : 0_1 , upvalues : _ENV
  self.nounId = nounId
  self.nounCfg = (ConfigData.noun_des)[nounId]
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).text).text = (LanguageUtil.GetLocaleText)((self.nounCfg).name)
  self.nounstate = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetAvgNounIsRead(nounId)
  self.SetDetailNode = SetDetailNode
  self.SetSelect = SetSelect
  if self.nounstate then
    ((self.ui).obj_isNew):SetActive(false)
  else
    ;
    ((self.ui).obj_isNew):SetActive(true)
  end
end

UINAvgNounItem.BindNounStateReadEvent = function(self, stateEvent)
  -- function num : 0_2
  self.__readStateEvent = stateEvent
end

UINAvgNounItem.OnClickBtn = function(self)
  -- function num : 0_3 , upvalues : _ENV, cs_Ease
  self:SetNounItemAsRead()
  if self.SetDetailNode ~= nil then
    (self.SetDetailNode)(true)
  else
    error("callback nil")
  end
  if self.SetSelect ~= nil then
    (self.SetSelect)(((self.ui).obj_item).transform)
  else
    error("callback nil")
  end
  local AvgNounDesWin = UIManager:GetWindow(UIWindowTypeID.AvgNounDes)
  AvgNounDesWin.ItemClickDesId = self.nounId
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

  if AvgNounDesWin.IsDoPlay == nil then
    (AvgNounDesWin.DetailCanvas).alpha = 0
    ;
    ((AvgNounDesWin.DetailCanvas):DOFade(1, 0.25)):SetEase(cs_Ease.OutQuad)
    AvgNounDesWin.IsDoPlay = true
  end
  AvgNounDesWin:InitDetatilNode()
end

UINAvgNounItem.SetNounItemAsRead = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.nounstate then
    ((self.ui).obj_isNew):SetActive(false)
    ;
    (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SaveAvgNoun(self.nounId)
    self.nounstate = true
    if self.__readStateEvent ~= nil then
      (self.__readStateEvent)(self.nounId)
    end
  end
end

UINAvgNounItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINAvgNounItem

