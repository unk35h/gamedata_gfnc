-- params : ...
-- function num : 0 , upvalues : _ENV
local UserInfoData = class("UserInfoData")
local tinyGameEnum = require("Game.TinyGames.TinyGameEnum")
UserInfoData.ctor = function(self)
  -- function num : 0_0
  self.isSelfInfo = nil
  self.isFriendInfo = nil
  self.UID = nil
  self.name = nil
  self.alias = nil
  self.avatarId = nil
  self.avatarFrameId = nil
  self.level = nil
  self.exp = nil
  self.signature = nil
  self.sex = nil
  self.showGirlId = nil
  self.backgroudPlateId = nil
  self.supportHeroInfoList = {}
  self.createRelativeTm = nil
  self.title = nil
  self.hasHeroNum = nil
  self.epProgress = {}
  self.infinityLevelSum = nil
  self.buildingTotalLevel = nil
  self.defaultTowerProgress = nil
  self.__lastOffLineTm = nil
  self.__lastOnLineTm = nil
  self.__isNewFriend = false
  self.__tinyGameDic = {}
  self.__lastRefreshTs = nil
end

UserInfoData.CreateDataWithAvatarMsg = function(avatarMsg)
  -- function num : 0_1 , upvalues : UserInfoData, _ENV
  local data = (UserInfoData.New)()
  local biref = avatarMsg.biref
  local stc = avatarMsg.stc
  local dyc = avatarMsg.dyc
  data.UID = biref.uid
  data.name = biref.name
  data.avatarId = biref.avatar
  data.avatarFrameId = biref.avatarFrame
  data.level = biref.lv
  data.exp = biref.exp
  data.signature = biref.signature
  data.sex = biref.sex
  data.showGirlId = biref.showGirl
  data.backgroudPlateId = biref.backgroudPlate
  data.createRelativeTm = biref.bornTs
  data.__lastOffLineTm = biref.offlineTs or 0
  data.__lastOnLineTm = biref.loginTm or 0
  data.__lastRefreshTs = PlayerDataCenter.timestamp
  data.title = biref.title
  if stc ~= nil then
    data.hasHeroNum = stc.heroNum
    data:SetEpProgress(stc.maxStageId)
    data.infinityLevelSum = stc.endlessSum
    data.buildingTotalLevel = stc.oasisBuildingLevelSum
    local defaultTowerId = (PlayerDataCenter.dungeonTowerSData):GetDefaultTowerId()
    for _,towerRecord in pairs(stc.towers) do
      if defaultTowerId == towerRecord.towerId then
        data.defaultTowerProgress = towerRecord.currentCompletedId
        break
      end
    end
    do
      if stc.extra ~= nil then
        data.__birdData = (stc.extra).bird
        data.__game2048 = (stc.extra).game2048
        data.__damieData = (stc.extra).damie
        if (stc.extra).tinyGames ~= nil then
          for _,tinyGame in ipairs((stc.extra).tinyGames) do
            -- DECOMPILER ERROR at PC98: Confused about usage of register: R11 in 'UnsetPending'

            if (data.__tinyGameDic)[tinyGame.gameCat] == nil then
              (data.__tinyGameDic)[tinyGame.gameCat] = {}
            end
            -- DECOMPILER ERROR at PC103: Confused about usage of register: R11 in 'UnsetPending'

            ;
            ((data.__tinyGameDic)[tinyGame.gameCat])[tinyGame.gameId] = tinyGame
          end
        end
      end
      do
        for i = 1, 3 do
          -- DECOMPILER ERROR at PC117: Confused about usage of register: R9 in 'UnsetPending'

          if dyc == nil or (dyc.assistsBrief)[i] == nil then
            (data.supportHeroInfoList)[i] = false
          else
            -- DECOMPILER ERROR at PC127: Confused about usage of register: R9 in 'UnsetPending'

            ;
            (data.supportHeroInfoList)[i] = {assistsBrief = (dyc.assistsBrief)[i], assistsRandom = (dyc.assistsRandom)[i]}
          end
        end
        return data
      end
    end
  end
end

UserInfoData.CreateSelfData = function(userBrief)
  -- function num : 0_2 , upvalues : UserInfoData
  local avatarMsg = userBrief.avatar
  local data = (UserInfoData.CreateDataWithAvatarMsg)(avatarMsg)
  data.isSelfInfo = true
  data.isFriendInfo = false
  if userBrief.userBase ~= nil then
    data:SetSupportPointData((userBrief.userBase).astPoint)
  end
  return data
end

UserInfoData.CreateFriendDataWithAvatarMsg = function(avatarMsg)
  -- function num : 0_3 , upvalues : UserInfoData
  local data = (UserInfoData.CreateDataWithAvatarMsg)(avatarMsg)
  data.isSelfInfo = false
  data.isFriendInfo = true
  return data
end

UserInfoData.CreateStrangerDataWithAvatarMsg = function(avatarMsg)
  -- function num : 0_4 , upvalues : UserInfoData
  local data = (UserInfoData.CreateDataWithAvatarMsg)(avatarMsg)
  data.isSelfInfo = false
  data.isFriendInfo = false
  return data
end

UserInfoData.UpdateUserDoc = function(self, UserData)
  -- function num : 0_5
  self.avatarId = UserData.avatar
  self.avatarFrameId = UserData.avatarFrame
  self.signature = UserData.signature
  self.sex = UserData.sex
  self.backgroudPlateId = UserData.backgroudPlate
end

UserInfoData.UpdateByAvatarMsg = function(self, avatarMsg)
  -- function num : 0_6 , upvalues : _ENV
  local biref = avatarMsg.biref
  local stc = avatarMsg.stc
  local dyc = avatarMsg.dyc
  self.UID = biref.uid
  self.name = biref.name
  self.avatarId = biref.avatar
  self.avatarFrameId = biref.avatarFrame
  self.level = biref.lv
  self.exp = biref.exp
  self.signature = biref.signature
  self.sex = biref.sex
  self.backgroudPlateId = biref.backgroudPlate
  self.createRelativeTm = biref.bornTs
  self.__lastRefreshTs = PlayerDataCenter.timestamp
  self.__lastOffLineTm = biref.offlineTs or 0
  self.__lastOnLineTm = biref.loginTm or 0
  self.title = biref.title
  if stc ~= nil then
    self.hasHeroNum = stc.heroNum
    self:SetEpProgress(stc.maxStageId)
    self.infinityLevelSum = stc.endlessSum
    self.buildingTotalLevel = stc.oasisBuildingLevelSum
    if stc.extra ~= nil then
      self.__birdData = (stc.extra).bird
      self.__game2048 = (stc.extra).game2048
      self.__damieData = (stc.extra).damie
      if (stc.extra).tinyGames ~= nil then
        for _,tinyGame in ipairs((stc.extra).tinyGames) do
          -- DECOMPILER ERROR at PC78: Confused about usage of register: R10 in 'UnsetPending'

          if (self.__tinyGameDic)[tinyGame.gameCat] == nil then
            (self.__tinyGameDic)[tinyGame.gameCat] = {}
          end
          -- DECOMPILER ERROR at PC83: Confused about usage of register: R10 in 'UnsetPending'

          ;
          ((self.__tinyGameDic)[tinyGame.gameCat])[tinyGame.gameId] = tinyGame
        end
      end
    end
  end
  do
    for i = 1, 3 do
      -- DECOMPILER ERROR at PC97: Confused about usage of register: R9 in 'UnsetPending'

      if dyc == nil or (dyc.assistsBrief)[i] == nil then
        (self.supportHeroInfoList)[i] = false
      else
        -- DECOMPILER ERROR at PC107: Confused about usage of register: R9 in 'UnsetPending'

        ;
        (self.supportHeroInfoList)[i] = {assistsBrief = (dyc.assistsBrief)[i], assistsRandom = (dyc.assistsRandom)[i]}
      end
    end
  end
end

UserInfoData.GetIsSelfUserInfo = function(self)
  -- function num : 0_7
  return self.isSelfInfo
end

UserInfoData.GetUserName = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.isSelfInfo then
    return PlayerDataCenter.playerName
  end
  if not self.name then
    return tostring(self.UID)
  end
end

UserInfoData.GetUserUID = function(self)
  -- function num : 0_9
  return self.UID
end

UserInfoData.GetAvatarId = function(self)
  -- function num : 0_10
  return self.avatarId
end

UserInfoData.GetAvatarFrameId = function(self)
  -- function num : 0_11
  return self.avatarFrameId
end

UserInfoData.GetAvatarTitleId = function(self)
  -- function num : 0_12
  return self.title
end

UserInfoData.GetAvatarSignature = function(self)
  -- function num : 0_13
  return self.signature
end

UserInfoData.GetSex = function(self)
  -- function num : 0_14
  return self.sex
end

UserInfoData.SetSex = function(self, isGril)
  -- function num : 0_15
  self.sex = isGril
end

UserInfoData.GetBackgroudPlateId = function(self)
  -- function num : 0_16
  return self.backgroudPlateId
end

UserInfoData.GetShowGirlId = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local ret = self.showGirlId
  if ret == nil or ret == 0 then
    ret = (ConfigData.game_config).firtBoardHeroID
  end
  return ret
end

UserInfoData.GetUserLevel = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if self.isSelfInfo then
    return (PlayerDataCenter.playerLevel).level
  end
  return self.level or 1
end

UserInfoData.GetCreateTime = function(self)
  -- function num : 0_19
  return self.createRelativeTm
end

UserInfoData.GetHasHeroNum = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if self.isSelfInfo then
    return PlayerDataCenter.heroCount
  end
  return self.hasHeroNum or 0
end

UserInfoData.SetEpProgress = function(self, maxStageId)
  -- function num : 0_21 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.epProgress).sectorId = 0
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.epProgress).stageIndex = 0
  for _,sectorId in ipairs((ConfigData.sector).id_sort_list) do
    for stageIndex,stageId in ipairs(((ConfigData.sector_stage).sectorIdList)[sectorId]) do
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R12 in 'UnsetPending'

      if stageId == maxStageId then
        (self.epProgress).sectorId = sectorId
        -- DECOMPILER ERROR at PC22: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (self.epProgress).stageIndex = stageIndex
        return 
      end
    end
  end
end

UserInfoData.SetTitle = function(self, preId, postId, bgId)
  -- function num : 0_22
  if preId == nil then
    self.title = nil
    return 
  end
  if not self.title then
    self.title = {}
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.title).titlePrefix = preId
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.title).titlePostfix = postId
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.title).titleBackGround = bgId
  end
end

UserInfoData.GetEpProgress = function(self)
  -- function num : 0_23 , upvalues : _ENV
  do
    if self.isSelfInfo then
      local sectorId, stageIndex = (PlayerDataCenter.sectorStage):GetEpStageCfg4UserInfo()
      return {sectorId = sectorId, stageIndex = stageIndex}
    end
    if not self.epProgress then
      return {sectorId = 0, stageIndex = 0}
    end
  end
end

UserInfoData.GetInfinityLevelSum = function(self)
  -- function num : 0_24 , upvalues : _ENV
  if self.isSelfInfo then
    return (PlayerDataCenter.infinityData):GetCompletedInfinityLevelNum() * 10
  end
  return self.infinityLevelSum or 0
end

UserInfoData.GetBuildingTotalLevel = function(self)
  -- function num : 0_25 , upvalues : _ENV
  do
    if self.isSelfInfo then
      local totalLevel = 0
      for key,value in pairs((PlayerDataCenter.AllBuildingData).oasisBuilt) do
        totalLevel = totalLevel + value.level
      end
      return totalLevel
    end
    return self.buildingTotalLevel or 0
  end
end

UserInfoData.GetDefaultTowerProgress = function(self)
  -- function num : 0_26 , upvalues : _ENV
  if self.isSelfInfo then
    return (PlayerDataCenter.dungeonTowerSData):GetDefaultTowerCompleteLevel()
  end
  return self.defaultTowerProgress or 0
end

UserInfoData.GetIsNeedFreshData = function(self)
  -- function num : 0_27 , upvalues : _ENV
  if self.__lastRefreshTs == nil then
    return true
  end
  if (ConfigData.game_config).userInfoRefreshTime < PlayerDataCenter.timestamp - self.__lastRefreshTs then
    return true
  end
  return false
end

UserInfoData.GetSupportHoreInfoList = function(self)
  -- function num : 0_28
  return self.supportHeroInfoList
end

UserInfoData.GetSupportHoreIdDic = function(self)
  -- function num : 0_29 , upvalues : _ENV
  local dic = {}
  for index,value in ipairs(self.supportHeroInfoList) do
    if value ~= false then
      dic[(value.assistsBrief).id] = true
    end
  end
  return dic
end

UserInfoData.GetSupportHeroDataById = function(self, briefId)
  -- function num : 0_30 , upvalues : _ENV
  for key,value in pairs(self.supportHeroInfoList) do
    if value ~= false and (value.assistsBrief).id == briefId then
      return value
    end
  end
end

UserInfoData.SetSelfSupportHoreId = function(self, index, heroId)
  -- function num : 0_31
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  if heroId == nil then
    (self.supportHeroInfoList)[index] = false
  else
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

    if (self.supportHeroInfoList)[index] == false then
      (self.supportHeroInfoList)[index] = {}
    end
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R3 in 'UnsetPending'

    if ((self.supportHeroInfoList)[index]).assistsBrief == nil then
      ((self.supportHeroInfoList)[index]).assistsBrief = {}
    end
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.supportHeroInfoList)[index]).assistsBrief).id = heroId
  end
end

UserInfoData.GetLastOffLinTem = function(self)
  -- function num : 0_32
  return self.__lastOffLineTm
end

UserInfoData.GetOnlineState = function(self)
  -- function num : 0_33 , upvalues : _ENV
  if self.__lastOffLineTm < self.__lastOnLineTm then
    return 0
  end
  return (math.max)(self.__lastOnLineTm, self.__lastOffLineTm)
end

UserInfoData.SetSupportPointData = function(self, astPoint)
  -- function num : 0_34
  if not self.isSelfInfo then
    return 
  end
  self.__supportPoint = astPoint
end

UserInfoData.GetCurSupportPoint = function(self)
  -- function num : 0_35 , upvalues : _ENV
  if not self.isSelfInfo then
    return 
  end
  local consts = (ConfigData.game_config).supportPointConstants
  local allLevel, allStar = 0, 0
  for index,value in pairs(self.supportHeroInfoList) do
    if value ~= nil and value ~= false then
      local heroData = (PlayerDataCenter.heroDic)[(value.assistsBrief).id]
      if heroData ~= nil then
        allLevel = allLevel + heroData.level
        allStar = allStar + heroData.star
      end
    end
  end
  local isUnSetAllHeroFlag = 1
  if allLevel == 0 or allStar == 0 then
    isUnSetAllHeroFlag = 0
  end
  if self.__supportPoint == nil then
    return 0
  end
  local num = (self.__supportPoint).num + (math.floor)(PlayerDataCenter.timestamp - (self.__supportPoint).lastCalcTm - 1) * isUnSetAllHeroFlag * (allLevel + consts[1]) * (allStar + consts[2]) * consts[3] / consts[4] + (self.__supportPoint).cnt * consts[5]
  return (math.floor)(num)
end

UserInfoData.SetAlias = function(self, alias)
  -- function num : 0_36
  self.alias = alias
end

UserInfoData.GetIsHaveAlias = function(self)
  -- function num : 0_37 , upvalues : _ENV
  return not (string.IsNullOrEmpty)(self.alias)
end

UserInfoData.GetAlias = function(self)
  -- function num : 0_38
  if self:GetIsHaveAlias() then
    return self.alias
  end
  return self:GetUserName()
end

UserInfoData.GetIsFriend = function(self)
  -- function num : 0_39
  return self.isFriendInfo
end

UserInfoData.SetApplyTimestamp = function(self, ts)
  -- function num : 0_40
  if self.isFriendInfo or self.isSelfInfo then
    return 
  end
  self.__applyTimestamp = ts
end

UserInfoData.GetIsApplicationTimeOut = function(self)
  -- function num : 0_41 , upvalues : _ENV
  if self.isFriendInfo or self.isSelfInfo then
    warn("this userInof is not about a friend application")
    return 
  end
  do return self.__applyTimestamp or 0 < PlayerDataCenter.timestamp end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UserInfoData.GetIsNewFriend = function(self)
  -- function num : 0_42
  if not self.isFriendInfo then
    return 
  end
  return self.__isNewFriend
end

UserInfoData.GetFriendBirdData = function(self)
  -- function num : 0_43
  return self.__birdData
end

UserInfoData.GetFriend2048Data = function(self)
  -- function num : 0_44
  return self.__game2048
end

UserInfoData.GetFriendDamieData = function(self)
  -- function num : 0_45
  return self.__damieData
end

UserInfoData.GetFriendPenguinsData = function(self, birdId)
  -- function num : 0_46 , upvalues : tinyGameEnum
  if (self.__tinyGameDic)[(tinyGameEnum.eType).penguins] == nil then
    return nil
  end
  return ((self.__tinyGameDic)[(tinyGameEnum.eType).penguins])[birdId]
end

UserInfoData.GetTinyGameData = function(self, gameCat, gameId)
  -- function num : 0_47
  if (self.__tinyGameDic)[gameCat] == nil then
    return nil
  end
  return ((self.__tinyGameDic)[gameCat])[gameId]
end

return UserInfoData

