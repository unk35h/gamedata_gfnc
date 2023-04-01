-- params : ...
-- function num : 0 , upvalues : _ENV
GameGlobalUtil = {}
local CS_Shader = (CS.UnityEngine).Shader
-- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

GameGlobalUtil.CollectDiffReward = function(diff)
  -- function num : 0_0 , upvalues : _ENV
  local rewardTable = {}
  if diff == nil then
    return rewardTable
  end
  if diff.resource ~= nil and (diff.resource).backpack ~= nil then
    local updates = ((diff.resource).backpack).updates
    for id,updateItemInfo in pairs(updates) do
      local itemCount = PlayerDataCenter:GetItemCount(id)
      if itemCount < updateItemInfo.count then
        local addCount = updateItemInfo.count - itemCount
        rewardTable[id] = addCount
      end
    end
  end
  do
    if diff.ath ~= nil then
      local updateAth = (diff.ath).updateAth
      for uid,_ in pairs(updateAth) do
        local itemId = uid >> 32
        rewardTable[uid] = 1
      end
    end
    do
      return rewardTable
    end
  end
end

-- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

GameGlobalUtil.InitCustomLightingGlobalValue = function()
  -- function num : 0_1 , upvalues : CS_Shader, _ENV
  (CS_Shader.SetGlobalVector)((CS_Shader.PropertyToID)("_CustomLightDir"), (Vector4.New)(0.001, 0.001, -1, 1))
  ;
  (CS_Shader.SetGlobalVector)((CS_Shader.PropertyToID)("_CustomPointLightShadowPos"), (Vector4.New)(0.001, 0.001, 0.001, 0.001))
end


