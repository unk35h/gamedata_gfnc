-- params : ...
-- function num : 0 , upvalues : _ENV
local FactoryHelper = class("FactoryHelper")
local FactoryEnum = require("Game.Factory.FactoryEnum")
FactoryHelper.GetFactoryTime2EnergyCost = function(time)
  -- function num : 0_0 , upvalues : _ENV
  local constant = (ConfigData.game_config).factoryEnergy2TimeCons
  return (math.ceil)(time / constant)
end

FactoryHelper.ConvertTime2DisplayMode = function(time)
  -- function num : 0_1 , upvalues : _ENV
  local str = "%02d:%02d:%02d"
  local hour = (math.floor)(time // 3600)
  local min = (math.floor)(time % 3600 / 60)
  local second = (math.floor)(time % 60)
  return (string.format)(str, hour, min, second)
end

FactoryHelper.CheckOrderResource = function(self, orderData, needNum, usedMat, subDic, nowLeftTime, useBagMat)
  -- function num : 0_2 , upvalues : FactoryEnum, _ENV, FactoryHelper
  local orderCfg = orderData:GetOrderCfg()
  if orderData:GetTimeCost() * needNum <= nowLeftTime then
    nowLeftTime = nowLeftTime - orderData:GetTimeCost() * needNum
  else
    return false, (FactoryEnum.eCannotAddReason).timeBeyountLimit
  end
  local factoryCtrl = ControllerManager:GetController(ControllerTypeId.Factory, true)
  for itemId,cost in pairs(orderCfg.raw_material) do
    local nowCount = self:GetPlayerItemCount(itemId) - (usedMat[itemId] or 0)
    local nowCost = cost * needNum
    if nowCount < nowCost then
      local subOrderCfg = nil
      for _,orderId in ipairs((((ConfigData.factory_order).orderMap)[orderCfg.id]).sudOrderListIds) do
        if ((ConfigData.factory_order)[orderId]).outPutItemId == itemId and ((factoryCtrl.OrderDataDic)[orderId]):GetIsUnlock() then
          subOrderCfg = (ConfigData.factory_order)[orderId]
          break
        end
      end
      do
        if subOrderCfg ~= nil then
          local needNum = (math.ceil)((nowCost - nowCount) / subOrderCfg.outPutItemNum)
          local remainNum = needNum * subOrderCfg.outPutItemNum - (nowCost - nowCount)
          local couldSub, arg2 = (FactoryHelper.CheckOrderResource)(self, (factoryCtrl.OrderDataDic)[subOrderCfg.id], needNum, usedMat, subDic, nowLeftTime, useBagMat)
          if not couldSub then
            return false, arg2
          else
            subDic[subOrderCfg.id] = (subDic[subOrderCfg.id] or 0) + needNum
            usedMat[itemId] = (usedMat[itemId] or 0) + nowCount - remainNum
            nowLeftTime = arg2
          end
        else
          do
            do
              do return false, (FactoryEnum.eCannotAddReason).matInsufficeient end
              useBagMat[itemId] = -1
              usedMat[itemId] = (usedMat[itemId] or 0) + nowCost
              do
                local lastConsume = useBagMat[itemId] or 0
                if lastConsume >= 0 then
                  useBagMat[itemId] = lastConsume + nowCost
                end
                -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
    end
  end
  return true, nowLeftTime
end

return FactoryHelper

