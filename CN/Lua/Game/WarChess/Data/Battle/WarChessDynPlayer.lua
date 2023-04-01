-- params : ...
-- function num : 0 , upvalues : _ENV
local DynPlayer = require("Game.Exploration.Data.DynPlayer")
local WarChessDynPlayer = class("WarChessDynPlayer", DynPlayer)
local ChipData = require("Game.PlayerData.Item.ChipData")
local DeployTeamUtil = require("Game.Exploration.Util.DeployTeamUtil")
local CS_BattleManager = (CS.BattleManager).Instance
WarChessDynPlayer.ctor = function(self)
  -- function num : 0_0
end

WarChessDynPlayer.CreateDungeonPlayer = function(formationRuleCfg)
  -- function num : 0_1 , upvalues : WarChessDynPlayer
  local player = (WarChessDynPlayer.New)()
  player:SetPlayerFormationRuleCfg(formationRuleCfg)
  return player
end

WarChessDynPlayer.WCRefillTeamDynHeros = function(self, teamData, dynHeroDic)
  -- function num : 0_2 , upvalues : _ENV
  local oldHeroDic = self.heroDic
  local diffHeroList = {}
  self.heroList = {}
  self.heroDic = {}
  for index,heroId in pairs(teamData:GetWCTeamOrderDic()) do
    local dynHero = dynHeroDic[heroId]
    ;
    (table.insert)(self.heroList, dynHero)
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.heroDic)[heroId] = dynHero
    if oldHeroDic == nil or oldHeroDic[heroId] == nil then
      (table.insert)(diffHeroList, dynHero)
    end
  end
  self:InitMirrorHeroTeam()
  return function()
    -- function num : 0_2_0 , upvalues : diffHeroList, self
    if #diffHeroList > 0 then
      self:ExecuteAllChip2NewHeroList(diffHeroList)
    end
  end

end

WarChessDynPlayer.UpdateDynHerosDeployPos = function(self)
  -- function num : 0_3 , upvalues : _ENV, DeployTeamUtil
  local battleRoleCount = self:GetEnterFiledNum()
  local benchX = (ConfigData.buildinConfig).BenchX
  for k,heroData in pairs(self.heroList) do
    heroData:InitDynHeroBenchByFmtIdx(battleRoleCount)
  end
  local size_row, size_col, deploy_rows = WarChessManager:GetEpSceneBattleFieldSize()
  ;
  (DeployTeamUtil.DeployHeroTeam)(self.heroList, size_row, size_col, deploy_rows)
end

WarChessDynPlayer.UpdatePlayerDyc = function(self, dyc)
  -- function num : 0_4 , upvalues : CS_BattleManager
  self.playerSkillMp = dyc.mp
  self.playerUltSkillMp = dyc.hmp
  self.playerTDMp = dyc.tdmp
  CS_BattleManager:UpdatePlayerData()
end

WarChessDynPlayer.GetMoneyIconId = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local cfg = (ConfigData.item)[ConstGlobalItem.WCMoney]
  return cfg ~= nil and cfg.icon or nil
end

WarChessDynPlayer.RefreshCacheFightPower = function(self)
  -- function num : 0_6
  if not self.__isHeroInitReady then
    return 
  end
  local curPower = self:GetTotalFightingPower()
  if self.__cacheFightPower == curPower then
    return 
  end
  self.__cacheFightPower = curPower
end

WarChessDynPlayer.__UpdateAllChip = function(self, chipUpdate, chipDelete, tmpChipUpdate, tmpChipDelete, tmpBuffUpdate, tmpBuffDelete)
  -- function num : 0_7 , upvalues : _ENV, ChipData, CS_BattleManager
  local chipShowDel = {}
  local chipShowAdd = {}
  if chipDelete ~= nil then
    for chipId,v in pairs(chipDelete) do
      local chipData = (self.chipDic)[chipId]
      if chipData ~= nil then
        self:__RollBackChipInternal(chipData)
      end
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (self.chipDic)[chipId] = nil
      chipShowDel[chipId] = true
    end
  end
  do
    if tmpChipDelete ~= nil then
      for chipId,num in pairs(tmpChipDelete) do
        local buffChip = (self.epBuffChipDic)[chipId]
        if buffChip ~= nil then
          self:__RollBackBuffChip(buffChip)
        end
        -- DECOMPILER ERROR at PC34: Confused about usage of register: R15 in 'UnsetPending'

        ;
        (self.epBuffChipDic)[chipId] = nil
      end
    end
    do
      if tmpBuffDelete ~= nil then
        for chipId,num in pairs(tmpBuffDelete) do
          local chipData = (self.tmpBuffChipDic)[chipId]
          if chipData ~= nil then
            self:__RollBackChipInternal(chipData)
          end
          -- DECOMPILER ERROR at PC51: Confused about usage of register: R15 in 'UnsetPending'

          ;
          (self.tmpBuffChipDic)[chipId] = nil
          chipShowDel[chipId] = true
        end
      end
      do
        if chipUpdate ~= nil then
          for chipId,num in pairs(chipUpdate) do
            local chipData = (self.chipDic)[chipId]
            if chipData ~= nil then
              self:__RollBackChipInternal(chipData)
              chipData:SetCount(num)
              self:__ExecuteChipInternal(chipData)
            else
              local chipData = (ChipData.New)(chipId, num)
              -- DECOMPILER ERROR at PC80: Confused about usage of register: R16 in 'UnsetPending'

              ;
              (self.chipDic)[chipId] = chipData
              self:__ExecuteChipInternal(chipData)
              chipShowAdd[chipId] = true
            end
          end
        end
        do
          if tmpChipUpdate ~= nil then
            for chipId,num in pairs(tmpChipUpdate) do
              local buffChip = (self.epBuffChipDic)[chipId]
              if buffChip ~= nil then
                self:__RollBackBuffChip(buffChip)
                buffChip:SetCount(num)
                self:__ExecuteBuffChip(buffChip)
              else
                local buffChip = (ChipData.New)(chipId, num)
                -- DECOMPILER ERROR at PC112: Confused about usage of register: R16 in 'UnsetPending'

                ;
                (self.epBuffChipDic)[chipId] = buffChip
                self:__ExecuteBuffChip(buffChip)
              end
            end
          end
          do
            if tmpBuffUpdate ~= nil then
              for chipId,num in pairs(tmpBuffUpdate) do
                local chipData = (self.tmpBuffChipDic)[chipId]
                if chipData ~= nil then
                  self:__RollBackChipInternal(chipData)
                  chipData:SetCount(num)
                  self:__ExecuteChipInternal(chipData)
                else
                  local chipData = (ChipData.New)(chipId, num)
                  chipData:SetIsShowTemp(true)
                  -- DECOMPILER ERROR at PC146: Confused about usage of register: R16 in 'UnsetPending'

                  ;
                  (self.tmpBuffChipDic)[chipId] = chipData
                  self:__ExecuteChipInternal(chipData)
                  chipShowAdd[chipId] = true
                end
              end
            end
            do
              local chipList = {}
              for chipId,chipData in pairs(self.chipDic) do
                (table.insert)(chipList, chipData)
              end
              for k,chipData in pairs(self.tmpBuffChipDic) do
                (table.insert)(chipList, chipData)
              end
              self.chipList = chipList
              self:__SortChipList()
              self:UpdateChipLimitNum()
              self:__UpdateChipSuitDiff(chipShowDel, chipShowAdd)
              CS_BattleManager:UpdateBattleRoleData()
              self:RefreshCacheFightPower()
              MsgCenter:Broadcast(eMsgEventId.WC_ChipChange, self.chipList, self)
            end
          end
        end
      end
    end
  end
end

WarChessDynPlayer.ClearAlg = function(self)
  -- function num : 0_8
  self.epBuffChipDic = {}
end

WarChessDynPlayer.UpDateWCDynPlayerChipLimit = function(self, limit)
  -- function num : 0_9 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.chipLimitInfo).limit = limit
  MsgCenter:Broadcast(eMsgEventId.OnChipLimitChange)
end

WarChessDynPlayer.GetChipUpgradeLimitPrice = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local shopId = WarChessManager:GetWCLevelShopId()
  local shopRareCfg = (ConfigData.warchess_shop_rare)[shopId]
  local costItemId = shopRareCfg.item2
  local costItemNum = 0
  local levelCfg = shopRareCfg.upgrade_level
  local scaleValuesCfg = shopRareCfg.upgrade_scale
  local levelCount = #levelCfg
  local curCapacity = self:GetChipDiscardLimit()
  for i = 1, levelCount do
    -- DECOMPILER ERROR at PC22: Unhandled construct in 'MakeBoolean' P1

    if i <= 1 and curCapacity <= levelCfg[1] then
      costItemNum = scaleValuesCfg[1]
    end
    -- DECOMPILER ERROR at PC30: Unhandled construct in 'MakeBoolean' P1

    if levelCount <= i and levelCfg[i - 1] <= curCapacity then
      costItemNum = scaleValuesCfg[i]
    end
    if levelCfg[i - 1] <= curCapacity and curCapacity < levelCfg[i] then
      costItemNum = scaleValuesCfg[i]
    end
  end
  return costItemId, costItemNum
end

WarChessDynPlayer.ApplyPlayerDungeonRoleHpPer = function(self, csPlayerDungeonRoleHpPerDic)
  -- function num : 0_11 , upvalues : _ENV
  if csPlayerDungeonRoleHpPerDic == nil or csPlayerDungeonRoleHpPerDic.Count <= 0 then
    return 
  end
  self.dungeonRoleHpPerDic = {}
  for k,v in pairs(csPlayerDungeonRoleHpPerDic) do
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R7 in 'UnsetPending'

    (self.dungeonRoleHpPerDic)[k] = v
  end
end

return WarChessDynPlayer

