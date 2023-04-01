-- params : ...
-- function num : 0 , upvalues : _ENV
local FavorHeroData = class("FavorHeroData")
FavorHeroData.ctor = function(self)
  -- function num : 0_0
  self.__favorHeroIdDic = {}
  self.__favorHeroIdBuffDic = {}
end

FavorHeroData.InitFavorHeroDataByMsg = function(self, msg)
  -- function num : 0_1
  self.__favorHeroIdDic = msg
end

FavorHeroData.UpdateFavorHeroDataByMsg = function(self, msg)
  -- function num : 0_2
end

FavorHeroData.IsFavorHero = function(self, heroId)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC10: Unhandled construct in 'MakeBoolean' P3

  do return ((self.__favorHeroIdDic)[heroId] and (self.__favorHeroIdBuffDic)[heroId] ~= false) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

FavorHeroData.SetIsFavorHero = function(self, heroId, bool)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  if bool then
    if not (self.__favorHeroIdDic)[heroId] then
      (self.__favorHeroIdBuffDic)[heroId] = true
    else
      -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.__favorHeroIdBuffDic)[heroId] = nil
    end
  else
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

    if (self.__favorHeroIdDic)[heroId] then
      (self.__favorHeroIdBuffDic)[heroId] = false
    else
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

      if (self.__favorHeroIdBuffDic)[heroId] then
        (self.__favorHeroIdBuffDic)[heroId] = nil
      end
    end
  end
end

FavorHeroData.ApplyFavorHeroBuffDic = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local favorList = {}
  local removeLis = {}
  for heroId,bool in pairs(self.__favorHeroIdBuffDic) do
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R8 in 'UnsetPending'

    if bool then
      (self.__favorHeroIdDic)[heroId] = true
      ;
      (table.insert)(favorList, heroId)
    else
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.__favorHeroIdDic)[heroId] = nil
      ;
      (table.insert)(removeLis, heroId)
    end
  end
  if #favorList + #removeLis == 0 then
    return 
  end
  local heroNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.Hero)
  heroNetCtrl:CS_HERO_FAVOR(favorList, removeLis)
end

FavorHeroData.CleanFavorHeroBuffDic = function(self)
  -- function num : 0_6
  self.__favorHeroIdBuffDic = {}
end

return FavorHeroData

