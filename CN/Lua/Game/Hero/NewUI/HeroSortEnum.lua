-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroSortEnum = {}
HeroSortEnum.eSortResource = {heroList = 1, boardHero = 2, formation = 3, factory = 4, adjSelect = 5}
HeroSortEnum.eSortMannerType = {Rank = 1, Level = 2, Id = 3, GetOrder = 4, Power = 6}
HeroSortEnum.defaultShow = {[1] = (HeroSortEnum.eSortMannerType).Rank, [2] = (HeroSortEnum.eSortMannerType).Level, [3] = (HeroSortEnum.eSortMannerType).Power, [4] = (HeroSortEnum.eSortMannerType).GetOrder}
local CommonSort = function(hero1, hero2)
  -- function num : 0_0 , upvalues : _ENV
  if hero1.isLockedHero ~= true then
    do return hero1.isLockedHero == hero2.isLockedHero end
    if PlayerDataCenter.favorHeroData ~= nil then
      local isFavor1 = (PlayerDataCenter.favorHeroData):IsFavorHero(hero1.dataId)
      local isFavor2 = (PlayerDataCenter.favorHeroData):IsFavorHero(hero2.dataId)
      if isFavor1 ~= true then
        do
          do return isFavor1 == isFavor2 end
          do return nil end
          -- DECOMPILER ERROR: 4 unprocessed JMP targets
        end
      end
    end
  end
end

HeroSortEnum.SortMannerDefine = {
[(HeroSortEnum.eSortMannerType).Rank] = {descSort = function(hero1, hero2)
  -- function num : 0_1 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  if hero2.rank < hero1.rank then
    return true
  else
    if hero1.rank == hero2.rank then
      if hero2.level < hero1.level then
        return true
      else
        if hero2.dataId >= hero1.dataId then
          do return hero1.level ~= hero2.level end
          do return false end
          -- DECOMPILER ERROR: 2 unprocessed JMP targets
        end
      end
    end
  end
end
, asceSort = function(hero1, hero2)
  -- function num : 0_2 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  if hero1.rank < hero2.rank then
    return true
  else
    if hero1.rank == hero2.rank then
      if hero1.level < hero2.level then
        return true
      else
        if hero1.dataId >= hero2.dataId then
          do return hero1.level ~= hero2.level end
          do return false end
          -- DECOMPILER ERROR: 2 unprocessed JMP targets
        end
      end
    end
  end
end
}
, 
[(HeroSortEnum.eSortMannerType).GetOrder] = {descSort = function(hero1, hero2)
  -- function num : 0_3 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  do return hero2.ts < hero1.ts end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, asceSort = function(hero1, hero2)
  -- function num : 0_4 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  do return hero1.ts < hero2.ts end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
, 
[(HeroSortEnum.eSortMannerType).Level] = {descSort = function(hero1, hero2)
  -- function num : 0_5 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  if hero2.level < hero1.level then
    return true
  else
    if hero1.level == hero2.level then
      if hero2.rank < hero1.rank then
        return true
      else
        if hero2.dataId >= hero1.dataId then
          do return hero1.rank ~= hero2.rank end
          do return false end
          -- DECOMPILER ERROR: 2 unprocessed JMP targets
        end
      end
    end
  end
end
, asceSort = function(hero1, hero2)
  -- function num : 0_6 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  if hero1.level < hero2.level then
    return true
  else
    if hero1.level == hero2.level then
      if hero1.rank < hero2.rank then
        return true
      else
        if hero1.dataId >= hero2.dataId then
          do return hero1.rank ~= hero2.rank end
          do return false end
          -- DECOMPILER ERROR: 2 unprocessed JMP targets
        end
      end
    end
  end
end
}
, 
[(HeroSortEnum.eSortMannerType).Id] = {descSort = function(hero1, hero2)
  -- function num : 0_7 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  do return hero2.dataId < hero1.dataId end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, asceSort = function(hero1, hero2)
  -- function num : 0_8 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  do return hero1.dataId < hero2.dataId end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
, 
[(HeroSortEnum.eSortMannerType).Power] = {descSort = function(hero1, hero2)
  -- function num : 0_9 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  if not hero1.isLockedHero and not hero2.isLockedHero then
    local pow1 = hero1:TryGetCachedPower()
    local pow2 = hero2:TryGetCachedPower()
    if pow2 >= pow1 then
      do
        do return pow1 == pow2 end
        do return hero2.dataId < hero1.dataId end
        -- DECOMPILER ERROR: 3 unprocessed JMP targets
      end
    end
  end
end
, asceSort = function(hero1, hero2)
  -- function num : 0_10 , upvalues : CommonSort
  local result = CommonSort(hero1, hero2)
  if result ~= nil then
    return result
  end
  if not hero1.isLockedHero and not hero2.isLockedHero then
    local pow1 = hero1:TryGetCachedPower()
    local pow2 = hero2:TryGetCachedPower()
    if pow1 >= pow2 then
      do
        do return pow1 == pow2 end
        do return hero1.dataId < hero2.dataId end
        -- DECOMPILER ERROR: 3 unprocessed JMP targets
      end
    end
  end
end
}
}
return HeroSortEnum

