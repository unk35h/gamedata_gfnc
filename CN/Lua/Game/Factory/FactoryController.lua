-- params : ...
-- function num : 0 , upvalues : _ENV
local FactoryController = class("FactoryController", ControllerBase)
local base = ControllerBase
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local FactoryEnum = require("Game.Factory.FactoryEnum")
local FactoryRoomEntity = require("Game.Factory.Entity.FactoryRoomEntity")
local UIN3DFactoryCanvas = require("Game.Factory.UI3D.UIN3DFactoryCanvas")
local FactoryOrderData = require("Game.Factory.Data.FactoryOrderData")
local JumpManager = require("Game.Jump.JumpManager")
local NoticeData = require("Game.Notice.NoticeData")
local FactoryProcessingData = require("Game.Factory.Data.FactoryProcessingData")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local cs_MessageCommon = CS.MessageCommon
local FactoryCalcSendOrder = require("Game.Factory.Data.FactoryCalcSendOrder")
FactoryController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.networkCtrl = NetworkManager:GetNetwork(NetworkTypeID.Factory)
  self.unlockedRoom = {}
  self.unlockedCondicton = {}
  self.notOpenedRoom = {}
  self.enteredHero = {}
  self.factoryEnterArgs = (ConfigData.game_config).FactoryEnterArgs
  self.roomType = {}
  self.OrderDataDic = nil
  self.ProcessingOrders = {}
  self._lastOrders = {}
  self.OrderDataListDic = nil
  self.cameraDefaultPos = nil
  self.digOrderIds = nil
  self.produceOrderIds = nil
  self.roomEntityDic = nil
  self.roomBind = nil
  self.factoryMainUI = nil
  self.ui3DCanvas = nil
  self.resloader = nil
  self.Order4SendData = nil
  self:InitAllData(function()
    -- function num : 0_0_0 , upvalues : self
    self:AddNoticePreconditionData()
  end
)
  self.m_OnUpdateARG = BindCallback(self, self.OnUpdateARG)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.m_OnUpdateARG)
end

FactoryController.FadeFactory = function(self)
  -- function num : 0_1
  ((self.roomBind).factoryToHome):Play()
end

FactoryController.OpenFactory = function(self)
  -- function num : 0_2 , upvalues : _ENV
  UIManager:DeleteAllWindow()
  ;
  (UIUtil.AddOneCover)("openFactory", SafePack(nil, nil, nil, Color.black, false))
  self:InitAllData()
  ;
  ((CS.GSceneManager).Instance):LoadSceneByAB((Consts.SceneName).Factory, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    (UIUtil.CloseOneCover)("openFactory")
    AudioManager:PlayAudioById(3003)
    AudioManager:PlayAudioById(1088)
    self.resloader = ((CS.ResLoader).Create)()
    self:CheckUnlockCondiction()
    UIManager:ShowWindowAsync(UIWindowTypeID.Factory, function(win)
      -- function num : 0_2_0_0 , upvalues : self
      self.factoryMainUI = win
      self:InitBindingData()
      self:InitRoomEntities()
      self:OnUpdateProduceLineTime()
    end
)
    self.lineTimerId = TimerManager:StartTimer(1, self.OnUpdateProduceLineTime, self, false, nil, true)
  end
)
end

FactoryController.CloseFactory = function(self, notNeedBack2Home)
  -- function num : 0_3 , upvalues : _ENV
  if self.ui3DCanvas ~= nil then
    (self.ui3DCanvas):Delete()
    self.ui3DCanvas = nil
  end
  if self.factoryMainUI ~= nil then
    (self.factoryMainUI):Delete()
    self.factoryMainUI = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.lineTimerId ~= nil then
    TimerManager:StopTimer(self.lineTimerId)
    self.lineTimerId = nil
  end
  AudioManager:RemoveAllVoice()
  if notNeedBack2Home ~= true then
    UIManager:DeleteAllWindow()
    ;
    ((CS.GSceneManager).Instance):LoadSceneByAB((Consts.SceneName).Main, function()
    -- function num : 0_3_0 , upvalues : _ENV
    (ControllerManager:GetController(ControllerTypeId.HomeController, true)):OnEnterHome()
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    UIManager:CreateWindowAsync(UIWindowTypeID.Home, function(window)
      -- function num : 0_3_0_0 , upvalues : _ENV
      if window == nil then
        return 
      end
      window:SetFrom2Home(AreaConst.FactoryDorm, true)
    end
)
  end
)
  end
end

FactoryController.InitAllData = function(self, callback)
  -- function num : 0_4
  (self.networkCtrl):CS_FACTORY_Detail(function()
    -- function num : 0_4_0 , upvalues : self, callback
    self:CheckUnlockCondiction()
    self.OrderDataDic = {}
    self.OrderDataListDic = {}
    self:InitOrderDatas()
    if callback ~= nil then
      callback()
    end
  end
)
end

local ROOM_SLOT_NUM = 7
FactoryController.CheckUnlockCondiction = function(self)
  -- function num : 0_5 , upvalues : _ENV, ROOM_SLOT_NUM
  self.unlockedRoom = {}
  self.unlockedCondicton = {}
  self.notOpenedRoom = {}
  local factoryCfgs = ConfigData.factory
  for roomId,factoryCfg in pairs(factoryCfgs) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R7 in 'UnsetPending'

    if factoryCfg.is_open == 0 then
      (self.notOpenedRoom)[roomId] = true
    else
      local isUnlcok = (CheckCondition.CheckLua)(factoryCfg.pre_condition, factoryCfg.pre_para1, factoryCfg.pre_para2)
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R8 in 'UnsetPending'

      if isUnlcok then
        (self.unlockedRoom)[roomId] = isUnlcok
      else
        -- DECOMPILER ERROR at PC36: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self.unlockedCondicton)[roomId] = (CheckCondition.GetUnlockInfoLua)(factoryCfg.pre_condition, factoryCfg.pre_para1, factoryCfg.pre_para2)
      end
    end
  end
  for roomId = 1, ROOM_SLOT_NUM do
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R6 in 'UnsetPending'

    if (self.unlockedRoom)[roomId] == nil and (self.unlockedCondicton)[roomId] == nil then
      (self.notOpenedRoom)[roomId] = true
    end
  end
end

FactoryController.AddNoticePreconditionData = function(self)
  -- function num : 0_6 , upvalues : _ENV, NoticeData, JumpManager
  local factoryCfgs = ConfigData.factory
  for index,_ in pairs(self.unlockedCondicton) do
    local factoryCfg = factoryCfgs[index]
    do
      for index,pre_conditionId in ipairs(factoryCfg.pre_condition) do
        local pre_para1 = (factoryCfg.pre_para1)[index]
        local pre_para2 = (factoryCfg.pre_para2)[index]
        NoticeManager:Add2PreConditionDic(pre_conditionId, pre_para1, pre_para2, function()
    -- function num : 0_6_0 , upvalues : _ENV, factoryCfg, NoticeData, JumpManager
    if (CheckCondition.CheckLua)(factoryCfg.pre_condition, factoryCfg.pre_para1, factoryCfg.pre_para2) then
      NoticeManager:AddNotice((NoticeData.CreateNoticeData)(PlayerDataCenter.timestamp, (NoticeManager.eNoticeType).FactoryUnlockNewFactory, {jumpType = (JumpManager.eJumpTarget).Factory, argList = nil}, {(LanguageUtil.GetLocaleText)(factoryCfg.name)}, {id = factoryCfg.id}))
      return true
    end
  end
)
      end
    end
  end
  for orderId,factoryOrderData in pairs(self.OrderDataDic) do
    if not factoryOrderData.isUnlock then
      local orderCfg = factoryOrderData:GetOrderCfg()
      for index,pre_conditionId in ipairs(orderCfg.pre_condition) do
        local pre_para1 = (orderCfg.pre_para1)[index]
        local pre_para2 = (orderCfg.pre_para2)[index]
        NoticeManager:Add2PreConditionDic(pre_conditionId, pre_para1, pre_para2, function()
    -- function num : 0_6_1 , upvalues : _ENV, orderCfg, NoticeData, JumpManager
    if (CheckCondition.CheckLua)(orderCfg.pre_condition, orderCfg.pre_para1, orderCfg.pre_para2) then
      NoticeManager:AddNotice((NoticeData.CreateNoticeData)(PlayerDataCenter.timestamp, (NoticeManager.eNoticeType).FactoryUnlockNewOrder, {jumpType = (JumpManager.eJumpTarget).Factory, argList = nil}, {(LanguageUtil.GetLocaleText)(orderCfg.name)}, nil))
      return true
    end
  end
)
      end
    end
  end
end

FactoryController.GetRoomEnegeyByIndex = function(self, index)
  -- function num : 0_7 , upvalues : _ENV
  local factoryEnergyItemId = (ConfigData.game_config).factoryEnergyItemId
  local totalCeiling = (PlayerDataCenter.playerBonus):GetWarehouseCapcity(factoryEnergyItemId)
  local totalValue = PlayerDataCenter:GetItemCount(factoryEnergyItemId)
  return totalValue, totalCeiling
end

FactoryController.GetRoomEnegeyBaseSpeedByIndex = function(self, index)
  -- function num : 0_8 , upvalues : _ENV
  local factoryEnergyItemId = (ConfigData.game_config).factoryEnergyItemId
  local speed = (PlayerDataCenter.allEffectorData):GetCurrentARGSpeed(factoryEnergyItemId, true)
  return speed
end

FactoryController.OnRecRoomHeroList = function(self, linesInfo)
  -- function num : 0_9 , upvalues : _ENV, FactoryProcessingData
  for roomIndex,workshopGroup in pairs(linesInfo) do
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R7 in 'UnsetPending'

    (self.enteredHero)[roomIndex] = {}
    if workshopGroup.heroIds ~= nil then
      for heroId,_ in pairs(workshopGroup.heroIds) do
        (table.insert)((self.enteredHero)[roomIndex], heroId)
      end
    end
    do
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self.ProcessingOrders)[roomIndex] = {}
      if workshopGroup.process ~= nil then
        for uid,processOrderMsg in pairs(workshopGroup.process) do
          local factoryProcessData = (FactoryProcessingData.CreateProcessOrderData)(roomIndex, uid, processOrderMsg)
          -- DECOMPILER ERROR at PC39: Confused about usage of register: R13 in 'UnsetPending'

          ;
          ((self.ProcessingOrders)[roomIndex])[uid] = factoryProcessData
        end
      end
      do
        do
          -- DECOMPILER ERROR at PC47: Confused about usage of register: R7 in 'UnsetPending'

          if workshopGroup.lastOrder ~= nil then
            (self._lastOrders)[roomIndex] = workshopGroup.lastOrder
          end
          -- DECOMPILER ERROR at PC48: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC48: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
  end
  for roomIndex,heroIdList in pairs(self.enteredHero) do
    self:ChangeEnergyGenSpeed(roomIndex, heroIdList)
  end
  ;
  (PlayerDataCenter.allEffectorData):OnUpdateItemGenerateSpeed()
  self:OnUpdateARG()
  self:OnUpdateProduceLine()
end

FactoryController.HandleFactoryDiff = function(self, diffMsg)
  -- function num : 0_10 , upvalues : _ENV, FactoryProcessingData
  if diffMsg.update ~= nil then
    for mixId,workshopGroup in pairs(diffMsg.update) do
      local roomIndex = mixId >> 32
      local uid = mixId & CommonUtil.UInt32Max
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R9 in 'UnsetPending'

      if (self.ProcessingOrders)[roomIndex] == nil then
        (self.ProcessingOrders)[roomIndex] = {}
      end
      if workshopGroup.process ~= nil then
        for uid,processOrderMsg in pairs(workshopGroup.process) do
          local factoryProcessData = (FactoryProcessingData.CreateProcessOrderData)(roomIndex, uid, processOrderMsg)
          -- DECOMPILER ERROR at PC32: Confused about usage of register: R15 in 'UnsetPending'

          ;
          ((self.ProcessingOrders)[roomIndex])[uid] = factoryProcessData
        end
      end
    end
  end
  do
    if diffMsg.delete ~= nil then
      for mixId,_ in pairs(diffMsg.delete) do
        local roomIndex = mixId >> 32
        local uid = mixId & CommonUtil.UInt32Max
        -- DECOMPILER ERROR at PC50: Confused about usage of register: R9 in 'UnsetPending'

        ;
        ((self.ProcessingOrders)[roomIndex])[uid] = nil
      end
    end
    do
      for roomIndex,workShop in pairs(diffMsg.updateLastOrder) do
        -- DECOMPILER ERROR at PC59: Confused about usage of register: R7 in 'UnsetPending'

        (self._lastOrders)[roomIndex] = workShop.lastOrder
      end
      self:OnUpdateProduceLine()
    end
  end
end

FactoryController.SetRoomHeroList = function(self, lineId, heroList, callBack)
  -- function num : 0_11 , upvalues : _ENV
  (self.networkCtrl):CS_FACTORY_DispatchHero(lineId, heroList, function()
    -- function num : 0_11_0 , upvalues : heroList, _ENV, lineId, self, callBack
    if #heroList > 0 then
      local voHeroId = heroList[(math.random)(#heroList)]
      local voiceId = ConfigData:GetVoicePointRandom(eVoicePointType.InFactory, nil, voHeroId)
      local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
      cvCtr:PlayCv(voHeroId, voiceId)
    end
    do
      local needRefreshRoomDic = {}
      needRefreshRoomDic[lineId] = true
      for lineId,heroIds in pairs(self.enteredHero) do
        for i = #heroIds, 1, -1 do
          local heroId = heroIds[i]
          if (table.contain)(heroList, heroId) then
            (table.remove)(heroIds, i)
            needRefreshRoomDic[lineId] = true
          end
        end
      end
      -- DECOMPILER ERROR at PC58: Confused about usage of register: R1 in 'UnsetPending'

      ;
      (self.enteredHero)[lineId] = heroList
      for roomIndex,heroIdList in pairs(self.enteredHero) do
        self:ChangeEnergyGenSpeed(roomIndex, heroIdList)
      end
      ;
      (PlayerDataCenter.allEffectorData):OnUpdateItemGenerateSpeed()
      self:OnUpdateARG()
      if callBack ~= nil then
        callBack()
      end
      for roomIndex,_ in pairs(needRefreshRoomDic) do
      end
    end
  end
)
end

FactoryController.GetRoomHeroList = function(self)
  -- function num : 0_12
  return self.enteredHero
end

FactoryController.GetHeroEnterAccrate = function(self, roomIndex, heroIdList)
  -- function num : 0_13 , upvalues : _ENV
  local accRate = 0
  local _, _, baseSpeed = self:GetRoomEnegeyByIndex(roomIndex)
  for _,heroId in ipairs(heroIdList) do
    local heroData = (PlayerDataCenter.heroDic)[heroId]
    local level = heroData.level
    local rank = heroData.rank
    local starScore = ((ConfigData.star_score)[rank]).score
    local FriendShiplevel = (PlayerDataCenter.allFriendshipData):GetLevel(heroId)
    accRate = accRate + (starScore + level * (self.factoryEnterArgs)[1] + FriendShiplevel * (self.factoryEnterArgs)[2]) / ((self.factoryEnterArgs)[3] * 1000)
  end
  return accRate
end

FactoryController.GetOneHeroAccrateDetail = function(self, roomIndex, heroId)
  -- function num : 0_14 , upvalues : _ENV
  local levelRate = 0
  local friendshipRate = 0
  local RankRate = 0
  local dliverNum = (self.factoryEnterArgs)[3] * 1000
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  local level = heroData.level
  local rank = heroData.rank
  local starScore = ((ConfigData.star_score)[rank]).score
  local FriendShiplevel = (PlayerDataCenter.allFriendshipData):GetLevel(heroId)
  levelRate = level * (self.factoryEnterArgs)[1] / dliverNum
  friendshipRate = FriendShiplevel * (self.factoryEnterArgs)[2] / dliverNum
  RankRate = starScore / dliverNum
  return levelRate, friendshipRate, RankRate
end

FactoryController.ChangeEnergyGenSpeed = function(self, roomIndex, heroIdList)
  -- function num : 0_15
end

FactoryController.OnHeroDataChange = function(self)
  -- function num : 0_16
end

FactoryController.InitBindingData = function(self)
  -- function num : 0_17 , upvalues : _ENV, UIN3DFactoryCanvas
  self.roomEntityDic = {}
  self.roomBind = {}
  local cameraRoot = ((((CS.UnityEngine).GameObject).Find)("CameraRoot")).transform
  ;
  (UIUtil.LuaUIBindingTable)(cameraRoot, self.roomBind)
  self.cameraDefaultPos = (((self.roomBind).camera).transform).position
  self.ui3DCanvas = (UIN3DFactoryCanvas.New)()
  ;
  (self.ui3DCanvas):Init((self.roomBind).uICanvas)
  ;
  (self.ui3DCanvas):SetClickBackgroundCallback((self.factoryMainUI).m_OnClick3DBGWithPop)
  self.__CloseFactory = BindCallback(self, self.CloseFactory)
  ;
  ((self.roomBind).factoryToHome):stopped("+", self.__CloseFactory)
end

FactoryController.RefreshFactoryEnergyRedDot = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local factoryEnergyItemId = (ConfigData.game_config).factoryEnergyItemId
  local totalCeiling = (PlayerDataCenter.playerBonus):GetWarehouseCapcity(factoryEnergyItemId)
  local totalValue = PlayerDataCenter:GetItemCount(factoryEnergyItemId)
  local ok, factoryNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Factory, RedDotStaticTypeId.FactoryEnerage)
  if ok then
    if totalCeiling <= totalValue then
      factoryNode:SetRedDotCount(1)
    else
      factoryNode:SetRedDotCount(0)
    end
  end
end

FactoryController.OnUpdateARG = function(self, changedItemNumDic)
  -- function num : 0_19 , upvalues : _ENV
  if changedItemNumDic ~= nil and changedItemNumDic[(ConfigData.game_config).factoryEnergyItemId] ~= nil then
    self:RefreshFactoryEnergyRedDot()
    if self.factoryMainUI ~= nil then
      (self.factoryMainUI):UpdateEnergy()
    end
    local lineWin = UIManager:GetWindow(UIWindowTypeID.FactoryProduceLine)
    if lineWin ~= nil then
      lineWin:InitAllLines()
    end
  end
end

FactoryController.OnUpdateProduceLine = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if self.ui3DCanvas ~= nil then
    (self.ui3DCanvas):RefreshProcessLines(self.ProcessingOrders)
  end
  local productLineWin = UIManager:GetWindow(UIWindowTypeID.FactoryProduceLine)
  if productLineWin ~= nil then
    productLineWin:InitAllLines()
  end
  if self.factoryMainUI ~= nil then
    (self.factoryMainUI):RefreshProduceLineInfo()
  end
end

FactoryController.OnUpdateProduceLineTime = function(self)
  -- function num : 0_21 , upvalues : _ENV
  if self.ui3DCanvas ~= nil then
    (self.ui3DCanvas):RefreshProcessLines(self.ProcessingOrders)
  end
  local productLineWin = UIManager:GetWindow(UIWindowTypeID.FactoryProduceLine)
  if productLineWin ~= nil then
    productLineWin:OnTimeRefresh()
  end
  if self.factoryMainUI ~= nil then
    (self.factoryMainUI):RefreshProduceLineInfo()
  end
  self:RefreshFactoryRedDot()
end

FactoryController.RefreshFactoryRedDot = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local finishedOrderNum = 0
  for roomIndex,processingDataDic in pairs(self.ProcessingOrders) do
    for uid,processingData in pairs(processingDataDic) do
      if processingData:GetIsFinish() then
        finishedOrderNum = finishedOrderNum + 1
      end
    end
  end
  local nodeOk, heroNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Factory, RedDotStaticTypeId.FactoryProcessLine)
  if nodeOk then
    heroNode:SetRedDotCount(finishedOrderNum)
  end
end

FactoryController.InitOrderDatas = function(self)
  -- function num : 0_23 , upvalues : _ENV, FactoryOrderData
  for _,orderCfg in pairs(ConfigData.factory_order) do
    local isRoomUnlock = (self.unlockedRoom)[orderCfg.type]
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.OrderDataDic)[orderCfg.id] = (FactoryOrderData.CreateOrderData)(orderCfg, isRoomUnlock)
  end
end

FactoryController.GetOrders = function(self, roomIndex)
  -- function num : 0_24 , upvalues : _ENV
  do
    if (self.OrderDataListDic)[roomIndex] == nil then
      local orders = {}
      for orderId,orderData in pairs(self.OrderDataDic) do
        if orderData:GetOrderRoomIndex() == roomIndex then
          (table.insert)(orders, orderData)
        end
      end
      ;
      (table.sort)(orders, function(a, b)
    -- function num : 0_24_0
    if (a:GetOrderCfg()).id >= (b:GetOrderCfg()).id then
      do return a:GetIsUnlock() ~= b:GetIsUnlock() end
      do return a:GetIsUnlock() end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
      -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.OrderDataListDic)[roomIndex] = orders
    end
    for orderId,orderData in pairs(self.OrderDataDic) do
      orderData:UpdateOrderData()
    end
    return (self.OrderDataListDic)[roomIndex]
  end
end

FactoryController.InitRoomEntities = function(self)
  -- function num : 0_25 , upvalues : _ENV, FactoryRoomEntity, FactoryEnum
  local m_OnClickRoom = (self.factoryMainUI).m_OnClickRoom
  for index,_ in pairs(self.unlockedRoom) do
    do
      local roomType = ((ConfigData.factory)[index]).model
      local obj = self:GetRoomModelGo(index, roomType)
      local roomEntity = (FactoryRoomEntity.New)()
      roomEntity:InitRoomObject(obj, m_OnClickRoom, (FactoryEnum.eRoomType).normal, index, nil)
      -- DECOMPILER ERROR at PC25: Confused about usage of register: R10 in 'UnsetPending'

      ;
      (self.roomEntityDic)[index] = roomEntity
    end
  end
  for index,unlcokDes in pairs(self.unlockedCondicton) do
    local roomPath = PathConsts:GetFactoryPath("FactoryRoom_empty")
    ;
    (self.resloader):LoadABAssetAsync(roomPath, function(prefab)
    -- function num : 0_25_0 , upvalues : _ENV, index, self, FactoryRoomEntity, m_OnClickRoom, FactoryEnum, unlcokDes
    local roomType = ((ConfigData.factory)[index]).model
    local obj = self:GetRoomModelGo(index, roomType)
    local roomEntity = (FactoryRoomEntity.New)()
    roomEntity:InitRoomObject(obj, m_OnClickRoom, (FactoryEnum.eRoomType).locked, index, unlcokDes)
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.roomEntityDic)[index] = roomEntity
  end
)
  end
  for index,_ in pairs(self.notOpenedRoom) do
    local roomPath = PathConsts:GetFactoryPath("FactoryRoom_empty")
    ;
    (self.resloader):LoadABAssetAsync(roomPath, function(prefab)
    -- function num : 0_25_1 , upvalues : self, index, _ENV, FactoryRoomEntity, m_OnClickRoom, FactoryEnum
    local obj = prefab:Instantiate((self.roomBind).rooms)
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (obj.transform).position = ((((self.roomBind).rooms_normal)[index]).transform).position
    do
      if (CS.ClientConsts).IsAudit then
        local meshRender = obj:FindComponent(eUnityComponentID.MeshRenderer)
        meshRender.reflectionProbeUsage = (((CS.UnityEngine).Rendering).ReflectionProbeUsage).Off
        return 
      end
      local roomEntity = (FactoryRoomEntity.New)()
      roomEntity:InitRoomObject(obj, m_OnClickRoom, (FactoryEnum.eRoomType).notOpen, index)
      -- DECOMPILER ERROR at PC39: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.roomEntityDic)[index] = roomEntity
    end
  end
)
  end
end

FactoryController.ChangeRoomModelGo = function(self, index, type)
  -- function num : 0_26
  local entity = (self.roomEntityDic)[index]
  if entity.type == type then
    return 
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.roomType)[index] = type
  local go = self:GetRoomModelGo(index, type)
  if go ~= nil then
    entity:ChangeRoomModelGo(go, type)
  end
end

FactoryController.GetRoomModelGo = function(self, index, type)
  -- function num : 0_27 , upvalues : FactoryEnum, _ENV
  if type == (FactoryEnum.eRoomType).normal then
    return ((self.roomBind).rooms_normal)[index]
  else
    if type == (FactoryEnum.eRoomType).dig then
      return ((self.roomBind).rooms_dig)[index]
    else
      if type == (FactoryEnum.eRoomType).present then
        return ((self.roomBind).rooms_present)[index]
      else
        if type == (FactoryEnum.eRoomType).locked then
          error("commonly a unlocked room can\'t switch to lock")
        else
          return ((self.roomBind).rooms_normal)[index]
        end
      end
    end
  end
end

FactoryController.GetOrder4Send = function(self)
  -- function num : 0_28
  return self.Order4SendData
end

FactoryController.GetResItemDic4Order4Send = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if self.Order4SendData == nil then
    return nil
  end
  local dic = {}
  if (self.Order4SendData).curOrderId == nil then
    return nil
  end
  local orderCfg = (ConfigData.factory_order)[(self.Order4SendData).curOrderId]
  for itemId,cost in pairs(orderCfg.raw_material) do
    dic[itemId] = true
  end
  if (self.Order4SendData).assistOrderDic == nil then
    return dic
  end
  for assOrderId,assOrderNum in pairs((self.Order4SendData).assistOrderDic) do
    local orderCfg = (ConfigData.factory_order)[assOrderId]
    for itemId,cost in pairs(orderCfg.raw_material) do
      dic[itemId] = true
    end
  end
  return dic
end

FactoryController.ClearOrder = function(self)
  -- function num : 0_30
  self.Order4SendData = nil
  self.productOrderAddDic = nil
end

local MAX_TIME_COST = (ConfigData.game_config).factoryTimeCostLimit
FactoryController.TryAddOneOrder = function(self, lindIndex, orderData, usedBagItem)
  -- function num : 0_31 , upvalues : _ENV, FactoryEnum, MAX_TIME_COST, FactoryCalcSendOrder
  local orderCfg = orderData:GetOrderCfg()
  local orderId = orderCfg.id
  if self.Order4SendData ~= nil and ((self.Order4SendData).lineIndex ~= lindIndex or (self.Order4SendData).curOrderId ~= orderId) then
    error("doesn\'t clean old orderData")
    return false
  end
  if orderData:GetOrderType() == (FactoryEnum.eOrderType).dig then
    if self.Order4SendData == nil then
      local warehouseNotFull = orderData:GetIsWhareHouseNotFull(0)
      local couldAdd = MAX_TIME_COST / orderData:GetTimeCost() >= 1
      if couldAdd then
        if not warehouseNotFull then
          return false, (FactoryEnum.eCannotAddReason).warehouseFull
        end
        self.Order4SendData = (FactoryCalcSendOrder.CreateSendOrderDig)(orderId, 1, lindIndex, orderData)
        -- DECOMPILER ERROR at PC55: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self.Order4SendData).isOrderMax = false
        return true
      else
        return false, (FactoryEnum.eCannotAddReason).timeBeyountLimit
      end
    else
      local warehouseNotFull = orderData:GetIsWhareHouseNotFull((self.Order4SendData).curOrderNum)
      local couldAdd = (MAX_TIME_COST - (self.Order4SendData).usedTime) / orderData:GetTimeCost() >= 1
      if couldAdd then
        if not warehouseNotFull then
          return false, (FactoryEnum.eCannotAddReason).warehouseFull
        end
        -- DECOMPILER ERROR at PC91: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self.Order4SendData).curOrderNum = (self.Order4SendData).curOrderNum + 1
        -- DECOMPILER ERROR at PC98: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self.Order4SendData).usedTime = orderData:GetTimeCost() * (self.Order4SendData).curOrderNum
        return true
      else
        return false, (FactoryEnum.eCannotAddReason).timeBeyountLimit
      end
    end
  elseif orderData:GetOrderType() == (FactoryEnum.eOrderType).product then
    if self.Order4SendData == nil then
      local couldCreate, value = (FactoryCalcSendOrder.TryCreateSendOrderProduct)(orderData, lindIndex, MAX_TIME_COST, usedBagItem)
      if couldCreate then
        self.Order4SendData = value
        if (self.Order4SendData):HasSubOrder() then
          if self.productOrderAddDic == nil then
            self.productOrderAddDic = {}
          end
          -- DECOMPILER ERROR at PC142: Confused about usage of register: R8 in 'UnsetPending'

          ;
          (self.productOrderAddDic)[(self.Order4SendData).curOrderNum] = (table.deepCopy)(self.Order4SendData)
        end
        return true
      else
        return false, value
      end
    else
      local couldAdd, value = (self.Order4SendData):CheckNextProductOrder(MAX_TIME_COST, usedBagItem)
      if couldAdd then
        if (self.Order4SendData):HasSubOrder() then
          if self.productOrderAddDic == nil then
            self.productOrderAddDic = {}
          end
          -- DECOMPILER ERROR at PC174: Confused about usage of register: R8 in 'UnsetPending'

          ;
          (self.productOrderAddDic)[(self.Order4SendData).curOrderNum] = (table.deepCopy)(self.Order4SendData)
        end
        return true
      else
        return false, value
      end
    end
  end
  -- DECOMPILER ERROR: 16 unprocessed JMP targets
end

FactoryController.TryMinOneOrder = function(self, lindIndex, orderData)
  -- function num : 0_32 , upvalues : _ENV, FactoryEnum
  local orderCfg = orderData:GetOrderCfg()
  local orderId = orderCfg.id
  if self.Order4SendData ~= nil and ((self.Order4SendData).lineIndex ~= lindIndex or (self.Order4SendData).curOrderId ~= orderId) then
    error("doesn\'t clean old orderData")
    return false
  end
  if orderData:GetOrderType() == (FactoryEnum.eOrderType).dig then
    if self.Order4SendData == nil or (self.Order4SendData).curOrderNum < 1 then
      return false
    else
      -- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.Order4SendData).isOrderMax = false
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.Order4SendData).curOrderNum = (self.Order4SendData).curOrderNum - 1
      -- DECOMPILER ERROR at PC48: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.Order4SendData).usedTime = orderData:GetTimeCost() * (self.Order4SendData).curOrderNum
      return true
    end
  else
    if orderData:GetOrderType() == (FactoryEnum.eOrderType).product then
      if self.Order4SendData == nil or (self.Order4SendData).curOrderNum < 1 then
        return false
      end
      -- DECOMPILER ERROR at PC68: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.Order4SendData).isOrderMax = false
      local curNum = (self.Order4SendData).curOrderNum
      if self.productOrderAddDic ~= nil and (self.productOrderAddDic)[curNum - 1] ~= nil then
        self.Order4SendData = (table.deepCopy)((self.productOrderAddDic)[curNum - 1])
        return true
      else
        -- DECOMPILER ERROR at PC95: Confused about usage of register: R6 in 'UnsetPending'

        if curNum > 0 then
          (self.Order4SendData).curOrderNum = (self.Order4SendData).curOrderNum - 1
          -- DECOMPILER ERROR at PC102: Confused about usage of register: R6 in 'UnsetPending'

          ;
          (self.Order4SendData).usedTime = orderData:GetTimeCost() * (self.Order4SendData).curOrderNum
          local usedMat = {}
          for itemId,cost in pairs(orderCfg.raw_material) do
            usedMat[itemId] = cost * (self.Order4SendData).curOrderNum
          end
          -- DECOMPILER ERROR at PC116: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.Order4SendData).assistOrderDic = {}
          -- DECOMPILER ERROR at PC118: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.Order4SendData).usedMat = usedMat
          return true
        end
        do
          do return false end
        end
      end
    end
  end
end

FactoryController.TryAddMaxOrder = function(self, lindIndex, orderData, usedBagItem)
  -- function num : 0_33 , upvalues : _ENV, FactoryEnum, MAX_TIME_COST, FactoryCalcSendOrder
  local orderCfg = orderData:GetOrderCfg()
  local orderId = orderCfg.id
  if self.Order4SendData ~= nil and ((self.Order4SendData).lineIndex ~= lindIndex or (self.Order4SendData).curOrderId ~= orderId) then
    error("doesn\'t clean old orderData")
    return false
  end
  if orderData:GetOrderType() == (FactoryEnum.eOrderType).dig then
    local couldAddNum = MAX_TIME_COST // orderData:GetTimeCost()
    local warehouseCapacity = (PlayerDataCenter.playerBonus):GetWarehouseCapcity(orderCfg.outPutItemId)
    do
      if warehouseCapacity == 0 then
        local itemCfg = (ConfigData.item)[orderCfg.outPutItemId]
        if itemCfg == nil or itemCfg.holdlimit == nil then
          error("can\'t read itemCfg/itemCfg.holdlimit with id = " .. tostring(orderCfg.outPutItemId))
        else
          warehouseCapacity = itemCfg.holdlimit
        end
      end
      local curwarehouseNum = PlayerDataCenter:GetItemCount(orderCfg.outPutItemId, false)
      do
        do
          if warehouseCapacity ~= 0 then
            local num = (warehouseCapacity - curwarehouseNum) // orderCfg.outPutItemNum
            if num <= 0 then
              couldAddNum = 0
            else
              couldAddNum = (math.min)(couldAddNum, num)
            end
          end
          if couldAddNum > 0 then
            self.Order4SendData = (FactoryCalcSendOrder.CreateSendOrderDig)(orderId, couldAddNum, lindIndex, orderData)
            -- DECOMPILER ERROR at PC84: Confused about usage of register: R9 in 'UnsetPending'

            ;
            (self.Order4SendData).isOrderMax = true
            return true
          else
            return false
          end
          if orderData:GetOrderType() == (FactoryEnum.eOrderType).product then
            local couldAdd = true
            local reason = nil
            while couldAdd do
              couldAdd = self:TryAddOneOrder(lindIndex, orderData, usedBagItem)
            end
            if self.Order4SendData == nil then
              return false, reason
            end
            -- DECOMPILER ERROR at PC116: Confused about usage of register: R8 in 'UnsetPending'

            ;
            (self.Order4SendData).isOrderMax = true
            local result = (self.Order4SendData).curOrderNum > 0
            if result then
              return true
            end
            return false, reason
          end
          -- DECOMPILER ERROR: 3 unprocessed JMP targets
        end
      end
    end
  end
end

FactoryController.SendOrder = function(self, callback, isUseTime)
  -- function num : 0_34 , upvalues : _ENV
  if self.Order4SendData == nil or (self.Order4SendData).curOrderNum < 1 then
    return 
  end
  local Order4SendData = (table.deepCopy)(self.Order4SendData)
  self:ClearOrder()
  if isUseTime then
    (self.networkCtrl):CS_FACTORY_ConsumeTimeProduct(Order4SendData, function()
    -- function num : 0_34_0 , upvalues : callback
    callback()
  end
)
  else
    ;
    (self.networkCtrl):CS_FACTORY_WorkshopProduct(Order4SendData, function()
    -- function num : 0_34_1 , upvalues : callback
    callback()
  end
)
  end
end

FactoryController.CancleOrder = function(self, processingData)
  -- function num : 0_35
  local roomIndex, uid = processingData:GetIndexAndUid()
  ;
  (self.networkCtrl):CS_FACTORY_CancelOrder(roomIndex, uid, function()
    -- function num : 0_35_0 , upvalues : self, roomIndex, uid
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ProcessingOrders)[roomIndex])[uid] = nil
    self:OnUpdateProduceLine()
  end
)
end

FactoryController.QuickFinishOrder = function(self, processingData)
  -- function num : 0_36 , upvalues : _ENV, CommonRewardData
  local roomIndex, uid = processingData:GetIndexAndUid()
  ;
  (self.networkCtrl):CS_FACTORY_ImmediatelyComplete(roomIndex, uid, function()
    -- function num : 0_36_0 , upvalues : processingData, self, roomIndex, uid, _ENV, CommonRewardData
    local processingOrderData = processingData
    local rewardIds = {(processingOrderData:GetOutputItemCfg()).id}
    local rewardNums = {processingOrderData:GetOutputItemProduceNum()}
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ProcessingOrders)[roomIndex])[uid] = nil
    self:OnUpdateProduceLine()
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_36_0_0 , upvalues : CommonRewardData, rewardIds, rewardNums
      if window == nil then
        return 
      end
      local CRData = (CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)
      window:AddAndTryShowReward(CRData)
    end
)
  end
)
end

FactoryController.PickOrderReward = function(self, processingData)
  -- function num : 0_37 , upvalues : _ENV, CommonRewardData
  local roomIndex, uid = processingData:GetIndexAndUid()
  ;
  (self.networkCtrl):CS_FACTORY_Collect(roomIndex, uid, function()
    -- function num : 0_37_0 , upvalues : processingData, self, roomIndex, uid, _ENV, CommonRewardData
    local processingOrderData = processingData
    local rewardIds = {(processingOrderData:GetOutputItemCfg()).id}
    local rewardNums = {processingOrderData:GetOutputItemProduceNum()}
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ProcessingOrders)[roomIndex])[uid] = nil
    self:OnUpdateProduceLine()
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_37_0_0 , upvalues : CommonRewardData, rewardIds, rewardNums
      if window == nil then
        return 
      end
      local CRData = (CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)
      window:AddAndTryShowReward(CRData)
    end
)
  end
)
end

FactoryController.GetCurOrderAndMaxOrderNum = function(self)
  -- function num : 0_38 , upvalues : _ENV
  local curOrderNum = 0
  local maxOrderNum = 0
  local isHaveFinished = false
  for roomindex,isuNlock in pairs(self.unlockedRoom) do
    if isuNlock then
      maxOrderNum = maxOrderNum + 1
    end
  end
  for roomIndex,orderDic in pairs(self.ProcessingOrders) do
    for uid,processingData in pairs(orderDic) do
      curOrderNum = curOrderNum + 1
      if processingData:GetIsFinish() then
        isHaveFinished = true
      end
    end
  end
  return curOrderNum, maxOrderNum, isHaveFinished
end

FactoryController.FactoryQuickPickAllState = function(self)
  -- function num : 0_39 , upvalues : _ENV
  for roomIndex,orderDic in pairs(self.ProcessingOrders) do
    for uid,processingData in pairs(orderDic) do
      if processingData:GetIsFinish() then
        return true
      end
    end
  end
  return false
end

FactoryController.FactoryReqQuickPickAll = function(self)
  -- function num : 0_40 , upvalues : _ENV, CommonRewardData
  local pickAll = self:FactoryQuickPickAllState()
  if not pickAll then
    return 
  end
  local rewardIds = {}
  local rewardNums = {}
  for k,orderDic in pairs(self.ProcessingOrders) do
    for uid,processingData in pairs(orderDic) do
      if processingData:GetIsFinish() then
        (table.insert)(rewardIds, (processingData:GetOutputItemCfg()).id)
        ;
        (table.insert)(rewardNums, processingData:GetOutputItemProduceNum())
      end
    end
  end
  ;
  (self.networkCtrl):CS_FACTORY_OneKeyCollect(function()
    -- function num : 0_40_0 , upvalues : _ENV, CommonRewardData, rewardIds, rewardNums
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_40_0_0 , upvalues : CommonRewardData, rewardIds, rewardNums
      if window == nil then
        return 
      end
      local CRData = (CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)
      window:AddAndTryShowReward(CRData)
    end
)
  end
)
end

FactoryController.FactoryQuickTimeProductState = function(self)
  -- function num : 0_41 , upvalues : _ENV
  for roomIndex,value in pairs(self.unlockedRoom) do
    if value then
      local orderDic = (self.ProcessingOrders)[roomIndex]
      if orderDic == nil or (table.IsEmptyTable)(orderDic) then
        return true
      end
    end
  end
  return false
end

FactoryController.FactoryReqQuickTimeProduct = function(self)
  -- function num : 0_42 , upvalues : _ENV, FactoryEnum, cs_MessageCommon
  local enableQuick = self:FactoryQuickTimeProductState()
  if not enableQuick then
    return 
  end
  local usedTempBag = {}
  local sendOrders = {}
  local failReasonType = nil
  for roomIndex,value in pairs(self.unlockedRoom) do
    failReasonType = nil
    if value then
      local orderDic = (self.ProcessingOrders)[roomIndex]
      if orderDic ~= nil and not (table.IsEmptyTable)(orderDic) then
        failReasonType = (FactoryEnum.eCannotAddReason).curOrderIsBusy
      else
        local lastOrder = (self._lastOrders)[roomIndex]
        if lastOrder == nil then
          failReasonType = (FactoryEnum.eCannotAddReason).noLastOrder
        else
          local orderData = (self.OrderDataDic)[lastOrder.id]
          if orderData ~= nil then
            if orderData:GetOrderType() == (FactoryEnum.eOrderType).dig and lastOrder.isOrderMax and not self:TryAddMaxOrder(roomIndex, orderData) then
              failReasonType = (FactoryEnum.eCannotAddReason).warehouseFull
            else
              if lastOrder.num > 0 then
                local couldAdd = true
                local addNum = 0
                while couldAdd and addNum < lastOrder.num do
                  couldAdd = self:TryAddOneOrder(roomIndex, orderData)
                  addNum = addNum + 1
                end
                if self.Order4SendData == nil or (self.Order4SendData).curOrderNum <= 0 then
                  failReasonType = (FactoryEnum.eCannotAddReason).warehouseFull
                else
                  do
                    if orderData:GetOrderType() == (FactoryEnum.eOrderType).product then
                      if lastOrder.isOrderMax then
                        local result, reason = self:TryAddMaxOrder(roomIndex, orderData, usedTempBag)
                        if not result then
                          failReasonType = reason
                        else
                          do
                            if lastOrder.num > 0 then
                              local couldAdd = true
                              local addNum = 0
                              local reason = nil
                              while couldAdd and addNum < lastOrder.num do
                                couldAdd = self:TryAddOneOrder(roomIndex, orderData, usedTempBag)
                                addNum = addNum + 1
                              end
                              if self.Order4SendData == nil or (self.Order4SendData).curOrderNum <= 0 then
                                failReasonType = reason
                              else
                                do
                                  if self.Order4SendData ~= nil then
                                    do
                                      if orderData:GetOrderType() == (FactoryEnum.eOrderType).product then
                                        local useBagMat = (self.Order4SendData).useBagMat
                                        -- DECOMPILER ERROR at PC147: Overwrote pending register: R15 in 'AssignReg'

                                        for itemId,value in pairs(reason) do
                                          if not usedTempBag[itemId] then
                                            do
                                              usedTempBag[itemId] = (value < 0 or 0) + value
                                              usedTempBag[itemId] = PlayerDataCenter:GetItemCount(R21_PC162)
                                              -- DECOMPILER ERROR at PC164: LeaveBlock: unexpected jumping out IF_THEN_STMT

                                              -- DECOMPILER ERROR at PC164: LeaveBlock: unexpected jumping out IF_STMT

                                            end
                                          end
                                        end
                                      end
                                      ;
                                      (table.insert)(sendOrders, {workshopId = (self.Order4SendData).lineIndex, orderId = (self.Order4SendData).curOrderId, orderNum = (self.Order4SendData).curOrderNum, assistOrders = (self.Order4SendData).assistOrderDic, isMax = (self.Order4SendData).isOrderMax})
                                      do
                                        local roomName = (LanguageUtil.GetLocaleText)(((ConfigData.factory)[roomIndex]).name)
                                        ;
                                        (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(512, roomName), true)
                                        do
                                          local roomName = (LanguageUtil.GetLocaleText)(((ConfigData.factory)[roomIndex]).name)
                                          if failReasonType ~= nil then
                                            if failReasonType == (FactoryEnum.eCannotAddReason).matInsufficeient then
                                              (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Factory_MatInsufficient, roomName), true)
                                            else
                                              if failReasonType == (FactoryEnum.eCannotAddReason).warehouseFull then
                                                (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(513, roomName), true)
                                              else
                                                if failReasonType == (FactoryEnum.eCannotAddReason).noLastOrder then
                                                  (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(511, roomName), true)
                                                else
                                                  if failReasonType == (FactoryEnum.eCannotAddReason).curOrderIsBusy then
                                                    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Factory_AlreadyHaveOrder, roomName), true)
                                                  end
                                                end
                                              end
                                            end
                                          end
                                          self:ClearOrder()
                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out DO_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out DO_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_THEN_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out DO_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_THEN_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out DO_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_THEN_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_THEN_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out DO_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_THEN_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_THEN_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_THEN_STMT

                                          -- DECOMPILER ERROR at PC265: LeaveBlock: unexpected jumping out IF_STMT

                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if #sendOrders > 0 then
    (self.networkCtrl):CS_FACTORY_MultProduct(sendOrders)
    local factoryWindow = UIManager:GetWindow(UIWindowTypeID.Factory)
    if factoryWindow ~= nil then
      factoryWindow:CloseOrderNodesSafe()
    end
  end
end

local COS_45 = (math.cos)(45)
local CAMERA_TARGET_POS = (Vector3.New)(47.64, 42, 52.36)
FactoryController.StartMoveRoomToLeftMin = function(self, orderUI, roomIndex, isFromOtherRoom)
  -- function num : 0_43 , upvalues : CAMERA_TARGET_POS
  self.cameraTargetPos = CAMERA_TARGET_POS
end

FactoryController.OnMoveRoomToLeftMin = function(self, onMoveCallback, playrate, isFromOtherRoom)
  -- function num : 0_44 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  if isFromOtherRoom then
    (((self.roomBind).camera).transform).position = (Vector3.Lerp)(self.cameraPos, self.cameraTargetPos, playrate)
  else
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (((self.roomBind).camera).transform).position = (Vector3.Lerp)(self.cameraDefaultPos, self.cameraTargetPos, playrate)
  end
  if onMoveCallback ~= nil then
    onMoveCallback()
  end
end

FactoryController.ForceMoveToLeft = function(self, onMoveCallback)
  -- function num : 0_45
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  (((self.roomBind).camera).transform).position = self.cameraTargetPos
  if onMoveCallback ~= nil then
    onMoveCallback()
  end
end

FactoryController.MoveRoomToMid = function(self, onMoveCallback)
  -- function num : 0_46
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  (((self.roomBind).camera).transform).position = self.cameraDefaultPos
  if onMoveCallback ~= nil then
    onMoveCallback()
  end
end

FactoryController.IsCouldOpenQuickProduceUI = function(self, itemId, callback)
  -- function num : 0_47 , upvalues : _ENV
  if self.factoryMainUI ~= nil then
    return false
  end
  self:InitAllData(function()
    -- function num : 0_47_0 , upvalues : _ENV, self, itemId, callback
    local targetOrderData = nil
    for orderId,orderData in pairs(self.OrderDataDic) do
      if (orderData:GetOrderCfg()).outPutItemId == itemId then
        targetOrderData = orderData
        break
      end
    end
    do
      local isOk = nil
      if targetOrderData == nil then
        isOk = false
      else
        if targetOrderData:GetIsUnlock() then
          isOk = true
        else
          isOk = false
        end
      end
      if callback ~= nil then
        callback(isOk, targetOrderData)
      end
    end
  end
)
end

FactoryController.OpenQuickProduceUI = function(self, targetOrderData, closeCallback)
  -- function num : 0_48 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.FactoryQuickProduce, function(win)
    -- function num : 0_48_0 , upvalues : targetOrderData, closeCallback
    if win == nil then
      return 
    end
    win:OpenQuickProduce(targetOrderData, closeCallback)
  end
)
end

FactoryController.OnDelete = function(self)
  -- function num : 0_49 , upvalues : _ENV, base
  if self.lineTimerId ~= nil then
    TimerManager:StopTimer(self.lineTimerId)
    self.lineTimerId = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.m_OnUpdateARG)
  ;
  (base.OnDelete)(self)
end

return FactoryController

