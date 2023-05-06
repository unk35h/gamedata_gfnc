-- params : ...
-- function num : 0 , upvalues : _ENV
local eType = (require("Game.PayGift.eSelfSelectGift")).type
local GetCanSelectHeroFragByRule = function(checkRule, insertRule)
  -- function num : 0_0 , upvalues : _ENV
  if checkRule == nil or insertRule == nil then
    return nil
  end
  local dataList = {}
  for heroId,heroData in pairs(PlayerDataCenter.heroDic) do
    if checkRule(heroId, heroData) then
      insertRule(dataList, heroId, heroData)
    end
  end
  ;
  (table.sort)(dataList, function(a, b)
    -- function num : 0_0_0
    do return a.heroId < b.heroId end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local itemList = {}
  local numList = {}
  for index,data in ipairs(dataList) do
    (table.insert)(itemList, data.fragId)
    ;
    (table.insert)(numList, data.num)
  end
  return dataList, itemList, numList
end

local GetCanSelectHeroFragByRuleInAllHero = function(checkRule, insertRule)
  -- function num : 0_1 , upvalues : _ENV
  if checkRule == nil or insertRule == nil then
    return nil
  end
  local cfgList = {}
  for heroId,heroCfg in pairs(ConfigData.hero_data) do
    if checkRule(heroId, heroCfg) then
      insertRule(cfgList, heroId, heroCfg)
    end
  end
  ;
  (table.sort)(cfgList, function(a, b)
    -- function num : 0_1_0
    do return a.heroId < b.heroId end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local itemList = {}
  local numList = {}
  for index,cfg in ipairs(cfgList) do
    (table.insert)(itemList, cfg.fragId)
    ;
    (table.insert)(numList, cfg.num)
  end
  return cfgList, itemList, numList
end

local ShowSelectHeroFragWin = function(window, dataList, payGiftInfo, fragNum, itemList, numList, afterSelectFunc, selfSelectCfg, mainTitle, subTitle)
  -- function num : 0_2 , upvalues : _ENV
  window:InitCommonGiftSelect(itemList, numList, function(index)
    -- function num : 0_2_0 , upvalues : dataList, _ENV, fragNum, payGiftInfo, afterSelectFunc, selfSelectCfg, window
    local heroId = (dataList[index]).heroId
    local hasThisHero = true
    local maxNeedNum = 0
    local heroData = (PlayerDataCenter.heroDic)[heroId]
    if heroData ~= nil then
      maxNeedNum = heroData:GetMaxNeedFragNum(true)
      hasThisHero = true
    else
      hasThisHero = false
    end
    local RealBug = function()
      -- function num : 0_2_0_0 , upvalues : _ENV, heroId, dataList, index, fragNum, payGiftInfo, afterSelectFunc, selfSelectCfg, window
      local paramList = {}
      ;
      (table.insert)(paramList, {param = heroId})
      local fragId = (dataList[index]).fragId
      local showItemIds = {}
      local showItemNums = {}
      ;
      (table.insert)(showItemIds, fragId)
      ;
      (table.insert)(showItemNums, fragNum)
      local giftCfg = payGiftInfo.defaultCfg
      for index,itemId in ipairs(giftCfg.awardIds) do
        local num = (giftCfg.awardCounts)[index]
        ;
        (table.insert)(showItemIds, itemId)
        ;
        (table.insert)(showItemNums, num)
      end
      payGiftInfo:SetSelfSelectInfo(showItemIds, showItemNums, paramList)
      afterSelectFunc(selfSelectCfg)
      window:Delete()
      ;
      (UIUtil.OnClickBackByUiTab)(self)
    end

    if hasThisHero and maxNeedNum < fragNum then
      ((CS.MessageCommon).ShowMessageBox)(ConfigData:GetTipContent(3011), RealBug, nil)
    else
      RealBug()
    end
  end
, nil)
  window:SetTitleAndSubTitle(mainTitle, subTitle)
end

local SelfSelectGiftDealFunc = {[eType.heroFragWithOutLimit] = function(selfSelectCfg, afterSelectFunc, payGiftInfo)
  -- function num : 0_3 , upvalues : _ENV, GetCanSelectHeroFragByRule, ShowSelectHeroFragWin
  local fragNum = (selfSelectCfg.param1)[1]
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonSelectGift, function(window)
    -- function num : 0_3_0 , upvalues : GetCanSelectHeroFragByRule, _ENV, fragNum, ShowSelectHeroFragWin, payGiftInfo, afterSelectFunc, selfSelectCfg
    if window == nil then
      return 
    end
    local dataList, itemList, numList = GetCanSelectHeroFragByRule(function(heroId, heroData)
      -- function num : 0_3_0_0
      local heroCfg = heroData.heroCfg
      if not heroCfg.is_limited then
        return true
      end
    end
, function(dataList, heroId, heroData)
      -- function num : 0_3_0_1 , upvalues : _ENV, fragNum
      (table.insert)(dataList, {heroId = heroId, fragId = heroData.fragId, num = fragNum})
    end
)
    if dataList == nil then
      return 
    end
    ShowSelectHeroFragWin(window, dataList, payGiftInfo, fragNum, itemList, numList, afterSelectFunc, selfSelectCfg)
  end
)
end
, [eType.heroCard] = function(selfSelectCfg, afterSelectFunc, payGiftInfo)
  -- function num : 0_4 , upvalues : _ENV
  local oriLayout = (UIWindowGlobalConfig[UIWindowTypeID.CustomHeroSelect]).LayoutLevel
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (UIWindowGlobalConfig[UIWindowTypeID.CustomHeroSelect]).LayoutLevel = EUILayoutLevel.High
  UIManager:ShowWindowAsync(UIWindowTypeID.CustomHeroSelect, function(win)
    -- function num : 0_4_0 , upvalues : _ENV, oriLayout, payGiftInfo, selfSelectCfg, afterSelectFunc
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

    (UIWindowGlobalConfig[UIWindowTypeID.CustomHeroSelect]).LayoutLevel = oriLayout
    if win == nil then
      return 
    end
    local params = payGiftInfo:GetSelfSelectGiftParams()
    local selectHeroId = params ~= nil and (params[1]).param or nil
    win:InitCustomHeroSelect(selfSelectCfg, selectHeroId, function(selectHeroId)
      -- function num : 0_4_0_0 , upvalues : payGiftInfo, _ENV, afterSelectFunc
      if selectHeroId == nil then
        payGiftInfo:CleanSelfSelectInfo()
      else
        local paramList = {}
        ;
        (table.insert)(paramList, {param = selectHeroId})
        payGiftInfo:SetSelfSelectInfo((payGiftInfo.defaultCfg).awardIds, (payGiftInfo.defaultCfg).awardCounts, paramList)
      end
      do
        afterSelectFunc()
      end
    end
)
  end
)
end
, [eType.heroFragWithSpecWeapon] = function(selfSelectCfg, afterSelectFunc, payGiftInfo)
  -- function num : 0_5 , upvalues : GetCanSelectHeroFragByRule, _ENV, ShowSelectHeroFragWin
  local fragNum = (selfSelectCfg.param1)[1]
  local dataList, itemList, numList = GetCanSelectHeroFragByRule(function(heroId, heroData)
    -- function num : 0_5_0 , upvalues : _ENV
    local weaponId = (PlayerDataCenter.allSpecWeaponData):GetHeroSpecWeaponId(heroId)
    if weaponId ~= nil then
      return true
    end
  end
, function(dataList, heroId, heroData)
    -- function num : 0_5_1 , upvalues : _ENV, fragNum
    (table.insert)(dataList, {heroId = heroId, fragId = heroData.fragId, num = fragNum})
  end
)
  if dataList == nil then
    return 
  end
  if #dataList == 0 then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(TipContent.selfSelect_heroFrag_NoHeroTip))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonSelectGift, function(window)
    -- function num : 0_5_2 , upvalues : ShowSelectHeroFragWin, dataList, payGiftInfo, fragNum, itemList, numList, afterSelectFunc, selfSelectCfg, _ENV
    if window == nil then
      return 
    end
    ShowSelectHeroFragWin(window, dataList, payGiftInfo, fragNum, itemList, numList, afterSelectFunc, selfSelectCfg, TipContent.selfSelect_heroFrag_Title, TipContent.selfSelect_heroFrag_SubTitle)
  end
)
end
, [eType.heroFragSelected] = function(selfSelectCfg, afterSelectFunc, payGiftInfo)
  -- function num : 0_6 , upvalues : _ENV, GetCanSelectHeroFragByRuleInAllHero, ShowSelectHeroFragWin
  local fragNum = (selfSelectCfg.param1)[1]
  local fragIds = selfSelectCfg.param2
  local fragIdDic = {}
  for _,fragId in pairs(fragIds) do
    fragIdDic[fragId] = true
  end
  local dataList, itemList, numList = GetCanSelectHeroFragByRuleInAllHero(function(heroId, heroData)
    -- function num : 0_6_0 , upvalues : fragIdDic
    if fragIdDic[heroId] ~= nil then
      return true
    end
  end
, function(dataList, heroId, heroData)
    -- function num : 0_6_1 , upvalues : _ENV, fragNum
    (table.insert)(dataList, {heroId = heroId, fragId = heroData.fragment, num = fragNum})
  end
)
  if dataList == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonSelectGift, function(window)
    -- function num : 0_6_2 , upvalues : ShowSelectHeroFragWin, dataList, payGiftInfo, fragNum, itemList, numList, afterSelectFunc, selfSelectCfg
    if window == nil then
      return 
    end
    ShowSelectHeroFragWin(window, dataList, payGiftInfo, fragNum, itemList, numList, afterSelectFunc, selfSelectCfg, 414, 415)
  end
)
end
}
return SelfSelectGiftDealFunc

