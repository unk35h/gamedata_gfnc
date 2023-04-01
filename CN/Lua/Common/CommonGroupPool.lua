-- params : ...
-- function num : 0 , upvalues : _ENV
local CommonGroupPool = {}
CommonGroupPool.__index = CommonGroupPool
CommonGroupPool.New = function(NewFunc, ResetFunc)
  -- function num : 0_0 , upvalues : _ENV, CommonGroupPool
  local self = {}
  self.__poolKeylist = {}
  self.__newFunc = NewFunc
  self.__resetFunc = ResetFunc
  setmetatable(self, CommonGroupPool)
  return self
end

CommonGroupPool.PoolGet = function(self, key)
  -- function num : 0_1 , upvalues : _ENV
  local poolList = (self.__poolKeylist)[key]
  if poolList ~= nil and #poolList > 0 then
    return (table.remove)(poolList)
  end
  if self.__newFunc == nil then
    return nil
  end
  return (self.__newFunc)(key)
end

CommonGroupPool.PoolPut = function(self, key, ele)
  -- function num : 0_2 , upvalues : _ENV
  local poolList = (self.__poolKeylist)[key]
  if poolList == nil then
    poolList = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.__poolKeylist)[key] = poolList
  end
  if self.__resetFunc ~= nil and not (self.__resetFunc)(ele) then
    return 
  end
  ;
  (table.insert)(poolList, ele)
end

CommonGroupPool.PoolClear = function(self)
  -- function num : 0_3
  self.__poolKeylist = {}
end

CommonGroupPool.PoolClearKey = function(self, key)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.__poolKeylist)[key] = nil
end

return CommonGroupPool

