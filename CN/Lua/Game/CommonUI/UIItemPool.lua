-- params : ...
-- function num : 0 , upvalues : _ENV
local UIItemPool = class("UIItemPool")
UIItemPool.ctor = function(self, uiClass, uiPrefab, prefabActive)
  -- function num : 0_0
  self.uiClass = uiClass
  self.uiPrefab = uiPrefab
  self.listItem = {}
  self.poolItem = {}
  if prefabActive ~= nil then
    uiPrefab:SetActive(prefabActive)
  end
end

UIItemPool.HideAll = function(self)
  -- function num : 0_1 , upvalues : _ENV
  while #self.listItem > 0 do
    local item = (table.remove)(self.listItem, #self.listItem)
    item:Hide()
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

    if self.__hideName ~= nil then
      (item.gameObject).name = tostring(self.__hideName)
    end
    ;
    (table.insert)(self.poolItem, item)
  end
end

UIItemPool.HideOne = function(self, item)
  -- function num : 0_2 , upvalues : _ENV
  item:Hide()
  ;
  (table.removebyvalue)(self.listItem, item, false)
  ;
  (table.insert)(self.poolItem, item)
end

UIItemPool.GetOne = function(self, isShow)
  -- function num : 0_3 , upvalues : _ENV
  if (isShow == nil and true) or #self.poolItem > 0 then
    local item = (table.remove)(self.poolItem, #self.poolItem)
    if isShow then
      item:Show()
    end
    ;
    (item.transform):SetAsLastSibling()
    ;
    (table.insert)(self.listItem, item)
    return item
  else
    do
      local item = ((self.uiClass).New)()
      local go = (self.uiPrefab):Instantiate()
      if isShow then
        go:SetActive(true)
      end
      item:Init(go)
      ;
      (table.insert)(self.listItem, item)
      do return item end
    end
  end
end

UIItemPool.DeleteAll = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self:HideAll()
  for k,v in ipairs(self.poolItem) do
    v:Delete()
  end
  self.poolItem = {}
end

UIItemPool.SetItemPoolHideName = function(self, name)
  -- function num : 0_5
  self.__hideName = name
end

return UIItemPool

