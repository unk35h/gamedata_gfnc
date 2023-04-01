-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAprilFoolDunItem = class("UINAprilFoolDunItem", UIBaseNode)
local base = UIBaseNode
local cs_Material = (CS.UnityEngine).Material
local cs_MessageCommon = CS.MessageCommon
UINAprilFoolDunItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_dungeonItem, self, self.__OnClickLevel)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.__OnClickRefresh)
end

UINAprilFoolDunItem.InitAprilFoolDunItem = function(self, index, ARDctrl, ARDDunData, resloader)
  -- function num : 0_1
  self.index = index
  self.ARDctrl = ARDctrl
  self.ARDDunData = ARDDunData
  self.resloader = resloader
  self.ARDData = (self.ARDDunData).ARDData
  self:__RefreshLevelHeroPic()
  self:__RefreshIsComplete()
  self:__RefreshTag()
  self:__RefreshCouldExchange()
end

UINAprilFoolDunItem.__RefreshLevelHeroPic = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local picName = (self.ARDDunData):GetARDDLevelPicName()
  if (string.IsNullOrEmpty)(picName) then
    return 
  end
  local path = PathConsts:GetAprilFoolLevelPath(picName)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_HeroPIc).enabled = false
  ;
  (self.resloader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if IsNull(((self.ui).img_HeroPIc).transform) then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_HeroPIc).texture = texture
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_HeroPIc).enabled = true
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Completed).texture = texture
  end
)
end

UINAprilFoolDunItem.__RefreshIsComplete = function(self)
  -- function num : 0_3 , upvalues : cs_Material
  local isComplete = (self.ARDDunData):GetARDDunIsCompleted()
  ;
  (((self.ui).img_Completed).gameObject):SetActive(isComplete)
  if isComplete and self.__completeMaskMat == nil then
    self.__completeMaskMat = cs_Material((self.ui).mat_ImageMask)
  end
end

UINAprilFoolDunItem.__RefreshTag = function(self)
  -- function num : 0_4
  local diff = (self.ARDDunData):GetARDDLevelTag()
  ;
  ((self.ui).tex_Tag):SetIndex(diff - 1)
end

UINAprilFoolDunItem.__RefreshCouldExchange = function(self)
  -- function num : 0_5
  local couldExchange = (self.ARDDunData):GetCouldExchange()
  ;
  (((self.ui).btn_Refresh).gameObject):SetActive(couldExchange)
end

UINAprilFoolDunItem.__OnClickLevel = function(self)
  -- function num : 0_6
  if not (self.ARDDunData):GetARDDunIsCompleted() then
    (self.ARDctrl):EnterARDDungeonFormation(self.ARDDunData)
  end
end

UINAprilFoolDunItem.__OnClickRefresh = function(self)
  -- function num : 0_7 , upvalues : _ENV, cs_MessageCommon
  local ARDData = (self.ARDDunData).ARDData
  local exchangeMaxNum = ARDData:GetARDMAXExchangeTime()
  local exchangeNum = ARDData:GetARDExchangeTime()
  local RealRefrsh = function()
    -- function num : 0_7_0 , upvalues : self, _ENV
    local actId = ((self.ARDDunData).ARDData):GetActId()
    local dunId = (self.ARDDunData):GetARDDunId()
    ;
    (self.ARDctrl):ARDDunRefresh(actId, dunId, function()
      -- function num : 0_7_0_0 , upvalues : _ENV, self
      AudioManager:PlayAudioById(1212)
      self.ARDDunData = (self.ARDData):GetARDDataByDunIndex(self.index)
      self:__RefreshLevelHeroPic()
      self:__RefreshIsComplete()
      self:__RefreshTag()
      self:__RefreshCouldExchange()
    end
)
  end

  if exchangeMaxNum <= exchangeNum then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7302))
  else
    local message = (string.format)(ConfigData:GetTipContent(7305), tostring(exchangeMaxNum - exchangeNum))
    ;
    (cs_MessageCommon.ShowMessageBox)(message, RealRefrsh, nil)
  end
end

UINAprilFoolDunItem.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, base
  if self.__completeMaskMat ~= nil then
    DestroyUnityObject(self.__completeMaskMat)
  end
  ;
  (base.OnDelete)(self)
end

return UINAprilFoolDunItem

