-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActWinter23LvSwitch = class("UIActWinter23LvSwitch", UIBaseWindow)
local base = UIBaseWindow
local UINActWinter23LvSwitchBtn = require("Game.ActivityWinter23.UI.Sector.UINActWinter23LvSwitchBtn")
UIActWinter23LvSwitch.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActWinter23LvSwitchBtn
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickWinter23LvConfirm)
  self.__OnSelectLv = BindCallback(self, self.OnSelectWinter23Lv)
  self.lvBtnPool = (UIItemPool.New)(UINActWinter23LvSwitchBtn, (self.ui).btn_DiffSwitch)
  ;
  ((self.ui).btn_DiffSwitch):SetActive(false)
end

UIActWinter23LvSwitch.InitIActWinter23LvSwitch = function(self, difficultList, defaultSelectIndex, resloader, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._selectIndex = nil
  self.resloader = resloader
  self.callback = callback
  self.difficultList = difficultList
  ;
  (self.lvBtnPool):HideAll()
  if not defaultSelectIndex then
    defaultSelectIndex = 1
  end
  self.difficultCfgList = {}
  for i,v in pairs(ConfigData.activity_winter23_difficulty) do
    (table.insert)(self.difficultCfgList, v)
  end
  ;
  (table.sort)(self.difficultCfgList, function(a, b)
    -- function num : 0_1_0
    do return a.sort <= b.sort end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  defaultSelectIndex = (math.clamp)(defaultSelectIndex, 1, #self.difficultCfgList)
  for diffcult,diffCfg in ipairs(self.difficultCfgList) do
    local item = (self.lvBtnPool):GetOne()
    item:InitWinter23LvBtn(diffcult, diffCfg, resloader, self.__OnSelectLv)
    if defaultSelectIndex == diffcult then
      self:OnSelectWinter23Lv(diffcult)
    end
  end
end

UIActWinter23LvSwitch.OnSelectWinter23Lv = function(self, index)
  -- function num : 0_2 , upvalues : _ENV
  self._selectIndex = index
  for _,switchBtn in ipairs((self.lvBtnPool).listItem) do
    switchBtn:SetWinter23LvState(switchBtn.index == index)
  end
  ;
  (((self.ui).obj_Selected).transform):SetParent((((self.lvBtnPool).listItem)[index]).transform)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).obj_Selected).transform).localPosition = Vector3.zero
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIActWinter23LvSwitch.OnClickWinter23LvConfirm = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self._selectIndex == nil then
    return 
  end
  if (self.difficultCfgList)[self._selectIndex] == nil then
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
  (self.callback)(((self.difficultCfgList)[self._selectIndex]).sector_id)
end

return UIActWinter23LvSwitch

