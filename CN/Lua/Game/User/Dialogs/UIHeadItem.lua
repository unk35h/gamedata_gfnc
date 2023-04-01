-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHeadItem = class("UIHeadItem", UIBaseNode)
local base = UIHeadItem
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
UIHeadItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HeadItem, self, self.ChangePicAction)
  self.userHeadNode = (UINUserHead.New)()
  ;
  (self.userHeadNode):Init((self.ui).obj_UINUserHead)
end

UIHeadItem.InitHeadItem = function(self, itemCfg, clickEvent, resloader, frameEffectPool)
  -- function num : 0_1 , upvalues : _ENV
  if itemCfg == nil then
    self.clickFun = nil
    return 
  end
  self.clickFun = clickEvent
  self.itemCfg = itemCfg
  if (self.itemCfg).count > 0 then
    ((self.ui).headItemLock):SetActive(false)
  else
    ;
    ((self.ui).headItemLock):SetActive(true)
  end
  if (self.itemCfg).itype == eItemType.Avatar then
    (self.userHeadNode):InitBaseHead((self.itemCfg).id, resloader, frameEffectPool)
  else
    ;
    (self.userHeadNode):InitBaseHeadFrame((self.itemCfg).id, resloader, frameEffectPool)
  end
  ;
  ((self.ui).img_HeadSel):SetActive(false)
  self.outTime = -1
  self:SetLimtTimeDetailActive(false)
end

UIHeadItem.InitOutTime = function(self, outTime)
  -- function num : 0_2
  self.outTime = outTime
  self:UpdateLimitTimeDetail()
end

UIHeadItem.ChangePicAction = function(self)
  -- function num : 0_3
  if self.clickFun ~= nil then
    (self.clickFun)(self.itemCfg, self)
  end
end

UIHeadItem.SetLimtTimeDetailActive = function(self, bValue)
  -- function num : 0_4
  if (self.ui).obj_Time ~= nil and ((self.ui).obj_Time).activeSelf ~= bValue then
    ((self.ui).obj_Time):SetActive(bValue)
  end
end

UIHeadItem.UpdateLimitTimeDetail = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.outTime == -1 then
    self:SetLimtTimeDetailActive(false)
    return 
  end
  self:SetLimtTimeDetailActive(true)
  local diffTime = self.outTime - PlayerDataCenter.timestamp
  if diffTime > 0 then
    local d, h, m, s = TimeUtil:TimestampToTimeInter(diffTime, false, true)
    if d > 0 then
      ((self.ui).tex_Time):SetIndex(0, tostring(d))
    else
      if h > 0 then
        ((self.ui).tex_Time):SetIndex(1, tostring(h))
      else
        ;
        ((self.ui).tex_Time):SetIndex(1, tostring(1))
      end
    end
  else
    do
      ;
      ((self.ui).tex_Time):SetIndex(2)
    end
  end
end

UIHeadItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UIHeadItem

