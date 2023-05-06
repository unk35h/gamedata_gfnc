-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSummerLvSwitch = class("UIActSummerLvSwitch", UIBaseWindow)
local base = UIBaseWindow
local UINActSummerLvSwitchBtn = require("Game.ActivitySummer.UI.UINActSummerLvSwitchBtn")
UIActSummerLvSwitch.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActSummerLvSwitchBtn
  (UIUtil.SetTopStatus)(self, self.Delete)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Comfirm, self, self.OnClickSummerLvConfirm)
  self.__OnSelectLv = BindCallback(self, self.OnSelectSummerLv)
  self.lvBtnPool = (UIItemPool.New)(UINActSummerLvSwitchBtn, (self.ui).btn_DiffSwitch)
  ;
  ((self.ui).btn_DiffSwitch):SetActive(false)
end

UIActSummerLvSwitch.InitIActSummerLvSwitch = function(self, difficultList, defaultSelectIndex, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._selectIndex = nil
  self.callback = callback
  self.difficultList = difficultList
  ;
  (self.lvBtnPool):HideAll()
  if not defaultSelectIndex then
    defaultSelectIndex = 1
  end
  defaultSelectIndex = (math.clamp)(defaultSelectIndex, 1, #difficultList)
  for diffcult,_ in ipairs(difficultList) do
    local item = (self.lvBtnPool):GetOne()
    item:InitSummerLvBtn(diffcult, self.__OnSelectLv)
    if defaultSelectIndex == diffcult then
      self:OnSelectSummerLv(diffcult)
    end
  end
end

UIActSummerLvSwitch.OnSelectSummerLv = function(self, index)
  -- function num : 0_2 , upvalues : _ENV
  self._selectIndex = index
  for _,switchBtn in ipairs((self.lvBtnPool).listItem) do
    switchBtn:SetSummerLvState(switchBtn.index == index)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIActSummerLvSwitch.OnClickSummerLvConfirm = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self._selectIndex == nil then
    return 
  end
  if (self.difficultList)[self._selectIndex] == nil then
    return 
  end
  if self.callback == nil then
    return 
  end
  ;
  (self.lvBtnPool):DeleteAll()
  ;
  (UIUtil.OnClickBackByUiTab)(self)
  ;
  (self.callback)((self.difficultList)[self._selectIndex])
end

return UIActSummerLvSwitch

