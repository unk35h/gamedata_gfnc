-- params : ...
-- function num : 0 , upvalues : _ENV
local UICharDunVer2 = class("UICharDunVer2", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local SectorEnum = require("Game.Sector.SectorEnum")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local HeroCubismInteration = require("Game.Hero.Live2D.HeroCubismInteration")
local ActivityCharDunConfig = require("Game.ActivityHeroGrow.ActivityCharDunConfig")
UICharDunVer2.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader
  (UIUtil.SetTopStatus)(self, self.OnCloseSelf)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnClickInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Task, self, self.OnClickTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Exchange, self, self.OnClickExpLv)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_NormalBattle, self, self.OnClickMain)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_EXBattle, self, self.OnClickEx)
  self._resloader = (cs_ResLoader.Create)()
  self.__RefreshChallengeBtnStateEvent = BindCallback(self, self.__RefreshChallengeBtnState)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityUpdate, self.__RefreshChallengeBtnStateEvent)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityTimePass, self.__RefreshChallengeBtnStateEvent)
  self.__RefreshLvBtnStateCallback = BindCallback(self, self.__RefreshLvBtnState)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__RefreshLvBtnStateCallback)
  self.__RefreshTaskBtnStateCallback = BindCallback(self, self.__RefreshTaskBtnState)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityUpdate, self.__RefreshTaskBtnStateCallback)
  self.__OnShowCharacterDungeonUI = BindCallback(self, self.OnShowCharacterDungeonUI)
end

UICharDunVer2.InitCharacterDungeon = function(self, heroGrowAct, enterSecotrFunc, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._heroGrowAct = heroGrowAct
  self._enterSecotrFunc = enterSecotrFunc
  self._closeCallback = closeCallback
  self._cfg = (self._heroGrowAct):GetHeroGrowCfg()
  self:__ReplaceByUICfg()
  self:__RefreshFix()
  self:__RefreshAllUI()
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self._timerId = TimerManager:StartTimer(1, self.__TimerCountdown, self)
  self:__TimerCountdown()
  self._reddot = (self._heroGrowAct):GetActivityReddot()
  if self._reddot ~= nil then
    self._reddotFunc = BindCallback(self, self.__RefreshReddot)
    RedDotController:AddListener((self._reddot).nodePath, self._reddotFunc)
    self:__RefreshReddot(self._reddot)
  end
end

UICharDunVer2.OnEnterCharDunSector = function(self, sectorId)
  -- function num : 0_2 , upvalues : SectorStageDetailHelper, _ENV
  local isOpen = (self._heroGrowAct):IsActivityOpen()
  if not isOpen then
    return 
  end
  if self._enterSecotrFunc == nil then
    return 
  end
  if not (SectorStageDetailHelper.IsSectorNoCollide)(sectorId, true) then
    return 
  end
  self:OnHideCharacterDungeonUI()
  ;
  (self._enterSecotrFunc)(sectorId, 1, nil, self.__OnShowCharacterDungeonUI, function()
    -- function num : 0_2_0 , upvalues : self, _ENV
    if self.charDunSectorCallback then
      (self.charDunSectorCallback)()
      self.charDunSectorCallback = nil
    end
    local sectorLevelWin = UIManager:GetWindow(UIWindowTypeID.SectorLevel)
    if sectorLevelWin ~= nil then
      sectorLevelWin:SetCustomEnterFmtCallback(function(enterFmtData)
      -- function num : 0_2_0_0
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

UICharDunVer2.SetCharDunSectorCallback = function(self, callback)
  -- function num : 0_3
  self.charDunSectorCallback = callback
end

UICharDunVer2.OnHideCharacterDungeonUI = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self._timerId ~= nil then
    TimerManager:PauseTimer(self._timerId)
  end
  self:Hide()
end

UICharDunVer2.OnShowCharacterDungeonUI = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self:Show()
  if self._timerId ~= nil then
    TimerManager:ResumeTimer(self._timerId)
  end
end

UICharDunVer2.__ReplaceByUICfg = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local uiCfg = (ConfigData.activity_hero_ui_config)[(self._heroGrowAct):GetActId()]
  local atlasPath = PathConsts:GetSpriteAtlasPath("CharDunVer2Icon")
  ;
  (self._resloader):LoadABAssetAsync(atlasPath, function(altas)
    -- function num : 0_6_0 , upvalues : _ENV, self, uiCfg
    if altas == nil or IsNull(self.transform) then
      return 
    end
    local imgBattle = altas:GetSprite(uiCfg.main_stage_icon)
    local imgEX = altas:GetSprite(uiCfg.challenge_icon)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).imgBattle).sprite = imgBattle
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).imgEX).sprite = imgEX
  end
)
  local itemId = (self._heroGrowAct):GetHeroGrowCostId()
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_TokenIcon).sprite = CRH:GetSpriteByItemId(itemId)
  local bgPath = PathConsts:GetCharDunVer2Bg(uiCfg.background_res)
  ;
  (((self.ui).background).gameObject):SetActive(false)
  ;
  (self._resloader):LoadABAssetAsync(bgPath, function(texture)
    -- function num : 0_6_1 , upvalues : _ENV, self
    if texture == nil or IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).background).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).background).texture = texture
  end
)
  local nameResPath = PathConsts:GetCharDunVer2Bg(uiCfg.background_text)
  ;
  (((self.ui).img_Name).gameObject):SetActive(false)
  ;
  (self._resloader):LoadABAssetAsync(nameResPath, function(texture)
    -- function num : 0_6_2 , upvalues : _ENV, self
    if texture == nil or IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).img_Name).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Name).texture = texture
  end
)
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_LvName).text = (LanguageUtil.GetLocaleText)(uiCfg.reward_panel_name)
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_TaskName).text = (LanguageUtil.GetLocaleText)(uiCfg.mission_panel_name)
  -- DECOMPILER ERROR at PC75: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenName).text = ConfigData:GetItemName(itemId)
  local frameColors = uiCfg.frame_color
  local color = (Color.New)(frameColors[1] / 255, frameColors[2] / 255, frameColors[3] / 255)
  for i,v in ipairs((self.ui).array_colorRep) do
    v.color = color
  end
  local heroId = ((self._heroGrowAct):GetHeroGrowCfg()).hero_id
  local heroCfg = (ConfigData.hero_data)[heroId]
  local companyCfg = (ConfigData.camp)[heroCfg.camp]
  -- DECOMPILER ERROR at PC113: Confused about usage of register: R11 in 'UnsetPending'

  ;
  ((self.ui).imgLogo).sprite = CRH:GetSprite(companyCfg.icon, CommonAtlasType.CareerCamp)
  local skinId = uiCfg.background_skin
  self:__LoadPic(heroId, skinId)
  do
    if #uiCfg.background_text_point > 0 then
      local vec = (Vector2.New)((uiCfg.background_text_point)[1], (uiCfg.background_text_point)[2])
      -- DECOMPILER ERROR at PC133: Confused about usage of register: R13 in 'UnsetPending'

      ;
      (((self.ui).img_Name).transform).anchoredPosition = vec
    end
    do
      if #uiCfg.background_text_size > 0 then
        local vec = (Vector2.New)((uiCfg.background_text_size)[1], (uiCfg.background_text_size)[2])
        -- DECOMPILER ERROR at PC148: Confused about usage of register: R13 in 'UnsetPending'

        ;
        (((self.ui).img_Name).transform).sizeDelta = vec
      end
      -- DECOMPILER ERROR at PC163: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).tex_Name).color = (Color.New)((uiCfg.main_title_color)[1] / 255, (uiCfg.main_title_color)[2] / 255, (uiCfg.main_title_color)[3] / 255)
      -- DECOMPILER ERROR at PC178: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).img_Info).color = (Color.New)((uiCfg.rule_icon_color)[1] / 255, (uiCfg.rule_icon_color)[2] / 255, (uiCfg.rule_icon_color)[3] / 255)
      if #uiCfg.main_top_res == 0 then
        (((self.ui).Img_Up).gameObject):SetActive(false)
      else
        local nameResPath = PathConsts:GetCharDunVer2Bg(uiCfg.main_top_res)
        ;
        (self._resloader):LoadABAssetAsync(nameResPath, function(texture)
    -- function num : 0_6_3 , upvalues : _ENV, self
    if texture == nil or IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).Img_Up).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).Img_Up).texture = texture
  end
)
        -- DECOMPILER ERROR at PC209: Confused about usage of register: R13 in 'UnsetPending'

        ;
        (((self.ui).Img_Up).transform).sizeDelta = (Vector2.Temp)((uiCfg.main_top_size)[1], (uiCfg.main_top_size)[2])
      end
      do
        if #uiCfg.main_down_res == 0 then
          (((self.ui).Img_Down).gameObject):SetActive(false)
        else
          local nameResPath = PathConsts:GetCharDunVer2Bg(uiCfg.main_down_res)
          ;
          (self._resloader):LoadABAssetAsync(nameResPath, function(texture)
    -- function num : 0_6_4 , upvalues : _ENV, self
    if texture == nil or IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).Img_Down).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).Img_Down).texture = texture
  end
)
          -- DECOMPILER ERROR at PC240: Confused about usage of register: R13 in 'UnsetPending'

          ;
          (((self.ui).Img_Down).transform).sizeDelta = (Vector2.Temp)((uiCfg.main_down_size)[1], (uiCfg.main_down_size)[2])
        end
      end
    end
  end
end

UICharDunVer2.__LoadL2D = function(self, heroId, skinId)
  -- function num : 0_7 , upvalues : _ENV, HeroCubismInteration
  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg == nil then
    error("skinCfg is NIL")
    return 
  end
  local resName = skinCfg.src_id_pic
  ;
  (self._resloader):LoadABAssetAsync(PathConsts:GetCharacterLive2DPath(resName), function(l2dModelAsset)
    -- function num : 0_7_0 , upvalues : _ENV, self, HeroCubismInteration, heroId, skinId
    if IsNull(l2dModelAsset) then
      return 
    end
    self.liveGo = l2dModelAsset:Instantiate()
    ;
    ((self.liveGo).transform):SetParent(((self.ui).heroHolder).transform)
    ;
    ((self.liveGo).transform):SetLayer(LayerMask.UI)
    local cs_CubismInterationController = ((self.liveGo).gameObject):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
    if cs_CubismInterationController ~= nil then
      self.heroCubismInteration = (HeroCubismInteration.New)()
      ;
      (self.heroCubismInteration):InitHeroCubism(cs_CubismInterationController, heroId, skinId, UIManager:GetUICamera(), false)
      ;
      (self.heroCubismInteration):OpenLookTarget(UIManager:GetUICamera())
      ;
      (self.heroCubismInteration):SetRenderControllerSetting(self:GetWindowSortingLayer(), (self.ui).heroHolder, nil, true)
      ;
      (self.heroCubismInteration):SetL2DPosType("CharDun", false)
    end
  end
)
end

UICharDunVer2.__LoadPic = function(self, heroId, skinId)
  -- function num : 0_8 , upvalues : _ENV
  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg == nil then
    error("skinCfg is NIL")
    return 
  end
  local resName = skinCfg.src_id_pic
  ;
  (self._resloader):LoadABAssetAsync(PathConsts:GetCharacterBigImgPrefabPath(resName), function(prefab)
    -- function num : 0_8_0 , upvalues : self, _ENV
    self.bigImgGameObject = prefab:Instantiate(((self.ui).heroHolder).transform)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("CharDun")
  end
)
end

UICharDunVer2.__RefreshFix = function(self)
  -- function num : 0_9 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Name).text = (self._heroGrowAct):GetActivityName()
  local nameStr = ""
  for i,heroId in ipairs((self._cfg).friendship_heroList) do
    local heroCfg = (ConfigData.hero_data)[heroId]
    if heroCfg == nil then
      error(" heroCfg is NIL id:" .. tostring(heroId))
    else
      nameStr = nameStr .. "[" .. (LanguageUtil.GetLocaleText)(heroCfg.name) .. "]"
    end
  end
  local friendship_display = tostring((self._cfg).friendship_display) .. "%"
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Up).text = (string.format)(ConfigData:GetTipContent(6042), nameStr, friendship_display)
  local mainSectorCfg = (ConfigData.sector)[(self._cfg).main_stage]
  local rechallengeSectorCfg = (ConfigData.sector)[(self._cfg).rechallenge_stage]
  -- DECOMPILER ERROR at PC69: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_NName).text = (LanguageUtil.GetLocaleText)(mainSectorCfg.name)
  -- DECOMPILER ERROR at PC76: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_EXName).text = (LanguageUtil.GetLocaleText)(rechallengeSectorCfg.name)
end

UICharDunVer2.__TimerCountdown = function(self)
  -- function num : 0_10 , upvalues : _ENV, ActivityFrameUtil
  do
    if self._nextTime or 0 < PlayerDataCenter.timestamp then
      local title, timeStr, expireTime = (ActivityFrameUtil.GetShowEndTimeStr)(self._heroGrowAct)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).title).text = title
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

UICharDunVer2.__RefreshAllUI = function(self)
  -- function num : 0_11
  self:__RefreshNorMainBtnState()
  self:__RefreshChallengeBtnState()
  self:__RefreshTaskBtnState()
  self:__RefreshLvBtnState()
end

UICharDunVer2.__RefreshNorMainBtnState = function(self)
  -- function num : 0_12 , upvalues : _ENV, SectorEnum
  local isFinish, stageId = (PlayerDataCenter.sectorStage):GetSectorProcess((self._cfg).main_stage)
  local stageCfg = (ConfigData.sector_stage)[stageId]
  local secotrLevelType = (SectorEnum.eSectorLevelItemType).OnlyNumber
  local sectorLevelDes = (SectorEnum.SectorLevelItemDesc)[secotrLevelType]
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Stage).text = (string.format)(sectorLevelDes, stageCfg.num)
end

UICharDunVer2.__RefreshChallengeBtnState = function(self)
  -- function num : 0_13
  local inTime = (self._heroGrowAct):IsActivityRunning()
  ;
  ((self.ui).obj_Lock_ex):SetActive(not inTime)
  if not inTime then
    ((self.ui).obj_ActEnd):SetActive(not (self._heroGrowAct):IsActivityPreview())
    ;
    ((self.ui).aniTip):DOPause()
  else
    ;
    ((self.ui).aniTip):DOPlay()
  end
end

UICharDunVer2.__RefreshTaskBtnState = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local totalCount = 0
  local taskDailyCfg = (ConfigData.activity_hero_task_daily)[(self._heroGrowAct):GetActId()]
  for day,v in ipairs(taskDailyCfg) do
    if (self._heroGrowAct):IsHeroGrowDailyTaskIsUnlock(day) then
      do
        totalCount = totalCount + #v.open_task_list + #v.wait_task_list
        -- DECOMPILER ERROR at PC23: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC23: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  local finishCount = (table.count)((self._heroGrowAct):GetHeroGrowFinishTask())
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Progress).text = tostring(finishCount) .. "/" .. tostring(totalCount)
end

UICharDunVer2.__RefreshLvBtnState = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local itemId = (self._heroGrowAct):GetHeroGrowCostId()
  local count = PlayerDataCenter:GetItemCount(itemId)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenNum).text = tostring(count)
end

UICharDunVer2.__RefreshReddot = function(self, node)
  -- function num : 0_16 , upvalues : ActivityCharDunConfig
  local dailyTaskComNode = node:GetChild((ActivityCharDunConfig.reddotType).dailyTaskCom)
  local dailyTaskNewNode = node:GetChild((ActivityCharDunConfig.reddotType).dailyTaskNew)
  local lvRewardNode = node:GetChild((ActivityCharDunConfig.reddotType).lvReward)
  local challengeNewNode = node:GetChild((ActivityCharDunConfig.reddotType).challengeNew)
  local dailyTaskComCount = dailyTaskComNode ~= nil and dailyTaskComNode:GetRedDotCount() or 0
  local dailyTaskNewCount = dailyTaskNewNode ~= nil and dailyTaskNewNode:GetRedDotCount() or 0
  local lvRewardCount = lvRewardNode ~= nil and lvRewardNode:GetRedDotCount() or 0
  local challengeNewCount = challengeNewNode ~= nil and challengeNewNode:GetRedDotCount() or 0
  ;
  ((self.ui).tag):SetActive(dailyTaskNewCount > 0 and dailyTaskComCount == 0)
  ;
  ((self.ui).redDot_task):SetActive(dailyTaskComCount > 0)
  ;
  ((self.ui).blueDot_lv):SetActive(lvRewardCount > 0)
  ;
  ((self.ui).blueDot_ex):SetActive(challengeNewCount > 0)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UICharDunVer2.OnClickTask = function(self)
  -- function num : 0_17 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CharDunTaskVer2, function(window)
    -- function num : 0_17_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitCharDunTaskVer2(self._heroGrowAct)
  end
)
end

UICharDunVer2.OnClickExpLv = function(self)
  -- function num : 0_18 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CharDunShopVer2, function(window)
    -- function num : 0_18_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitCharDunShopVer2(self._heroGrowAct)
  end
)
end

UICharDunVer2.OnClickMain = function(self)
  -- function num : 0_19
  if self._enterSecotrFunc == nil then
    return 
  end
  self:OnEnterCharDunSector((self._cfg).main_stage)
end

UICharDunVer2.OnClickEx = function(self)
  -- function num : 0_20
  if not (self._heroGrowAct):IsActivityRunning() then
    return 
  end
  self:OnEnterCharDunSector((self._cfg).rechallenge_stage)
  ;
  (self._heroGrowAct):SetHeroGrowChallengeNew()
end

UICharDunVer2.OnClickInfo = function(self)
  -- function num : 0_21 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_21_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    window:InitCommonInfo(ConfigData:GetTipContent((self._cfg).rule_content), ConfigData:GetTipContent((self._cfg).rule_title))
  end
)
end

UICharDunVer2.OnCloseSelf = function(self)
  -- function num : 0_22
  self:Delete()
  if self._closeCallback ~= nil then
    (self._closeCallback)(false)
  end
end

UICharDunVer2.OnDelete = function(self)
  -- function num : 0_23 , upvalues : _ENV, base
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  ;
  ((self.ui).aniTip):DOKill()
  ;
  (self._resloader):Put2Pool()
  self._resloader = nil
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self._reddot = (self._heroGrowAct):GetActivityReddot()
  if self._reddot ~= nil then
    RedDotController:RemoveListener((self._reddot).nodePath, self._reddotFunc)
    self._reddot = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__RefreshLvBtnStateCallback)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityUpdate, self.__RefreshChallengeBtnStateEvent)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityTimePass, self.__RefreshChallengeBtnStateEvent)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityUpdate, self.__RefreshTaskBtnStateCallback)
  ;
  (base.OnDelete)(self)
end

return UICharDunVer2

