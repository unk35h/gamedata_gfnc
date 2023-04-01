-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFmtDebuffNode = class("UINFmtDebuffNode", UIBaseNode)
local base = UIBaseNode
UINFmtDebuffNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__onCloseSelectUI = BindCallback(self, self.__OnCloseSelectUI)
  self.__onUpdateSelectedDebuff = BindCallback(self, self.__OnUpdateSelectedDebuff)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Layer, self, self.OnClickBuffSelect)
end

UINFmtDebuffNode.RefreshDebuffNode = function(self, fmtCtrl, enterFmtData)
  -- function num : 0_1
  self.fmtCtrl = fmtCtrl
  self.enterFmtData = enterFmtData
  local fmtBuffSelect = (self.enterFmtData):GetPeridicFmtBuffSelect()
  ;
  ((self.ui).enemyPower):SetActive(fmtBuffSelect:IsShowEmenyPowerInFmtBuff())
  local buffIds = fmtBuffSelect:GetFmtBuffSelect()
  ;
  (self.fmtCtrl):OnFmtCtrlUpdateWCDebuffSelect(buffIds)
  self:RefreshBuffState()
end

UINFmtDebuffNode.OnClickBuffSelect = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local fmtBuffSelect = (self.enterFmtData):GetPeridicFmtBuffSelect()
  if fmtBuffSelect == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.PeriodicDebuffSelect, function(window)
    -- function num : 0_2_0 , upvalues : fmtBuffSelect, self
    if window ~= nil then
      window:InitDebuffSelect(fmtBuffSelect, self.__onUpdateSelectedDebuff, self.__onCloseSelectUI)
    end
  end
)
end

UINFmtDebuffNode.RefreshBuffState = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local fmtBuffSelect = (self.enterFmtData):GetPeridicFmtBuffSelect()
  if fmtBuffSelect == nil then
    return 
  end
  local permillageAll = fmtBuffSelect:GetFmtBuffCurAddScoreRate()
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Gain).text = tostring((math.floor)(permillageAll / 10)) .. "%"
  local layer = (math.floor)(permillageAll / 100)
  if layer <= 0 or not layer then
    layer = 0
  end
  ;
  ((self.ui).tex_Layer):SetIndex(0, tostring(layer))
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_EnemyPower).text = tostring(fmtBuffSelect:GetBuffEmenyPower(layer, 1))
end

UINFmtDebuffNode.__OnUpdateSelectedDebuff = function(self, selectedBuffIds)
  -- function num : 0_4
  (self.fmtCtrl):OnFmtCtrlUpdateWCDebuffSelect(selectedBuffIds)
end

UINFmtDebuffNode.__OnCloseSelectUI = function(self)
  -- function num : 0_5
  (self.fmtCtrl):OnFmtCtrlSelectWCDebuffOver()
  self:RefreshBuffState()
end

UINFmtDebuffNode.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINFmtDebuffNode

