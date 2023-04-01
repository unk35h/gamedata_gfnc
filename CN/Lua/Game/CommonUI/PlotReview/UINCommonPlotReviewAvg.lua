-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommonPlotReviewAvg = class("UINCommonPlotReviewAvg", UIBaseNode)
local base = UIBaseNode
UINCommonPlotReviewAvg.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_plotItem, self, self.OnClickPlayAvg)
end

UINCommonPlotReviewAvg.InitHeroPlotReviewAvg = function(self, avgId, AvgGroupData, RefreshBlueDot)
  -- function num : 0_1 , upvalues : _ENV
  self.AvgGroupData = AvgGroupData
  self.RefreshBlueDot = RefreshBlueDot
  self._avgCfg = (ConfigData.story_avg)[avgId]
  if self._avgCfg == nil then
    error("_avgCfg is NIL ")
    return 
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_PlotName).text = (LanguageUtil.GetLocaleText)((self._avgCfg).name)
  self:RefreshPlotReviewAvgReddot()
  self._isClientPlay = false
end

UINCommonPlotReviewAvg.SetAvgJustClientPlay = function(self)
  -- function num : 0_2
  self._isClientPlay = true
end

UINCommonPlotReviewAvg.OnClickPlayAvg = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
  local playOverCallbck = (self.AvgGroupData):GetAvgGroupDataPlayCallback()
  if self._isClientPlay then
    avgCtrl:ShowAvg((self._avgCfg).script_id, function()
    -- function num : 0_3_0 , upvalues : playOverCallbck, self
    if playOverCallbck ~= nil then
      playOverCallbck()
    end
    if self.RefreshBlueDot ~= nil then
      (self.RefreshBlueDot)()
    end
  end
)
  else
    avgCtrl:StartAvg((self._avgCfg).script_id, (self._avgCfg).id, function()
    -- function num : 0_3_1 , upvalues : playOverCallbck, self
    if playOverCallbck ~= nil then
      playOverCallbck()
    end
    if self.RefreshBlueDot ~= nil then
      (self.RefreshBlueDot)()
    end
  end
)
  end
end

UINCommonPlotReviewAvg.RefreshPlotReviewAvgReddot = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if not IsNull((self.ui).blueDot) then
    local flag = (self.AvgGroupData):IsAvgSingleReddot((self._avgCfg).id)
    ;
    ((self.ui).blueDot):SetActive(flag)
  end
end

return UINCommonPlotReviewAvg

