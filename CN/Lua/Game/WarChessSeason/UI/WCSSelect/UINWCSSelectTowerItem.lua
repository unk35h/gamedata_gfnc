-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWCSSelectTowerItem = class("UINWCSSelectTowerItem", UIBaseNode)
local base = UIBaseNode
UINWCSSelectTowerItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickConfirm)
end

UINWCSSelectTowerItem.InitModelItem = function(self, stageInfoCfg, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._stageInfoCfg = stageInfoCfg
  self._callback = callback
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ModeENName).text = stageInfoCfg.difficulty_name_en
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ModeCNName).text = (LanguageUtil.GetLocaleText)(stageInfoCfg.difficulty_name)
  ;
  ((self.ui).tex_Recommend):SetIndex(0, tostring(stageInfoCfg.combat))
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_EPoints).text = (LanguageUtil.GetLocaleText)(stageInfoCfg.forecast_des)
end

UINWCSSelectTowerItem.SetModelItemUnLocke = function(self, flag)
  -- function num : 0_2 , upvalues : _ENV
  if not IsNull((self.ui).obj_Locked) then
    ((self.ui).obj_Locked):SetActive(not flag)
    if not flag then
      local conditionList = (self._stageInfoCfg).preConditions
      local unlockStr = ""
      if (self._stageInfoCfg).preConditionsNum > 1 then
        unlockStr = (CheckCondition.GetUnlockInfoLuaByManyList)(conditionList)
      else
        if (self._stageInfoCfg).preConditionsNum == 1 then
          local firstCond = conditionList[1]
          unlockStr = (CheckCondition.GetUnlockInfoLua)(firstCond[1], firstCond[2], firstCond[3])
        end
      end
      do
        -- DECOMPILER ERROR at PC45: Confused about usage of register: R4 in 'UnsetPending'

        ;
        ((self.ui).tex_unlock).text = ConfigData:GetTipContent(8708, unlockStr)
      end
    end
  end
end

UINWCSSelectTowerItem.SetModelColor = function(self, index)
  -- function num : 0_3
  local color = ((self.ui).color_state)[index]
  if color == nil then
    color = ((self.ui).color_state)[#(self.ui).color_state]
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_ModeBg).color = color
end

UINWCSSelectTowerItem.OnClickConfirm = function(self)
  -- function num : 0_4
  if self._callback ~= nil then
    (self._callback)(self)
  end
end

UINWCSSelectTowerItem.GetModeItemDiffInfoCfg = function(self)
  -- function num : 0_5
  return self._stageInfoCfg
end

return UINWCSSelectTowerItem

