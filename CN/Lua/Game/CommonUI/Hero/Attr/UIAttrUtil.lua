-- params : ...
-- function num : 0 , upvalues : _ENV
local UIAttrUtil = {}
local UINAttrOutlineWindow = require("Game.CommonUI.Hero.Attr.UINAttrOutLineWindow")
local UINAttrMiniWidget = require("Game.CommonUI.Hero.Attr.UINAttrMiniWidget")
UIAttrUtil.GetAttrDataListForShow = function(heroData)
  -- function num : 0_0 , upvalues : _ENV
  local attrDataList = {}
  for _,attrId in ipairs((ConfigData.attribute).baseAttrIds) do
    if ((ConfigData.attribute)[attrId]).merge_attribute == 0 then
      local attrValue = heroData:GetAttr(attrId)
      local basicAttrValue = heroData:GetAttr(attrId, nil, nil, true)
      local addAttrValue = attrValue - basicAttrValue
      local attrName, attrValueStrs, attrIcon = nil, nil, nil
      if addAttrValue <= 0 then
        attrName = ConfigData:GetAttribute(attrId, {[1] = basicAttrValue})
      else
        -- DECOMPILER ERROR at PC43: Overwrote pending register: R12 in 'AssignReg'

        -- DECOMPILER ERROR at PC44: Overwrote pending register: R11 in 'AssignReg'

        attrName = ConfigData:GetAttribute(attrId, {[1] = basicAttrValue, [2] = attrValue - basicAttrValue})
      end
      local isRecommend = heroData:IsHeroRecommendAttr(attrId)
      local tempData = {attrId = attrId, name = attrName, attrValueStrs = attrValueStrs, icon = attrIcon, isRecommend = isRecommend}
      ;
      (table.insert)(attrDataList, tempData)
    end
  end
  return attrDataList
end

UIAttrUtil.GetDynBattleRoleAttrDataListForShow = function(dynRole, getValueFunc)
  -- function num : 0_1 , upvalues : _ENV
  local attrDataList = {}
  for _,attrId in ipairs((ConfigData.attribute).baseAttrIds) do
    if ((ConfigData.attribute)[attrId]).merge_attribute == 0 then
      local attrValue = getValueFunc(dynRole, attrId)
      if attrValue > 0 then
        local attrName, attrValueStrs, attrIcon = ConfigData:GetAttribute(attrId, {[1] = attrValue})
        local tempData = {attrId = attrId, name = attrName, attrValueStrs = attrValueStrs, icon = attrIcon}
        ;
        (table.insert)(attrDataList, tempData)
      end
    end
  end
  return attrDataList
end

UIAttrUtil.ShowAttrOutLineWindow = function(heroData, ui_logicPreviewNode)
  -- function num : 0_2 , upvalues : UIAttrUtil, UINAttrOutlineWindow
  local attrDataList = (UIAttrUtil.GetAttrDataListForShow)(heroData)
  local attrOutLineWindow = (UINAttrOutlineWindow.New)()
  attrOutLineWindow:Init(ui_logicPreviewNode)
  return attrOutLineWindow, attrDataList
end

UIAttrUtil.UpdateAttrData = function(heroName, attrDataList, attrOutLineWindow)
  -- function num : 0_3
  attrOutLineWindow:OnUpdateAttrData(heroName, attrDataList)
end

UIAttrUtil.ShowAttrMiniWidget = function(dynRole, ui_mini_logicPreviewNode)
  -- function num : 0_4 , upvalues : UIAttrUtil, UINAttrMiniWidget
  local attrDataList = (UIAttrUtil.GetDynBattleRoleAttrDataListForShow)(dynRole, function(dynRealRole, attrId)
    -- function num : 0_4_0
    return dynRealRole:GetRealAttr(attrId)
  end
)
  local attrMiniWidget = (UINAttrMiniWidget.New)()
  attrMiniWidget:Init(ui_mini_logicPreviewNode)
  return attrMiniWidget, attrDataList
end

UIAttrUtil.ShowEntityAttrMiniWidget = function(entity, ui_mini_logicPreviewNode)
  -- function num : 0_5 , upvalues : UIAttrUtil, UINAttrMiniWidget
  local attrDataList = (UIAttrUtil.GetDynBattleRoleAttrDataListForShow)(entity, function(dynRealRole, attrId)
    -- function num : 0_5_0 , upvalues : entity
    return entity:GetRealProperty(attrId)
  end
)
  local attrMiniWidget = (UINAttrMiniWidget.New)()
  attrMiniWidget:Init(ui_mini_logicPreviewNode)
  return attrMiniWidget, attrDataList
end

UIAttrUtil.ShowSummonerAttrMiniWidget = function(summonerEntity, ui_mini_logicPreviewNode)
  -- function num : 0_6 , upvalues : UIAttrUtil, UINAttrMiniWidget
  local attrDataList = (UIAttrUtil.GetDynBattleRoleAttrDataListForShow)(summonerEntity, function(summonerRealEntity, attrId)
    -- function num : 0_6_0
    return summonerRealEntity:GetRealProperty(attrId)
  end
)
  local attrMiniWidget = (UINAttrMiniWidget.New)()
  attrMiniWidget:Init(ui_mini_logicPreviewNode)
  return attrMiniWidget, attrDataList
end

UIAttrUtil.GetAttrSortListData = function(attrMap)
  -- function num : 0_7 , upvalues : _ENV
  local attrIds = {}
  local attrNums = {}
  for id,num in pairs(attrMap) do
    (table.insert)(attrIds, id)
  end
  ;
  (table.sort)(attrIds, function(a1, a2)
    -- function num : 0_7_0 , upvalues : _ENV
    local p1 = ((ConfigData.attribute)[a1]).attribute_priority
    local p2 = ((ConfigData.attribute)[a2]).attribute_priority
    if a1 >= a2 then
      do return p1 ~= p2 end
      do return p1 < p2 end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  for _,attrId in pairs(attrIds) do
    (table.insert)(attrNums, attrMap[attrId])
  end
  return attrIds, attrNums
end

return UIAttrUtil

