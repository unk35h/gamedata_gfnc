-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoInfoTeamInfo = class("UINWarChessInfoInfoTeamInfo", base)
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
UINWarChessInfoInfoTeamInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessInfoInfoTeamInfo.SetWCIITeamInfo = function(self, teamData, curAP, maxAP)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).tex_TeamName).text = teamData:GetWCTeamName()
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Point).text = tostring(curAP) .. "/" .. tostring(maxAP)
  if WarChessSeasonManager:GetIsInWCSeasonIsInLobby() then
    (((self.ui).img_teamAP).gameObject):SetActive(false)
    return 
  else
    ;
    (((self.ui).img_teamAP).gameObject):SetActive(true)
  end
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R4 in 'UnsetPending'

  if curAP <= 0 then
    ((self.ui).img_teamAP).color = (self.ui).color_teamAPEmpty
  else
    -- DECOMPILER ERROR at PC47: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_teamAP).color = (self.ui).color_teamAPDefault
  end
end

UINWarChessInfoInfoTeamInfo.SetWCIITeamInfoIsSelected = function(self, isSelected)
  -- function num : 0_2
  ((self.ui).obj_img_Target):SetActive(isSelected)
end

UINWarChessInfoInfoTeamInfo.SetWCIITeamInfoOverraHeadIconId = function(self, iconAtlas, headIconId)
  -- function num : 0_3 , upvalues : _ENV
  if headIconId == nil then
    (((self.ui).img_TeamHeadIcon).gameObject):SetActive(false)
    return 
  end
  ;
  (((self.ui).img_TeamHeadIcon).gameObject):SetActive(true)
  if headIconId == nil then
    error("headIconId is nil")
    return 
  end
  if self.__headIconId == headIconId then
    return 
  end
  self.__headIconId = headIconId
  local headIconCfg = (ConfigData.warchess_icon_res)[headIconId]
  if headIconCfg == nil then
    error("headIconCfg is nil:" .. tostring(headIconId))
    return 
  end
  local iconName = headIconCfg.res_name
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_TeamHeadIcon).sprite = (AtlasUtil.GetResldSprite)(iconAtlas, iconName)
end

UINWarChessInfoInfoTeamInfo.ShowWCIITeamInfoApReduceTip = function(self, changeTeam, diffAp)
  -- function num : 0_4 , upvalues : _ENV, eWarChessEnum
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local teamIndex = changeTeam:GetWCTeamIndex()
  if diffAp ~= nil then
    ((self.ui).tex_Tip):SetIndex(0, tostring(diffAp))
  end
  if self._timer ~= nil then
    TimerManager:StopTimer(self._timer)
    self._timer = nil
    ;
    ((self.ui).obj_APReduceTip):SetActive(false)
    if wcCtrl.state == (eWarChessEnum.eWarChessState).play then
      (wcCtrl.curState):SetIsWaitingAPReduceAnimation(self._teamIndex, false)
    end
  end
  ;
  ((self.ui).obj_APReduceTip):SetActive(true)
  if wcCtrl.state == (eWarChessEnum.eWarChessState).play then
    (wcCtrl.curState):SetIsWaitingAPReduceAnimation(teamIndex, true)
  end
  self._teamIndex = teamIndex
  self._timer = TimerManager:StartTimer(0.8, function(obj_img_Target)
    -- function num : 0_4_0 , upvalues : wcCtrl, eWarChessEnum, teamIndex, _ENV
    if wcCtrl.state == (eWarChessEnum.eWarChessState).play then
      (wcCtrl.curState):SetIsWaitingAPReduceAnimation(teamIndex, false)
    end
    if IsNull(obj_img_Target) then
      return 
    end
    obj_img_Target:SetActive(false)
  end
, (self.ui).obj_APReduceTip, true)
end

UINWarChessInfoInfoTeamInfo.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnDelete)(self)
  if self._timer ~= nil then
    TimerManager:StopTimer(self._timer)
    self._timer = nil
  end
end

return UINWarChessInfoInfoTeamInfo

