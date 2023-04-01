-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCharaDungeonBase = class("UINCharaDungeonBase", UIBaseNode)
local base = UIBaseNode
local TaskEnum = require("Game.Task.TaskEnum")
local JumpManager = require("Game.Jump.JumpManager")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINCharaDungeonBase.ctor = function(self, charDunWin)
  -- function num : 0_0
  self.charDunWin = charDunWin
end

UINCharaDungeonBase.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_NormalBattle, self, self.OnClickMainEp)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_EXBattle, self, self.OnClickChallengeEp)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Exchange, self, self.OnClickHeroGrowShop)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Task, self, self.OnClickHeroGrowTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnClickActIntro)
  self.__ItemUpdateEvent = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__ItemUpdateEvent)
  self.__RefreshChallengeBtnStateEvent = BindCallback(self, self.__RefreshChallengeBtnState)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityUpdate, self.__RefreshChallengeBtnStateEvent)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityTimePass, self.__RefreshChallengeBtnStateEvent)
  self.__OnShowCharacterDungeonUI = BindCallback(self, self.OnShowCharacterDungeonUI)
end

UINCharaDungeonBase.InitCharaDungeonNode = function(self, heroGrowAct, enterSecotrFunc, resLoader)
  -- function num : 0_2 , upvalues : _ENV
  self.resloader = resLoader
  self.heroGrowAct = heroGrowAct
  self.heroGrowCfg = heroGrowAct:GetHeroGrowCfg()
  self.enterSecotrFunc = enterSecotrFunc
  self:__RefreshCoinShow()
  self:__InitDungeonShopRedot()
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self._timerId = TimerManager:StartTimer(1, self.__TimerCountdown, self)
  self:__RefreshChallengeBtnState()
  self:__RefreshOtherBtnState()
  self:__RefreshPreviewGroupState()
  self:__TimerCountdown()
  local mainSectorCfg = (ConfigData.sector)[(self.heroGrowCfg).main_stage]
  local rechallengeSectorCfg = (ConfigData.sector)[(self.heroGrowCfg).rechallenge_stage]
  -- DECOMPILER ERROR at PC49: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_MainEp_Name).text = (LanguageUtil.GetLocaleText)(mainSectorCfg.name)
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_EXEP_Name).text = (LanguageUtil.GetLocaleText)(rechallengeSectorCfg.name)
  local nameStr = ""
  for i,heroId in ipairs((self.heroGrowCfg).friendship_heroList) do
    local heroCfg = (ConfigData.hero_data)[heroId]
    if heroCfg == nil then
      error(" heroCfg is NIL id:" .. tostring(heroId))
    else
      nameStr = nameStr .. "[" .. (LanguageUtil.GetLocaleText)(heroCfg.name) .. "]"
    end
  end
  local friendship_display = tostring((self.heroGrowCfg).friendship_display) .. "%"
  -- DECOMPILER ERROR at PC103: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Up).text = (string.format)(ConfigData:GetTipContent(6042), nameStr, friendship_display)
  local heroCfg = (ConfigData.hero_data)[(self.heroGrowCfg).hero_id]
  if heroCfg == nil then
    error(" heroCfg is NIL id:" .. tostring((self.heroGrowCfg).hero_id))
    return 
  end
  -- DECOMPILER ERROR at PC125: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = (self.heroGrowAct):GetActivityName()
  -- DECOMPILER ERROR at PC133: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_shop).text = (LanguageUtil.GetLocaleText)((self.heroGrowCfg).shop_name)
  self:__InitCharDunBackground()
  -- DECOMPILER ERROR at PC142: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_Main).text = ConfigData:GetTipContent(6034)
  -- DECOMPILER ERROR at PC149: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_Dun).text = ConfigData:GetTipContent(6035)
  -- DECOMPILER ERROR at PC156: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_ActEnd).text = ConfigData:GetTipContent(6033)
end

UINCharaDungeonBase.__InitDungeonShopRedot = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local shopNode = (self.heroGrowAct):GetActivityHeroShopReddotNode()
  if self.__shopRedDotPath ~= nil and self.__shopRedDotFunc ~= nil then
    RedDotController:RemoveListener(self.__shopRedDotPath, self.__shopRedDotFunc)
  end
  self.__shopRedDotFunc = function(node)
    -- function num : 0_3_0 , upvalues : self
    ((self.ui).blueDot_Shop):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

  ;
  (self.__shopRedDotFunc)(shopNode)
  self.__shopRedDotPath = shopNode.nodePath
  RedDotController:AddListener(shopNode.nodePath, self.__shopRedDotFunc)
end

UINCharaDungeonBase.OnClickMainEp = function(self)
  -- function num : 0_4
  if self.enterSecotrFunc == nil then
    return 
  end
  self:OnEnterHeroGrowSector((self.heroGrowCfg).main_stage)
end

UINCharaDungeonBase.OnClickChallengeEp = function(self)
  -- function num : 0_5
  if not (self.heroGrowAct):IsActivityRunning() then
    return 
  end
  self:OnEnterHeroGrowSector((self.heroGrowCfg).rechallenge_stage)
end

UINCharaDungeonBase.OnEnterHeroGrowSector = function(self, sectorId)
  -- function num : 0_6 , upvalues : SectorStageDetailHelper, _ENV
  local isOpen = (self.heroGrowAct):IsActivityOpen()
  if not isOpen then
    return 
  end
  if self.enterSecotrFunc == nil then
    return 
  end
  if not (SectorStageDetailHelper.IsSectorNoCollide)(sectorId, true) then
    return 
  end
  self:OnHideCharacterDungeonUI()
  ;
  (self.enterSecotrFunc)(sectorId, 1, nil, self.__OnShowCharacterDungeonUI, function()
    -- function num : 0_6_0 , upvalues : _ENV
    local sectorLevelWin = UIManager:GetWindow(UIWindowTypeID.SectorLevel)
    if sectorLevelWin ~= nil then
      sectorLevelWin:SetCustomEnterFmtCallback(function(enterFmtData)
      -- function num : 0_6_0_0
      if enterFmtData ~= nil then
        enterFmtData:SetFmtForbidSupport(true)
        enterFmtData:SetIsShowSupportHolder(true)
      end
    end
)
    end
  end
)
end

UINCharaDungeonBase.OnClickHeroGrowShop = function(self)
  -- function num : 0_7 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CharacterDungeonShop, function(window)
    -- function num : 0_7_0 , upvalues : self
    window:InitCharacterDungeonShop(self.heroGrowAct)
  end
)
end

UINCharaDungeonBase.OnClickHeroGrowTask = function(self)
  -- function num : 0_8 , upvalues : JumpManager, TaskEnum
  local isOpen = (self.heroGrowAct):IsActivityOpen()
  if isOpen then
    JumpManager:Jump((JumpManager.eJumpTarget).DynTask, nil, nil, {(TaskEnum.eTaskType).HeroActivityTask}, true)
  end
end

UINCharaDungeonBase.__TimerCountdown = function(self)
  -- function num : 0_9 , upvalues : _ENV, ActivityFrameUtil
  do
    if self._nextTime or 0 < PlayerDataCenter.timestamp then
      local title, timeStr, expireTime = (ActivityFrameUtil.GetShowEndTimeStr)(self.heroGrowAct)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_TimerDes).text = title
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_Timer).text = timeStr
      self._nextTime = expireTime
    end
    local countdownStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(self._nextTime)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Days).text = countdownStr
    if diff < 0 and self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
  end
end

UINCharaDungeonBase.__RefreshChallengeBtnState = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local inTime = (self.heroGrowAct):IsActivityRunning()
  ;
  ((self.ui).obj_challenge_Lock):SetActive(not inTime)
  if not inTime then
    ((self.ui).obj_challenge_ActEnd):SetActive(not (self.heroGrowAct):IsActivityPreview())
  end
  local hasLimitTimes = (self.heroGrowAct):IsHeroGrowLimiTimes()
  ;
  (((self.ui).tex_challenge_Times).gameObject):SetActive(not inTime or hasLimitTimes)
  if hasLimitTimes then
    local battleCount = (self.heroGrowAct):GetHeroGrowChallengeCount()
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_challenge_Times).text = (string.format)(ConfigData:GetTipContent(6040), tostring(battleCount))
    ;
    ((self.ui).blueDot_battle):SetActive(battleCount > 0)
  else
    ((self.ui).blueDot_battle):SetActive(false)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINCharaDungeonBase.__RefreshPreviewGroupState = function(self)
  -- function num : 0_11 , upvalues : _ENV
  self._previewOpenTime = nil
  local preivewOpenTime = (self.heroGrowCfg).preview_start
  if not (string.IsNullOrEmpty)((self.heroGrowCfg).preview_pic) and preivewOpenTime <= PlayerDataCenter.timestamp then
    ((self.ui).obj_Preview):SetActive(true)
    local str = (LanguageUtil.GetLocaleText)((self.heroGrowCfg).preview_text)
    if str == nil or #str == 0 then
      str = ConfigData:GetTipContent(6039)
    end
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Preview).text = str
    ;
    (((self.ui).img_Preview).gameObject):SetActive(false)
    ;
    (self.resloader):LoadABAssetAsync(PathConsts:GetCharDunPath((self.heroGrowCfg).preview_pic), function(texture)
    -- function num : 0_11_0 , upvalues : _ENV, self
    if texture == nil or IsNull((self.ui).img_Preview) then
      return 
    end
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Preview).texture = texture
    ;
    (((self.ui).img_Preview).gameObject):SetActive(true)
  end
)
  else
    do
      self._previewOpenTime = preivewOpenTime
      ;
      ((self.ui).obj_Preview):SetActive(false)
    end
  end
end

UINCharaDungeonBase.__RefreshOtherBtnState = function(self)
  -- function num : 0_12
  local inPreview = (self.heroGrowAct):IsActivityPreview()
  ;
  ((self.ui).obj_task_Lock):SetActive(inPreview)
  ;
  ((self.ui).obj_main_Lock):SetActive(inPreview)
end

UINCharaDungeonBase.OnClickActIntro = function(self)
  -- function num : 0_13 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_13_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    window:InitCommonInfo(ConfigData:GetTipContent((self.heroGrowCfg).rule_content), ConfigData:GetTipContent((self.heroGrowCfg).rule_title))
  end
)
end

UINCharaDungeonBase.OnHideCharacterDungeonUI = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self._timerId ~= nil then
    TimerManager:PauseTimer(self._timerId)
  end
  self:Hide()
end

UINCharaDungeonBase.OnShowCharacterDungeonUI = function(self)
  -- function num : 0_15 , upvalues : _ENV
  self:Show()
  if self._timerId ~= nil then
    TimerManager:ResumeTimer(self._timerId)
  end
end

UINCharaDungeonBase.__RefreshCoinShow = function(self)
  -- function num : 0_16 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Count).text = "x" .. tostring(PlayerDataCenter:GetItemCount((self.heroGrowCfg).token))
end

UINCharaDungeonBase.__ItemUpdate = function(self, itemUpdate)
  -- function num : 0_17
  if itemUpdate[(self.heroGrowCfg).token] ~= nil then
    self:__RefreshCoinShow()
  end
end

UINCharaDungeonBase.__InitCharDunBackground = function(self)
  -- function num : 0_18 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_background).enabled = false
  local path = PathConsts:GetCharDunPath((self.heroGrowCfg).shop_bg)
  ;
  (self.resloader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_18_0 , upvalues : self
    if texture == nil then
      return 
    end
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_background).enabled = true
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_background).texture = texture
  end
)
end

UINCharaDungeonBase.OnDelete = function(self)
  -- function num : 0_19 , upvalues : _ENV, base
  if self.__shopRedDotPath ~= nil and self.__shopRedDotFunc ~= nil then
    RedDotController:RemoveListener(self.__shopRedDotPath, self.__shopRedDotFunc)
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__ItemUpdateEvent)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityUpdate, self.__RefreshChallengeBtnStateEvent)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityTimePass, self.__RefreshChallengeBtnStateEvent)
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINCharaDungeonBase

