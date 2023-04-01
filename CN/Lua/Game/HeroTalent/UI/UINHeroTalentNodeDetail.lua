-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroTalentDetailNode = class("UINHeroTalentDetailNode", UIBaseNode)
local base = UIBaseNode
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
local UINHeroTalentNodeDetailEffect = require("Game.HeroTalent.UI.UINHeroTalentNodeDetailEffect")
local UINHeroTalentNodeDetailCost = require("Game.HeroTalent.UI.UINHeroTalentNodeDetailCost")
local UINHeroTalentNodeDetailCondition = require("Game.HeroTalent.UI.UINHeroTalentNodeDetailCondition")
local DynBattleSkill = require("Game.Exploration.Data.DynBattleSkill")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINHeroTalentBranch = require("Game.HeroTalent.UI.UINHeroTalentBranch")
local attrIdOffset = (ConfigData.buildinConfig).AttrIdOffset
UINHeroTalentDetailNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroTalentNodeDetailEffect, UINHeroTalentNodeDetailCost, UINHeroTalentNodeDetailCondition, UINBaseItemWithCount, UINHeroTalentBranch
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Upgrade, self, self.OnClickTalentLvUp)
  self._effectPool = (UIItemPool.New)(UINHeroTalentNodeDetailEffect, (self.ui).attItem)
  ;
  ((self.ui).attItem):SetActive(false)
  self._costPool = (UIItemPool.New)(UINHeroTalentNodeDetailCost, (self.ui).consumeItem)
  ;
  ((self.ui).consumeItem):SetActive(false)
  self._condition = (UIItemPool.New)(UINHeroTalentNodeDetailCondition, (self.ui).conditionItem)
  ;
  ((self.ui).conditionItem):SetActive(false)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
  self._branchPool = (UIItemPool.New)(UINHeroTalentBranch, (self.ui).tog_Item)
  ;
  ((self.ui).tog_Item):SetActive(false)
  self.__OnClickBranchSelectListenCallback = BindCallback(self, self.__OnClickBranchSelectListen)
  self.defaultBtnColor = ((self.ui).img_Upgrade).color
end

UINHeroTalentDetailNode.BindLvUpClickCallback = function(self, lvUpClickFunc)
  -- function num : 0_1
  self._lvUpClickFunc = lvUpClickFunc
end

UINHeroTalentDetailNode.BindBranchCallback = function(self, branchClickFunc)
  -- function num : 0_2
  self._branchClickFunc = branchClickFunc
end

UINHeroTalentDetailNode.UpdateHeroTalentDetailNode = function(self, talentNode)
  -- function num : 0_3 , upvalues : _ENV
  self._talentNode = talentNode
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TalentName).text = (LanguageUtil.GetLocaleText)(((self._talentNode):GetHeroTalentNodeCfg()).name)
  self:RefreshHeroTalentDetailUI()
end

UINHeroTalentDetailNode.RefreshHeroTalentDetailUI = function(self)
  -- function num : 0_4
  (self._effectPool):HideAll()
  ;
  (self._costPool):HideAll()
  ;
  (self._condition):HideAll()
  ;
  (self._rewardPool):HideAll()
  ;
  (self._branchPool):HideAll()
  self:__RefreshTalentDescDes()
  self:__RefreshAttriDes()
  ;
  ((self.ui).isMax):SetActive(false)
  ;
  ((self.ui).lvUp):SetActive(false)
  ;
  ((self.ui).condition):SetActive(false)
  ;
  ((self.ui).togGroup):SetActive(false)
  self:__RefreshBranch()
  if (self._talentNode):IsHeroTalentNodeMaxLevel() then
    ((self.ui).isMax):SetActive(true)
  else
    if not (self._talentNode):IsHeroTalentNodeUnlock() then
      self:__RefreshLockState()
    else
      self:__RefreshCostState()
    end
  end
end

UINHeroTalentDetailNode.__RefreshTalentDescDes = function(self)
  -- function num : 0_5 , upvalues : _ENV, DynBattleSkill, CommonLogicUtil
  (((self.ui).tex_TalentDesc).gameObject):SetActive(false)
  local effectCfg = (self._talentNode):GetHeroTalentNodeCurLevelEffect()
  if effectCfg == nil then
    effectCfg = (self._talentNode):GetHeroTalentNodeNexLevelEffect()
  end
  local talentDesc = (LanguageUtil.GetLocaleText)(effectCfg.text_context) .. "\n"
  for i,skillId in ipairs(effectCfg.skill_list) do
    local battleSkill = (DynBattleSkill.New)((effectCfg.skill_list)[skillId], 1)
    talentDesc = talentDesc .. tostring(battleSkill:GetLevelDescribe(1, false, false)) .. "\n"
  end
  if effectCfg.energy_return > 0 then
    talentDesc = talentDesc .. (string.format)(ConfigData:GetTipContent(5070), tostring(FormatNum(effectCfg.energy_return / 10)) .. "%")
  end
  for areaId,spceAdd in ipairs(effectCfg.algorithm_space) do
    if spceAdd > 0 then
      talentDesc = talentDesc .. "\n" .. (string.format)(ConfigData:GetTipContent(5079), (LanguageUtil.GetLocaleText)(((ConfigData.ath_area)[areaId]).name2), tostring(spceAdd))
    end
  end
  for i,logicId in ipairs(effectCfg.logic) do
    local longDes, _, _ = (CommonLogicUtil.GetDesString)(logicId, (effectCfg.para1)[i], (effectCfg.para2)[i], (effectCfg.para2)[i])
    talentDesc = talentDesc .. "\n" .. longDes
  end
  if not (string.IsNullOrEmpty)(talentDesc) then
    (((self.ui).tex_TalentDesc).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC123: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_TalentDesc).text = talentDesc
  end
end

UINHeroTalentDetailNode.__RefreshAttriDes = function(self)
  -- function num : 0_6 , upvalues : _ENV, attrIdOffset, CommonLogicUtil
  local attributeUpDic = (self._talentNode):GetTalentNextLvAttriDescrib()
  local curEffect = (self._talentNode):GetHeroTalentNodeCurLevelEffect()
  local nextEffect = (self._talentNode):GetHeroTalentNodeNexLevelEffect()
  if attributeUpDic ~= nil then
    for attriId,info in pairs(attributeUpDic) do
      local item = ((self._effectPool):GetOne())
      local showColor = nil
      if attrIdOffset < attriId and attriId < attrIdOffset * 2 then
        showColor = (self.ui).baseAttrColor
      end
      item:RefreshDetailEffectByAttriId(attriId, info.cur, info.next, true, showColor)
    end
  end
  do
    local curEnergyReturn = curEffect ~= nil and curEffect.energy_return or 0
    local nextEnergyReturn = nextEffect ~= nil and nextEffect.energy_return or nil
    if nextEnergyReturn or curEnergyReturn > 0 or 0 > 0 then
      local curStr = tostring(FormatNum(curEnergyReturn / 10)) .. "%"
      local nextStr = nextEnergyReturn ~= nil and tostring(FormatNum(nextEnergyReturn / 10)) .. "%" or nil
      local item = (self._effectPool):GetOne()
      item:RefreshDetailEffect(ConfigData:GetTipContent(5078), curStr, nextStr, (ConfigData.game_config).heroTalentEnergyRetuenIcon)
    end
    do
      for areaId,cfg in ipairs(ConfigData.ath_area) do
        local curAdd = curEffect ~= nil and (curEffect.algorithm_space)[areaId] or nil
        local nextAdd = nextEffect ~= nil and (nextEffect.algorithm_space)[areaId] or nil
        if curAdd or 0 ~= nextAdd or 0 then
          local item = (self._effectPool):GetOne()
          curAdd = tostring(curAdd or 0)
          nextAdd = nextAdd ~= nil and tostring(nextAdd) or nil
          item:RefreshDetailEffect((string.format)(ConfigData:GetTipContent(5080), (LanguageUtil.GetLocaleText)(cfg.name2)), curAdd, nextAdd)
        end
      end
      local logicList, attrIdList = nil, nil
      if curEffect == nil then
        logicList = CommonLogicUtil:GetDesAboutLvDiff(nil, nil, nil, nil, nextEffect.logic, nextEffect.para1, nextEffect.para2, nextEffect.para3)
        attrIdList = nextEffect.para1
      else
        if nextEffect == nil then
          logicList = CommonLogicUtil:GetDesAboutLvDiff(curEffect.logic, curEffect.para1, curEffect.para2, curEffect.para3, nil, nil, nil, nil)
          attrIdList = curEffect.para1
        else
          logicList = CommonLogicUtil:GetDesAboutLvDiff(curEffect.logic, curEffect.para1, curEffect.para2, curEffect.para3, nextEffect.logic, nextEffect.para1, nextEffect.para2, nextEffect.para3)
          attrIdList = curEffect.para1
        end
      end
      if logicList ~= nil and #logicList > 0 then
        for i,desTable in ipairs(logicList) do
          local item = (self._effectPool):GetOne()
          item:RefreshDetailEffect(desTable.currentInfo, desTable.curValue, desTable.nextInfoValue, ((ConfigData.game_config).heroTalentTeamAttrIconDic)[attrIdList[i]])
        end
      end
      do
        ;
        ((self.ui).attNode):SetActive(#(self._effectPool).listItem > 0)
        -- DECOMPILER ERROR: 1 unprocessed JMP targets
      end
    end
  end
end

UINHeroTalentDetailNode.__RefreshBranch = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local flag, selectId = (self._talentNode):GetHeroTalentNodeBranchId()
  local branchList = (self._talentNode):GetTalentNextLvBranchAttriDescrib()
  if branchList == nil then
    return 
  end
  ;
  ((self.ui).togGroup):SetActive(true)
  for i,attrDiffDic in ipairs(branchList) do
    for attrid,diffval in pairs(attrDiffDic) do
      local item = (self._branchPool):GetOne()
      item:InitHeroTalentBranch(i, attrid, diffval.cur, diffval.next, self.__OnClickBranchSelectListenCallback)
      item:SetTalentBranckSelectState(selectId)
      item:SetTalentBranckActiveState(flag)
      do break end
    end
  end
end

UINHeroTalentDetailNode.__RefreshLockState = function(self)
  -- function num : 0_8 , upvalues : _ENV
  ((self.ui).condition):SetActive(true)
  local list = (self._talentNode):GetHeroTalentNodeLockDesList()
  for _,info in ipairs(list) do
    local item = (self._condition):GetOne()
    item:RefreshDetailCondition(info.lockReason, info.unlock)
  end
end

UINHeroTalentDetailNode.__RefreshCostState = function(self)
  -- function num : 0_9 , upvalues : _ENV
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

  if not (self._talentNode):IsHeroTalentNodeCanLeveUp() or not self.defaultBtnColor then
    ((self.ui).img_Upgrade).color = (self.ui).color_unclick
    ;
    ((self.ui).lvUp):SetActive(true)
    local rewardIds, rewardCounts = (self._talentNode):GetHeroTalentNodeLevelupReward()
    local hasReward = rewardIds ~= nil and #rewardIds > 0
    ;
    ((self.ui).obj_UpgradeGet):SetActive(hasReward)
    ;
    ((self.ui).obj_Consume):SetActive(not hasReward)
    ;
    ((self.ui).tex_Tile):SetIndex(hasReward and 1 or 0)
    if hasReward then
      ((self.ui).consumeNode):SetActive(false)
      ;
      ((self.ui).rewardNode):SetActive(true)
      for index,itemId in ipairs(rewardIds) do
        local item = (self._rewardPool):GetOne()
        local itemCfg = (ConfigData.item)[itemId]
        item:InitItemWithCount(itemCfg, rewardCounts[index])
      end
      return 
    end
    ;
    ((self.ui).consumeNode):SetActive(true)
    ;
    ((self.ui).rewardNode):SetActive(false)
    local costIds, costNums = (self._talentNode):GetHeroTalentNodeLevelupCost()
    if costIds == nil or costNums == nil then
      return 
    end
    local hasCoin = false
    local sTokenIndex = nil
    for index,itemId in ipairs(costIds) do
      if itemId == ConstGlobalItem.NormalGold then
        hasCoin = true
        sTokenIndex = index
      else
        local item = (self._costPool):GetOne()
        item:RefresheDetailCost(itemId, costNums[index])
      end
    end
    -- DECOMPILER ERROR at PC119: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).img_UpIcon).enabled = hasCoin
    -- DECOMPILER ERROR at PC123: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (((self.ui).tex_UpNum).text).enabled = hasCoin
    if not hasCoin then
      return 
    end
    -- DECOMPILER ERROR at PC133: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).img_UpIcon).sprite = CRH:GetSpriteByItemId(1003)
    local costNum = costNums[sTokenIndex]
    local index = 0
    local curNum = PlayerDataCenter:GetItemCount(ConstGlobalItem.NormalGold)
    if costNum <= curNum then
      index = 1
    end
    ;
    ((self.ui).tex_UpNum):SetIndex(index, tostring(costNum))
    -- DECOMPILER ERROR: 11 unprocessed JMP targets
  end
end

UINHeroTalentDetailNode.OnClickTalentLvUp = function(self)
  -- function num : 0_10
  if self._lvUpClickFunc ~= nil then
    (self._lvUpClickFunc)(self._talentNode)
  end
end

UINHeroTalentDetailNode.__OnClickBranchSelectListen = function(self, branchId)
  -- function num : 0_11
  if self._branchClickFunc ~= nil then
    (self._branchClickFunc)(branchId)
  end
end

return UINHeroTalentDetailNode

