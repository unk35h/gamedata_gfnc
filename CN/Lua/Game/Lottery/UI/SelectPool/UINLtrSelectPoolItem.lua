-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINLtrSelectPoolItem = class("UINLtrSelectPoolItem", base)
UINLtrSelectPoolItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
end

UINLtrSelectPoolItem.InitLtrSelectPoolItem = function(self, ltrPoolData, selectFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.ltrPoolData = ltrPoolData
  self.selectFunc = selectFunc
  local ltrCfg = ltrPoolData.ltrCfg
  local repeat_type = ltrCfg.repeat_type
  ;
  ((self.ui).img_Icon):SetIndex(repeat_type)
  ;
  ((self.ui).tex_GetItem):SetIndex(repeat_type)
  ;
  ((self.ui).obj_Up):SetActive(repeat_type == 1)
  if repeat_type == 1 then
    ((self.ui).tex_Up):SetIndex(0, tostring(ltrCfg.big_prize_extra_num))
  end
  self._prob3 = ltrCfg.prob_star / 100
  self._upStar_ratio = (math.ceil)((ltrCfg.prob_in)[6] / 100)
  for k,tex in ipairs((self.ui).tex_upNumList) do
    local num = (ltrCfg.change_rule)[k + 1]
    tex:SetIndex(0, tostring(num))
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINLtrSelectPoolItem.UpdLtrPoolItemSelect = function(self, select)
  -- function num : 0_2 , upvalues : _ENV
  ;
  ((self.ui).img_Bottom):SetIndex(select and 1 or 0)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Frame).color = ((self.ui).color_frame)[select and 2 or 1]
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

  if not select or not Color.black then
    ((self.ui).img_SwitchIcon).color = Color.white
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_GetItem).text).color = ((self.ui).color_GetItem)[select and 2 or 1]
    -- DECOMPILER ERROR at PC58: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_Star3).text).color = ((self.ui).color_GetItem)[select and 2 or 1]
    -- DECOMPILER ERROR at PC70: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Switch).color = ((self.ui).color_Index)[select and 2 or 1]
    -- DECOMPILER ERROR at PC82: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_change).color = ((self.ui).color_tex_challenge)[select and 2 or 1]
    ;
    ((self.ui).tex_GetItem):SetIndex(select and 1 or 0, tostring(self._upStar_ratio))
    ;
    ((self.ui).tex_Star3):SetIndex(select and 1 or 0, tostring(self._prob3))
    local color = ((self.ui).color_ListText)[select and 2 or 1]
    for i = 1, 3 do
      -- DECOMPILER ERROR at PC126: Confused about usage of register: R7 in 'UnsetPending'

      ((((self.ui).tex_upNumList)[i]).text).color = color
      -- DECOMPILER ERROR at PC130: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (((self.ui).tex_ListLeft)[i]).color = color
    end
  end
end

UINLtrSelectPoolItem._OnClickRoot = function(self)
  -- function num : 0_3
  if self.selectFunc ~= nil then
    (self.selectFunc)(self, self.ltrPoolData)
  end
end

UINLtrSelectPoolItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINLtrSelectPoolItem

