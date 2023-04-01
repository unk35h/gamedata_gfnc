-- params : ...
-- function num : 0 , upvalues : _ENV
local FlappyBirdController = class("FlappyBirdController")
local cs_RangFunc = CS.RandomUtility
local TinyGameFrameController = require("Game.TinyGames.TinyGameFrameController")
local FlappyBird_Bird = require("Game.TinyGames.FlappyBird.Entity.FlappyBird_Bird")
local FlappyBird_TubeGroup = require("Game.TinyGames.FlappyBird.Entity.FlappyBird_TubeGroup")
local FlappyBird_Chocolate = require("Game.TinyGames.FlappyBird.Entity.FlappyBird_Chocolate")
local FlappyBird_AccItem = require("Game.TinyGames.FlappyBird.Entity.FlappyBird_AccItem")
local MapConfig = require("Game.TinyGames.FlappyBird.Config.FlappyBirdMapConfig")
local tinyGameEnum = require("Game.TinyGames.TinyGameEnum")
local PlayGroundHeight = 600000
local PlayGroundWidth = 1500000
FlappyBirdController.ctor = function(self, activityFwId, birdConfigId, hasGettedJoinReward, maxScore, isHistoryOpen, HTGData, isRemaster)
  -- function num : 0_0 , upvalues : _ENV, TinyGameFrameController
  self.netWork = NetworkManager:GetNetwork(NetworkTypeID.FlappyBird)
  self.activityFwId = activityFwId
  self.__isHistoryOpen = isHistoryOpen
  self.__HTGData = HTGData
  self.__isRemaster = isRemaster
  self.birdConfigId = birdConfigId
  self.hasGettedJoinReward = hasGettedJoinReward
  self.maxScore = maxScore
  self.frameCtrl = (TinyGameFrameController.New)()
  local frameLen = (self.frameCtrl):GetLogicFrameLen()
  self:InitGameConfigData(frameLen)
  self:FirstRewardInit()
  self.farthestTubX = 0
  self.birdEntity = nil
  self.livingTubeEntities = {}
  self.recycledTubeEntities = {}
  self.livingChocolateEntities = {}
  self.recycledChocolateEntities = {}
  self.livingAccEntities = {}
  self.recycledAccEntities = {}
  self.__inputBuff = false
  self.__score = 0
  self.__passTube = 0
  self.__getChocoTimes = 0
  self.seed = 0
  self.__isAccing = false
  self.__OnLogicFrameUpdate = BindCallback(self, self.OnLogicFrameUpdate)
  self.__OnRenderFrameUpdate = BindCallback(self, self.OnRenderFrameUpdate)
  self.__startGame = BindCallback(self, self.StartPlay)
  self.__inputJump = BindCallback(self, self.InputJump)
  self.__resetGame = BindCallback(self, self.__ResetGame)
  self.__getScore = BindCallback(self, self.__GetScore)
  self.__onExit = BindCallback(self, self.OnExit)
  self.__showRanking = BindCallback(self, self.__ReqShowRanking)
end

FlappyBirdController.FirstRewardInit = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local rewardList = ((ConfigData.flappy_bird)[self.birdConfigId]).firstAwards
  self.itemTransDic = {}
  self.firstRewardDic = {}
  for i,v in pairs(rewardList) do
    local itemCfg = (ConfigData.item)[v.itemId]
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.firstRewardDic)[v.itemId] = v.count
    if itemCfg.overflow_type == eItemTransType.actMoneyX then
      local num = PlayerDataCenter:GetItemOverflowNum(v.itemId, v.count)
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R9 in 'UnsetPending'

      if num ~= 0 then
        (self.itemTransDic)[v.itemId] = num
      end
    end
  end
end

FlappyBirdController.InjectExitAction = function(self, exitAction)
  -- function num : 0_2
  self.__exitAction = exitAction
end

FlappyBirdController.InjectModifyBirdMsgAction = function(self, setMaxScoreAction, setHasGettedJoinRewardAction)
  -- function num : 0_3
  self.__setMaxScore = setMaxScoreAction
  self.__setGettedJoinRewardAction = setHasGettedJoinRewardAction
end

FlappyBirdController.InitGameConfigData = function(self, frameLen)
  -- function num : 0_4 , upvalues : MapConfig, PlayGroundHeight
  self.originBackGroundMoveSpeed = MapConfig.originBackGroundMoveSpeed * frameLen
  self:__ResetBgViewSpeed()
  self.originDistance = MapConfig.originDistance
  self.evnData = {
backGroudMoveSpeed = {x = self.originBackGroundMoveSpeed, y = 0}
, gravityScale = MapConfig.gravityScale * frameLen * frameLen // 100, jumpForce = MapConfig.jumpForce * frameLen, playGroundHeight = PlayGroundHeight, minVerticalVelocity = MapConfig.minVerticalVelocity}
end

FlappyBirdController.ShowFlappyBirdUI = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.__isHistoryOpen and not self.__isRemaster then
    self:__InternalShowFlappyBirdUI(nil, self.maxScore)
    return 
  end
  ;
  (self.netWork):CS_FlappyBird_ProgressDetail(self.activityFwId, self.birdConfigId, function(objList)
    -- function num : 0_5_0 , upvalues : _ENV, self
    if objList.Count <= 0 then
      error("CS_FlappyBird_SelfRankDetail objList.Count:" .. tostring(objList.Count))
      return 
    end
    local msg = objList[0]
    self:__InternalShowFlappyBirdUI(msg.progress, self.maxScore)
  end
)
end

FlappyBirdController.SetFlappyBirdActEndTime = function(self, endTime)
  -- function num : 0_6
  self.endTime = endTime
end

FlappyBirdController.__InternalShowFlappyBirdUI = function(self, progress, maxScore)
  -- function num : 0_7 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.FlappyBird, function(win)
    -- function num : 0_7_0 , upvalues : self, progress, maxScore
    if win ~= nil then
      self.playUI = win
      if progress ~= nil then
        win:ShowProgress(progress, self.birdConfigId, self.hasGettedJoinReward)
      end
      win:SetIsHistoryOpen(self.__isHistoryOpen, self.__HTGData, self.__isRemaster, self.endTime)
      win:RefreshHighestScore(maxScore)
      win:InjectAction(self.__startGame, self.__inputJump, self.__resetGame, self.__getScore, self.__onExit, self.__showRanking)
    end
  end
)
end

FlappyBirdController.OnExit = function(self)
  -- function num : 0_8
  (self.frameCtrl):StopRunning()
  if self.__exitAction ~= nil then
    (self.__exitAction)()
  end
  self:OnDelete()
end

FlappyBirdController.__GetScore = function(self)
  -- function num : 0_9
  return self.__score
end

FlappyBirdController.InitRandom = function(self, seed)
  -- function num : 0_10 , upvalues : cs_RangFunc
  (cs_RangFunc.Init)(seed)
end

FlappyBirdController.StartPlay = function(self)
  -- function num : 0_11 , upvalues : _ENV
  self.seed = (math.random)(0, 100000)
  self:InitRandom(self.seed)
  self:InitPlay(self.seed)
  ;
  (self.frameCtrl):StartRunning(self.__OnLogicFrameUpdate, self.__OnRenderFrameUpdate)
end

FlappyBirdController.__ResetGame = function(self)
  -- function num : 0_12
  (self.frameCtrl):StopRunning()
  ;
  (self.playUI):RefreshHighestScore(self.maxScore)
  self.__score = 0
  self.__passTube = 0
  self.__getChocoTimes = 0
  self.farthestTubX = self.originDistance
  ;
  (self.playUI):RefreshScore(self.__score)
  ;
  (self.playUI):SetMiddleBackgroundSpeed(0, 0)
  self:__ResetBgViewSpeed()
  if self.birdEntity ~= nil then
    (self.birdEntity):ResetBird(self.birdEntity)
    ;
    (self.playUI):UpdateBirdRotation(self.birdEntity)
    ;
    (self.playUI):SetEntityPos(self.birdEntity)
    ;
    (self.playUI):OnShowInvinciableChange(false)
  end
  self:__RecycleAllSceneItems()
end

FlappyBirdController.InitPlay = function(self, seed)
  -- function num : 0_13 , upvalues : FlappyBird_Bird, MapConfig, _ENV
  self.__score = 0
  self.__passTube = 0
  self.__getChocoTimes = 0
  self:__RecycleAllSceneItems()
  if self.birdEntity == nil then
    self.birdEntity = (FlappyBird_Bird.New)(self.evnData)
    ;
    (self.birdEntity):SetColliderSize(MapConfig.birdSize)
    ;
    (self.birdEntity):InjectUpdateInvinciableView(BindCallback(self, self.__UpdateBirdInvinciableView), MapConfig.invinciableRemainFrame)
  end
  ;
  (self.birdEntity):ResetBird()
  ;
  (self.playUI):InitBird(self.birdEntity)
  ;
  (self.playUI):RefreshScore(0)
  self:SetBackGroundSpeedX(self.originBackGroundMoveSpeed)
  self.__isAccing = false
  ;
  (self.playUI):OnAccStateChange(false)
  self.farthestTubX = self.originDistance
  self.__inputBuff = false
end

FlappyBirdController.__UpdateBirdInvinciableView = function(self, value, speed)
  -- function num : 0_14
  (self.playUI):OnShowInvinciableChange(value, speed)
end

FlappyBirdController.__RecycleAllSceneItems = function(self)
  -- function num : 0_15
  for i = #self.livingTubeEntities, 1, -1 do
    self:__RecycleTubeEntity(i)
  end
  for i = #self.livingChocolateEntities, 1, -1 do
    self:__RecycleChocoEntity(i)
  end
  for i = #self.livingAccEntities, 1, -1 do
    self:__RecycleAccEntity(i)
  end
end

FlappyBirdController.GenTubes2End = function(self)
  -- function num : 0_16 , upvalues : cs_RangFunc
  local tempGroupData, randomWeightSum = self:__CheckAndGetGroupData()
  while self:IsNeedGenTubeGroup() do
    local groupRandom = (cs_RangFunc.Range)(1, randomWeightSum)
    local groupData = self:__CheckAndGetGroupDataWithWeight(tempGroupData, groupRandom)
    local posx = self.farthestTubX + groupData.foreGDistance + (groupData.groupOffset).x
    local posy = (groupData.groupOffset).y + (cs_RangFunc.Range)((groupData.verticalOffsetRange)[1], (groupData.verticalOffsetRange)[2])
    local tubeGroup = self:GenTube(posx, posy, groupData)
    if groupData.itemChildren ~= nil then
      self:GenSceneItemEntity(posx, posy, groupData.itemChildren)
    end
    self.farthestTubX = posx + groupData.backGDistance
  end
end

FlappyBirdController.__CheckAndGetGroupData = function(self)
  -- function num : 0_17 , upvalues : _ENV, MapConfig
  local checkedTubeGroupData = {}
  local randomWeightSum = 0
  for _,v in ipairs(MapConfig.sceneGroupData) do
    if not v.dieScore then
      local dieScore = self.__score
    end
    if v.bornScore <= self.__score and self.__score <= dieScore then
      randomWeightSum = randomWeightSum + v.randomWeight
      ;
      (table.insert)(checkedTubeGroupData, v)
    end
  end
  return checkedTubeGroupData, randomWeightSum
end

FlappyBirdController.__CheckAndGetGroupDataWithWeight = function(self, groupData, randomValue)
  -- function num : 0_18 , upvalues : _ENV
  local finalIndex = 1
  local groupWeightValue = 0
  for index,v in ipairs(groupData) do
    groupWeightValue = groupWeightValue + v.randomWeight
    if randomValue <= groupWeightValue then
      finalIndex = index
      break
    end
  end
  do
    return groupData[finalIndex]
  end
end

FlappyBirdController.GenSceneItemEntity = function(self, groupPosX, groupPosY, itemChildren)
  -- function num : 0_19 , upvalues : _ENV, cs_RangFunc, MapConfig
  for _,v in ipairs(itemChildren) do
    if v.itemWeight >= (cs_RangFunc.Range)(0, 100) then
      local posX = (v.itemOffset).x + groupPosX
      local posY = (v.itemOffset).y + groupPosY
      if (v.itemData).itemType == (MapConfig.eItemType).accItem then
        self:GenAccItem(posX, posY, v.itemData)
      else
        if (v.itemData).itemType == (MapConfig.eItemType).scoreItem then
          self:GenChocolate(posX, posY, v.itemData)
        end
      end
    end
  end
end

FlappyBirdController.IsNeedGenTubeGroup = function(self)
  -- function num : 0_20 , upvalues : PlayGroundWidth
  if self.farthestTubX < PlayGroundWidth then
    return true
  else
    return false
  end
end

FlappyBirdController.InputJump = function(self)
  -- function num : 0_21
  if (self.frameCtrl):GetIsRunning() then
    self.__inputBuff = true
  end
end

FlappyBirdController.GenTube = function(self, posx, posy, groupData)
  -- function num : 0_22 , upvalues : FlappyBird_TubeGroup, _ENV
  local type = groupData.groupType
  local newTubeGroupEntity = nil
  if (self.recycledTubeEntities)[type] == nil or #(self.recycledTubeEntities)[type] <= 0 then
    newTubeGroupEntity = (FlappyBird_TubeGroup.New)(self.evnData)
    newTubeGroupEntity:SetGroupType(type)
    newTubeGroupEntity:InitWithGroupData(groupData)
  else
    newTubeGroupEntity = (table.remove)((self.recycledTubeEntities)[type])
  end
  newTubeGroupEntity:SetIsPickScore(false)
  newTubeGroupEntity:SetPos(posx, posy)
  ;
  (table.insert)(self.livingTubeEntities, newTubeGroupEntity)
  local tubeEntityList = newTubeGroupEntity:GetTubeEntityList()
  ;
  (self.playUI):InitTubeEntityFromItemPool(tubeEntityList)
  return newTubeGroupEntity
end

FlappyBirdController.__RecycleTubeEntity = function(self, index)
  -- function num : 0_23 , upvalues : _ENV
  local tubeGroupEntity = (self.livingTubeEntities)[index]
  if tubeGroupEntity == nil then
    return 
  end
  ;
  (table.remove)(self.livingTubeEntities, index)
  local tubeGroupType = tubeGroupEntity:GetTubeGroupType()
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  if (self.recycledTubeEntities)[tubeGroupType] == nil then
    (self.recycledTubeEntities)[tubeGroupType] = {}
  end
  ;
  (table.insert)((self.recycledTubeEntities)[tubeGroupType], tubeGroupEntity)
  local tubeChildrenList = tubeGroupEntity:GetTubeEntityList()
  ;
  (self.playUI):RecycleATube(tubeChildrenList)
end

FlappyBirdController.GenChocolate = function(self, posx, posy, itemData)
  -- function num : 0_24 , upvalues : FlappyBird_Chocolate, _ENV
  local newChocolateEntity = nil
  if #self.recycledChocolateEntities <= 0 then
    newChocolateEntity = (FlappyBird_Chocolate.New)(self.evnData)
  else
    newChocolateEntity = (table.remove)(self.recycledChocolateEntities)
  end
  newChocolateEntity:SetPos(posx, posy)
  newChocolateEntity:SetColliderSize(-(itemData.scale).halfWidth, -(itemData.scale).halfHeight, (itemData.scale).halfWidth, (itemData.scale).halfHeight)
  ;
  (table.insert)(self.livingChocolateEntities, newChocolateEntity)
  ;
  (self.playUI):InitChocolate(newChocolateEntity)
  return newChocolateEntity
end

FlappyBirdController.__RecycleChocoEntity = function(self, index)
  -- function num : 0_25 , upvalues : _ENV
  local chocolateEntity = (self.livingChocolateEntities)[index]
  if chocolateEntity == nil then
    return 
  end
  ;
  (table.remove)(self.livingChocolateEntities, index)
  ;
  (table.insert)(self.recycledChocolateEntities, chocolateEntity)
  ;
  (self.playUI):RecycleChocolate(chocolateEntity)
end

FlappyBirdController.GenAccItem = function(self, posx, posy, itemData)
  -- function num : 0_26 , upvalues : FlappyBird_AccItem, _ENV
  local accEntity = nil
  if #self.recycledAccEntities <= 0 then
    accEntity = (FlappyBird_AccItem.New)(self.evnData)
  else
    accEntity = (table.remove)(self.recycledAccEntities)
  end
  accEntity:SetPos(posx, posy)
  accEntity:SetColliderSize(-(itemData.scale).halfWidth, -(itemData.scale).halfHeight, (itemData.scale).halfWidth, (itemData.scale).halfHeight)
  ;
  (table.insert)(self.livingAccEntities, accEntity)
  ;
  (self.playUI):InitAccItem(accEntity)
  return accEntity
end

FlappyBirdController.__RecycleAccEntity = function(self, index)
  -- function num : 0_27 , upvalues : _ENV
  local accEntity = (self.livingAccEntities)[index]
  if accEntity == nil then
    return 
  end
  ;
  (table.remove)(self.livingAccEntities, index)
  ;
  (table.insert)(self.recycledAccEntities, accEntity)
  ;
  (self.playUI):RecycleAccItem(accEntity)
end

FlappyBirdController.IsFlappyBirdDead = function(self)
  -- function num : 0_28 , upvalues : PlayGroundHeight, _ENV
  if (self.birdEntity):IsInvinciable() then
    return false
  end
  if ((self.birdEntity).pos).y <= -PlayGroundHeight then
    return true
  end
  for _,tubeEntity in ipairs(self.livingTubeEntities) do
    if tubeEntity:IsOnCollission(self.birdEntity) then
      return true
    end
  end
end

FlappyBirdController.DetectedGetChocolate = function(self)
  -- function num : 0_29 , upvalues : _ENV
  for index,chocolateEntity in ipairs(self.livingChocolateEntities) do
    if chocolateEntity:IsOnCollission(self.birdEntity) then
      self:__RecycleChocoEntity(index)
      self:__AddScore(chocolateEntity.bonusScore)
      self.__getChocoTimes = self.__getChocoTimes + 1
      ;
      (self.playUI):RefreshScore(self.__score)
      ;
      (self.playUI):OnDetectedChocolate()
    end
  end
end

FlappyBirdController.__AddScore = function(self, value)
  -- function num : 0_30
  self.__score = self.__score + value
end

FlappyBirdController.DetectedAccItem = function(self)
  -- function num : 0_31 , upvalues : _ENV
  for index,accEntity in ipairs(self.livingAccEntities) do
    if accEntity:IsOnCollission(self.birdEntity) then
      self:__RecycleAccEntity(index)
      ;
      (self.birdEntity):SetInvinciable(true, accEntity.invinciableDuration)
      self:__UpdateBirdInvinciableView(true, 13)
      ;
      (self.birdEntity):ReSetVelocity()
      self:SetAccDuration(true, accEntity.accLastFrame)
      self:SetBackGroundSpeedX(self.originBackGroundMoveSpeed * accEntity.speedRatio)
      self:__MultiBgViewSpeed(accEntity.speedRatio)
    end
  end
end

FlappyBirdController.__MultiBgViewSpeed = function(self, ratio)
  -- function num : 0_32 , upvalues : MapConfig
  self.midBgViewSpeed = MapConfig.midBgViewSpeed * ratio
  self.longBgViewSpeed = MapConfig.longBgViewSpeed * ratio
end

FlappyBirdController.SetAccDuration = function(self, value, duration)
  -- function num : 0_33
  self.__isAccing = value
  self.__accDuration = duration
  ;
  (self.birdEntity):SetGravityInfluenceEnable(not value)
  ;
  (self.playUI):OnAccStateChange(value)
end

FlappyBirdController.UpdateAcc = function(self)
  -- function num : 0_34
  if not self.__isAccing then
    return 
  end
  if self.__accDuration <= 0 then
    self:SetAccDuration(false, 0)
    self:SetBackGroundSpeedX(self.originBackGroundMoveSpeed)
    self:__ResetBgViewSpeed()
  else
    self.__accDuration = self.__accDuration - 1
  end
end

FlappyBirdController.SetBackGroundSpeedX = function(self, value)
  -- function num : 0_35
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.evnData).backGroudMoveSpeed).x = value
end

FlappyBirdController.GetBackGroundSpeed = function(self)
  -- function num : 0_36
  return (self.evnData).backGroudMoveSpeed
end

FlappyBirdController.__ResetBgViewSpeed = function(self)
  -- function num : 0_37 , upvalues : MapConfig
  self.midBgViewSpeed = MapConfig.midBgViewSpeed
  self.longBgViewSpeed = MapConfig.longBgViewSpeed
end

FlappyBirdController.OnLogicFrameUpdate = function(self, logicFrameNum)
  -- function num : 0_38
  self:__ForceSetAllEntityPos()
  self:DetectedGetChocolate()
  self:DetectedAccItem()
  if self:IsFlappyBirdDead() then
    (self.frameCtrl):StopRunning()
    ;
    (self.playUI):PlayBirdDeadTween(self.birdEntity, function()
    -- function num : 0_38_0 , upvalues : self, logicFrameNum
    self:__ReqBirdSettle(logicFrameNum)
  end
)
    return true
  end
  self:__HandleSceneItemRecycle()
  self:UpdateAcc()
  if self.__isAccing then
    self.__inputBuff = false
  end
  if self.__inputBuff then
    if not (self.birdEntity):IsCompletedFirstJump() then
      (self.playUI):ShowFinger(false)
    end
    ;
    (self.birdEntity):Jump((self.evnData).jumpForce)
    self.__inputBuff = false
  end
  ;
  (self.birdEntity):OnUpdateLogic()
  self:__InternalLogicUpdateEntityList(self.livingChocolateEntities)
  self:__InternalLogicUpdateEntityList(self.livingAccEntities)
  self:__HandleTubeGen()
  self:__InternalLogicUpdateTubeGroupList()
end

FlappyBirdController.__HandleTubeGen = function(self)
  -- function num : 0_39
  if not (self.birdEntity):IsCompletedFirstJump() then
    return 
  end
  local tempMoveSpeed = self:GetBackGroundSpeed()
  self.farthestTubX = self.farthestTubX + tempMoveSpeed.x
  if not self:IsNeedGenTubeGroup() then
    return 
  end
  self:GenTubes2End()
end

FlappyBirdController.__ForceSetAllEntityPos = function(self)
  -- function num : 0_40 , upvalues : _ENV
  (self.playUI):SetEntityPos(self.birdEntity)
  for _,tubeGroupEntity in ipairs(self.livingTubeEntities) do
    local tubeEntityList = tubeGroupEntity:GetTubeEntityList()
    for _k,tubeEntity in ipairs(tubeEntityList) do
      (self.playUI):SetEntityPos(tubeEntity)
    end
  end
  for _,entity in ipairs(self.livingChocolateEntities) do
    (self.playUI):SetEntityPos(entity)
  end
  for _,entity in ipairs(self.livingAccEntities) do
    (self.playUI):SetEntityPos(entity)
  end
end

FlappyBirdController.__InternalLogicUpdateEntityList = function(self, entityList)
  -- function num : 0_41 , upvalues : _ENV
  for _,entity in ipairs(entityList) do
    entity:OnUpdateLogic()
  end
end

FlappyBirdController.__InternalLogicUpdateTubeGroupList = function(self)
  -- function num : 0_42 , upvalues : _ENV
  for _,entity in ipairs(self.livingTubeEntities) do
    entity:OnUpdateLogic()
    if ((self.birdEntity).pos).x >= (entity.pos).x and not entity:GetIsPickScore() then
      entity:SetIsPickScore(true)
      self.__passTube = self.__passTube + 1
      self:__AddScore(entity.bonusScore)
      ;
      (self.playUI):OnGetScore(self.__score)
    end
  end
end

FlappyBirdController.__HandleSceneItemRecycle = function(self)
  -- function num : 0_43
  self:__CheckSceneItemAndRecycle(self.livingTubeEntities, self.__RecycleTubeEntity)
  self:__CheckSceneItemAndRecycle(self.livingChocolateEntities, self.__RecycleChocoEntity)
  self:__CheckSceneItemAndRecycle(self.livingAccEntities, self.__RecycleAccEntity)
end

FlappyBirdController.__CheckSceneItemAndRecycle = function(self, livingEntities, recycleFunc)
  -- function num : 0_44
  if recycleFunc == nil then
    return 
  end
  for i = #livingEntities, 1, -1 do
    local tempEntity = livingEntities[i]
    if self:__CheckItemPosBeyondScene(tempEntity) then
      recycleFunc(self, i)
    end
  end
end

FlappyBirdController.__CheckItemPosBeyondScene = function(self, tempEntity)
  -- function num : 0_45 , upvalues : PlayGroundWidth
  do return (tempEntity.pos).x < -PlayGroundWidth end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

FlappyBirdController.OnRenderFrameUpdate = function(self, timeRate)
  -- function num : 0_46 , upvalues : _ENV
  (self.playUI):SetMiddleBackgroundSpeed(self.midBgViewSpeed, self.longBgViewSpeed)
  ;
  (self.playUI):UpdateEntityRender(timeRate, self.birdEntity)
  ;
  (self.playUI):UpdateBirdRotation(self.birdEntity)
  for _,tubeGroupEntity in ipairs(self.livingTubeEntities) do
    local tubeEntityList = tubeGroupEntity:GetTubeEntityList()
    for _k,tubeEntity in ipairs(tubeEntityList) do
      (self.playUI):UpdateEntityRender(timeRate, tubeEntity)
    end
  end
  self:__InternalRenderUpdateEntityList(timeRate, self.livingChocolateEntities)
  self:__InternalRenderUpdateEntityList(timeRate, self.livingAccEntities)
end

FlappyBirdController.__InternalRenderUpdateEntityList = function(self, timeRate, entityList)
  -- function num : 0_47 , upvalues : _ENV
  for _,entity in ipairs(entityList) do
    (self.playUI):UpdateEntityRender(timeRate, entity)
  end
end

FlappyBirdController.__ReqBirdSettle = function(self, logicFrameNum)
  -- function num : 0_48 , upvalues : _ENV
  local combineArg = 0
  if self.__passTube ~= nil and self.__getChocoTimes ~= nil then
    combineArg = self.__passTube << 32 | self.__getChocoTimes
  end
  if self.__isHistoryOpen then
    (self.__HTGData):HTGCommonSettle(self.__score, function(tinyGameCenterElem)
    -- function num : 0_48_0 , upvalues : self
    self.maxScore = tinyGameCenterElem.highest
    local rankData = (self.__HTGData):GetHTGRankData()
    local allFriendData = rankData.allFriendData
    local mineGrade = rankData.mineGrade
    local finalData = self:__GetResultFriendRankingData(allFriendData, mineGrade)
    ;
    (self.playUI):ShowFlappyBirdResult({score = tinyGameCenterElem.score}, finalData, mineGrade, self.hasGettedJoinReward)
  end
)
    return 
  end
  ;
  (self.netWork):CS_FlappyBird_Settle(self.activityFwId, self.birdConfigId, self.__score, logicFrameNum, combineArg, function(objList)
    -- function num : 0_48_1 , upvalues : _ENV, self
    if objList.Count <= 0 then
      error("CS_FlappyBird_Settle objList.Count error:" .. tostring(objList.Count))
      return 
    end
    local msg = objList[0]
    self:__ShowFirstReward(msg)
    local mineGrade = self:__CreateMineGrade(msg)
    if not self:__GetFriendBirdData() then
      local allFriendData = {}
    end
    ;
    (table.insert)(allFriendData, mineGrade)
    self:__SortFriendData(allFriendData)
    local finalData = self:__GetResultFriendRankingData(allFriendData, mineGrade)
    if not self.hasGettedJoinReward and msg.rewards ~= nil and (table.count)(msg.rewards) > 0 then
      self.hasGettedJoinReward = true
      if self.__setGettedJoinRewardAction ~= nil then
        (self.__setGettedJoinRewardAction)(true)
      end
    end
    ;
    (self.playUI):ShowFlappyBirdResult(msg, finalData, mineGrade, self.hasGettedJoinReward)
  end
)
end

FlappyBirdController.__ShowFirstReward = function(self, msg)
  -- function num : 0_49 , upvalues : _ENV
  if msg.rewards ~= nil and (table.count)(msg.rewards) > 0 then
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_49_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    local CommonRewardData = require("Game.CommonUI.CommonRewardData")
    local CRData = ((CommonRewardData.CreateCRDataUseDic)(self.firstRewardDic)):SetCRNotHandledGreat(true)
    CRData:SetCRItemTransDic(self.itemTransDic)
    window:AddAndTryShowReward(CRData)
  end
)
  end
end

FlappyBirdController.__GetFriendBirdData = function(self)
  -- function num : 0_50 , upvalues : _ENV
  if not (PlayerDataCenter.friendDataCenter):IsFriendDataCenterInited() then
    return nil
  end
  local friendsData = (PlayerDataCenter.friendDataCenter):GetFreindList()
  if friendsData == nil or #friendsData <= 0 then
    return nil
  end
  local allBirdGrades = {}
  for _,v in ipairs(friendsData) do
    local eachFriendGrade = {}
    eachFriendGrade.name = v:GetUserName()
    eachFriendGrade.score = 0
    eachFriendGrade.uid = v:GetUserUID()
    local frindBirdData = v:GetFriendBirdData()
    if frindBirdData ~= nil and frindBirdData.birdId == self.birdConfigId then
      eachFriendGrade.score = frindBirdData.birdScore
    end
    ;
    (table.insert)(allBirdGrades, eachFriendGrade)
  end
  return allBirdGrades
end

FlappyBirdController.__GetResultFriendRankingData = function(self, allFriendData, mineGrade)
  -- function num : 0_51 , upvalues : _ENV
  local finalData = {}
  for index,v in ipairs(allFriendData) do
    v.grade_index = index
    if v == mineGrade then
      if index > 1 then
        (table.insert)(finalData, allFriendData[index - 1])
      end
      ;
      (table.insert)(finalData, v)
      local tempIndex = index
      while 1 do
        while 1 do
          if #finalData < 3 then
            tempIndex = tempIndex + 1
            if tempIndex <= #allFriendData then
              do
                local tempData = allFriendData[tempIndex]
                tempData.grade_index = tempIndex
                ;
                (table.insert)(finalData, tempData)
                -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
        return finalData
      end
      return finalData
    end
  end
  return finalData
end

FlappyBirdController.__ReqShowRanking = function(self)
  -- function num : 0_52 , upvalues : _ENV, tinyGameEnum
  local LocalFunc_Enter = function()
    -- function num : 0_52_0 , upvalues : self, _ENV, tinyGameEnum
    if self.__isHistoryOpen then
      local rankData = (self.__HTGData):GetHTGRankData()
      do
        local allFriendData = rankData.allFriendData
        local mineGrade = rankData.mineGrade
        UIManager:ShowWindowAsync(UIWindowTypeID.FlappyBirdRanking, function(window)
      -- function num : 0_52_0_0 , upvalues : allFriendData, mineGrade, self
      window:RefreshRankingData(allFriendData, mineGrade, self.__isHistoryOpen, self.__isRemaster)
      window:SetBestScore((self.__HTGData):GetHTGHistoryHighScore())
    end
)
        return 
      end
    end
    do
      ;
      (self.netWork):CS_FlappyBird_SelfRankDetail(self.activityFwId, self.birdConfigId, function(objList)
      -- function num : 0_52_0_1 , upvalues : _ENV, self, tinyGameEnum
      if objList.Count <= 0 then
        error("CS_FlappyBird_SelfRankDetail objList.Count error:" .. tostring(objList.Count))
        return 
      end
      local msg = objList[0]
      local mineGrade = self:__CreateMineGrade(msg)
      if not self:__GetFriendBirdData() then
        local allFriendData = {}
      end
      ;
      (table.insert)(allFriendData, mineGrade)
      self:__SortFriendData(allFriendData)
      UIManager:ShowWindowAsync(UIWindowTypeID.FlappyBirdRanking, function(window)
        -- function num : 0_52_0_1_0 , upvalues : allFriendData, mineGrade, self, _ENV, tinyGameEnum, msg
        window:RefreshRankingData(allFriendData, mineGrade, self.__isHistoryOpen, self.__isRemaster)
        if self.__isRemaster then
          local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
          local hisBestScore = activityFrameCtrl:GetTinyGameHistoryHighScore((tinyGameEnum.eType).flappyBird)
          hisBestScore = (math.max)(hisBestScore, msg.highestScore)
          window:SetBestScore(hisBestScore)
        end
      end
)
    end
)
    end
  end

  if (PlayerDataCenter.friendDataCenter):IsExpireFriendData() then
    local friendNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.Friend)
    friendNetCtrl:CS_FRIEND_RefreshFriend(LocalFunc_Enter)
  else
    do
      LocalFunc_Enter()
    end
  end
end

FlappyBirdController.__SortFriendData = function(self, allFriendData)
  -- function num : 0_53 , upvalues : _ENV
  if #allFriendData > 1 then
    (table.sort)(allFriendData, function(a, b)
    -- function num : 0_53_0
    if a.uid >= b.uid then
      do return a.score ~= b.score end
      do return b.score < a.score end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
)
  end
end

FlappyBirdController.__CreateMineGrade = function(self, msg)
  -- function num : 0_54 , upvalues : _ENV
  if self.mineGrade == nil then
    self.mineGrade = {}
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.mineGrade).name = PlayerDataCenter:GetSelfName()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.mineGrade).uid = PlayerDataCenter:GetSelfId()
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  if msg == nil then
    (self.mineGrade).score = 0
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.mineGrade).bydProgress = 0
  else
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.mineGrade).score = msg.highestScore or 0
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.mineGrade).bydProgress = msg.beyondProgress or 0
    self.maxScore = msg.highestScore
    if self.__setMaxScore ~= nil then
      (self.__setMaxScore)(msg.highestScore)
    end
  end
  return self.mineGrade
end

FlappyBirdController.GetIsHistoryOpen = function(self)
  -- function num : 0_55
end

FlappyBirdController.OnDelete = function(self)
  -- function num : 0_56
  self.playUI = nil
  self.activityFwId = nil
  self.birdConfigId = nil
  ;
  (self.frameCtrl):OnDelete()
end

return FlappyBirdController

