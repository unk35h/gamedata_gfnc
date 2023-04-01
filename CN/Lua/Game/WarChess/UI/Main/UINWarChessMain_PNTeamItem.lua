-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMain_PNTeamItem = class("UINWarChessMain_PNTeamItem", base)
local notSelected_HeroPicColor = (Color.New)(1, 1, 1, 0.6)
local notSelected_BgColor = (Color.New)(0.1254902, 0.1254902, 0.1254902, 0.8)
local notSelected_textColor = (Color.New)(0.8156863, 0.8156863, 0.8156863, 0.7)
local notSelected_actionBGColor = (Color.New)(0.3, 0.3, 0.3, 0.5)
local noAP_actionBGColor = (Color.New)(0.5188679, 0.005896227, 0, 0.8)
local noAP_textColor = (Color.New)(1, 1, 1, 1)
local selected_BgColor = (Color.New)(1, 1, 1, 0.8)
local selected_actionBGColor = (Color.New)(0.1098039, 0.4039216, 0.04705882, 0.8)
local selected_actionTextColor = (Color.New)(0.6352941, 1, 0.5568628)
local unSelectedSacle = (Vector3.New)(0.9, 0.9, 1)
local selectedSize = (Vector2.New)(440, 112)
local unSelectedSize = (Vector2.New)(396, 112)
UINWarChessMain_PNTeamItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_bottom, self, self.__OnClick)
end

UINWarChessMain_PNTeamItem.InitWCPlayTeamItem = function(self, teamData, wcCtrl, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self.teamData = teamData
  self.resloader = resloader
  self.wcCtrl = wcCtrl
  self.__preHpRate = nil
  local index = (self.teamData):GetWCTeamIndex()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.gameObject).name = tostring(index)
  self.teamAP = teamData:GetTeamActionPoint()
  self:RefreshTeamLeaderPic()
  self:RefreshTeamPower(self.teamData)
  self:RefreshTeamAP(self.teamData)
  self:RefreshTeamHp(self.teamData)
end

UINWarChessMain_PNTeamItem.SetWCPNTeamItemOnClickFunc = function(self, callback)
  -- function num : 0_2
  self.__OnClickCallback = callback
end

UINWarChessMain_PNTeamItem.RefreshTeamLeaderPic = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_TeamName).text = (self.teamData):GetWCTeamName()
  local firstHeroId = (self.teamData):GetFirstHeroId()
  local dynHeroData = ((self.wcCtrl).teamCtrl):GetHeroDynDataById(firstHeroId)
  if dynHeroData == nil then
    error("team leader data not exist")
    return 
  end
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetCharacterPicPath(dynHeroData:GetResPicName()), function(texture)
    -- function num : 0_3_0 , upvalues : _ENV, self
    if IsNull(self.transform) or IsNull(texture) then
      return 
    end
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_TeamHeroPic).texture = texture
  end
)
end

UINWarChessMain_PNTeamItem.RefreshTeamAP = function(self, teamData)
  -- function num : 0_4 , upvalues : _ENV
  if WarChessSeasonManager:GetIsInWCSeasonIsInLobby() then
    ((self.ui).obj_action):SetActive(false)
    return 
  else
    ;
    ((self.ui).obj_action):SetActive(true)
  end
  self.teamAP = teamData:GetTeamActionPoint()
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ActionPoint).text = tostring(self.teamAP)
  self:RefreshTeamAPText()
end

UINWarChessMain_PNTeamItem.RefreshTeamPower = function(self, teamData)
  -- function num : 0_5 , upvalues : _ENV
  local pow = teamData:GetWCTeamPower()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Power).text = tostring(pow)
  self:RefreshTeamHp(teamData)
end

UINWarChessMain_PNTeamItem.RefreshTeamAPText = function(self)
  -- function num : 0_6 , upvalues : _ENV, notSelected_HeroPicColor, notSelected_actionBGColor, selected_actionTextColor, selected_actionBGColor, noAP_actionBGColor
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

  if self.teamAP > 0 then
    if self.__isNotSeleted then
      ((self.ui).tex_actionTip).text = ConfigData:GetTipContent(8501)
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).tex_actionTip).color = notSelected_HeroPicColor
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_actionBg).color = notSelected_actionBGColor
      ;
      ((self.ui).obj_actionArrow):SetActive(false)
    else
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).tex_actionTip).text = ConfigData:GetTipContent(8502)
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).tex_actionTip).color = selected_actionTextColor
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_actionBg).color = selected_actionBGColor
      ;
      ((self.ui).obj_actionArrow):SetActive(true)
    end
  else
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_actionTip).text = ConfigData:GetTipContent(8503)
    -- DECOMPILER ERROR at PC64: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_actionTip).color = (Color.New)(1, 1, 1, 0.8)
    ;
    ((self.ui).obj_actionArrow):SetActive(false)
    -- DECOMPILER ERROR at PC73: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_actionBg).color = noAP_actionBGColor
  end
end

UINWarChessMain_PNTeamItem.RefreshTeamHp = function(self, teamData)
  -- function num : 0_7 , upvalues : _ENV
  local hpRate = teamData:GetWCTeamHP()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  if not self.__preHpRate then
    ((self.ui).img_HP).fillAmount = hpRate
  else
    local distance = (Mathf.Abs)(self.__preHpRate - hpRate)
    if distance >= 0.01 then
      local lerpSeconds = 0.3
      do
        local lerpSpeed = distance / lerpSeconds
        if self.__TeamHpLerpTimer then
          TimerManager:StopTimer(self.__TeamHpLerpTimer)
          self.__TeamHpLerpTimer = nil
        end
        self.__TeamHpLerpTimer = TimerManager:StartTimer(0, function()
    -- function num : 0_7_0 , upvalues : _ENV, self, hpRate, lerpSpeed
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R0 in 'UnsetPending'

    if (Mathf.Abs)(((self.ui).img_HP).fillAmount - hpRate) < 0.05 then
      ((self.ui).img_HP).fillAmount = hpRate
      TimerManager:StopTimer(self.__TeamHpLerpTimer)
      self.__TeamHpLerpTimer = nil
      return 
    end
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).img_HP).fillAmount = (Mathf.Lerp)(((self.ui).img_HP).fillAmount, hpRate, lerpSpeed * Time.unscaledDeltaTime)
  end
, self, false, true, true)
      end
    end
  end
  do
    self.__preHpRate = hpRate
  end
end

UINWarChessMain_PNTeamItem.ChangeWCPNTeamApperance = function(self, isNotSeleted)
  -- function num : 0_8 , upvalues : notSelected_BgColor, notSelected_HeroPicColor, notSelected_textColor, unSelectedSize, unSelectedSacle, selected_BgColor, _ENV, selectedSize
  if self.__isNotSeleted == isNotSeleted then
    return false
  end
  self.__isNotSeleted = isNotSeleted
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  if isNotSeleted then
    ((self.ui).img_bottom).color = notSelected_BgColor
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_TeamHeroPic).color = notSelected_HeroPicColor
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_TeamName).color = notSelected_textColor
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Power).color = notSelected_textColor
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_APIcon).color = notSelected_textColor
    self:RefreshTeamAPText()
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.transform).sizeDelta = unSelectedSize
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).teamScale).localScale = unSelectedSacle
  else
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_bottom).color = selected_BgColor
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_TeamHeroPic).color = Color.white
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_TeamName).color = Color.black
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Power).color = Color.black
    -- DECOMPILER ERROR at PC61: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_APIcon).color = Color.black
    self:RefreshTeamAPText()
    -- DECOMPILER ERROR at PC66: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.transform).sizeDelta = selectedSize
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).teamScale).localScale = Vector3.one
  end
  return true
end

UINWarChessMain_PNTeamItem.__OnClick = function(self)
  -- function num : 0_9
  if self.__OnClickCallback ~= nil then
    (self.__OnClickCallback)(self)
  end
end

UINWarChessMain_PNTeamItem.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self.__TeamHpLerpTimer then
    TimerManager:StopTimer(self.__TeamHpLerpTimer)
    self.__TeamHpLerpTimer = nil
  end
end

return UINWarChessMain_PNTeamItem

