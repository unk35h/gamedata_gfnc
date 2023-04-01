-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHalloweenSelectArchiveItem = class("UINHalloweenSelectArchiveItem", UIBaseNode)
local base = UIBaseNode
UINHalloweenSelectArchiveItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickArchive)
end

UINHalloweenSelectArchiveItem.InitSelectArchiveItem = function(self, hallowmasData, index, archives, selectCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._hallowmasData = hallowmasData
  self._archives = archives
  self._selectCallback = selectCallback
  self._index = index
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = (string.format)("%02d", index)
  ;
  ((self.ui).tex_FileNum):SetIndex(1)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).tex_FileNum).text).color = (self.ui).color_emptyTex
  ;
  ((self.ui).img_Icon):SetIndex(self._archives ~= nil and 0 or 1)
  ;
  (((self.ui).tex_EnviroDes).gameObject):SetActive(self._archives ~= nil)
  ;
  (((self.ui).tex_ModeDes).gameObject):SetActive(self._archives ~= nil)
  ;
  ((self.ui).info):SetActive(self._archives ~= nil)
  ;
  (((self.ui).img_EnviroBg).gameObject):SetActive(self._archives ~= nil)
  if self._archives ~= nil then
    ((self.ui).tex_FileNum):SetIndex(0, tostring(index))
    -- DECOMPILER ERROR at PC89: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (((self.ui).tex_FileNum).text).color = Color.white
    if hallowmasData ~= nil then
      local stageInfoCfgs = (hallowmasData:GetHallowmasStageInfoCfg())
      local stageInfo, index = nil, nil
      for i,v in ipairs(stageInfoCfgs) do
        if v.season_id == (self._archives).warChessTowerId then
          stageInfo = v
          index = v.difficulty_color + 1
        end
      end
      -- DECOMPILER ERROR at PC117: Confused about usage of register: R8 in 'UnsetPending'

      if stageInfo ~= nil then
        ((self.ui).tex_EnviroDes).text = (LanguageUtil.GetLocaleText)(stageInfo.difficulty_name)
        -- DECOMPILER ERROR at PC124: Confused about usage of register: R8 in 'UnsetPending'

        ;
        ((self.ui).tex_ModeDes).text = (LanguageUtil.GetLocaleText)(stageInfo.difficulty_name_en)
        local color = ((self.ui).color_diffculty)[index]
        if color == nil then
          color = ((self.ui).color_diffculty)[#(self.ui).color_diffculty]
        end
        -- DECOMPILER ERROR at PC138: Confused about usage of register: R9 in 'UnsetPending'

        ;
        ((self.ui).img_EnviroBg).color = color
      end
    end
    local buffCount = 0
    for i,v in ipairs((self._archives).warChessBuffs) do
      local buffCfg = (ConfigData.warchess_buff)[v.configId]
      if buffCfg ~= nil and buffCfg.is_show then
        buffCount = buffCount + 1
      end
    end
    ;
    ((self.ui).tex_Port):SetIndex(0, tostring(buffCount))
    ;
    ((self.ui).tex_Layer):SetIndex(0, tostring((self._archives).warChessSeasonFloor))
    local algCount = 0
    for k,v in pairs((self._archives).alg) do
      algCount = algCount + v
    end
    ;
    ((self.ui).tex_Func):SetIndex(0, tostring(algCount))
  end
  -- DECOMPILER ERROR: 10 unprocessed JMP targets
end

UINHalloweenSelectArchiveItem.SetFileNameByEnvName = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self._archives == nil then
    return 
  end
  local diffId = (self._hallowmasData):GetHallowmasDiffIdByTowerId((self._archives).warChessTowerId)
  local envId = (self._hallowmasData):GetHallowmasEnvIdByDifficultyId(diffId)
  if envId == -1 then
    if isGameDev then
      error(" env is nil ")
    end
    return 
  end
  local cfg = (ConfigData.activity_hallowmas_general_env)[envId]
  ;
  ((self.ui).tex_FileNum):SetIndex(2, (LanguageUtil.GetLocaleText)(cfg.general_env_name))
end

UINHalloweenSelectArchiveItem.RefreshSelectArchiveState = function(self, flag)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if flag then
    ((self.ui).img_Frame).color = (self.ui).color_selected
  else
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Frame).color = (self.ui).color_unselect
  end
end

UINHalloweenSelectArchiveItem.GetArchiveData = function(self)
  -- function num : 0_4
  return self._archives
end

UINHalloweenSelectArchiveItem.GetArchiveIndex = function(self)
  -- function num : 0_5
  return self._index
end

UINHalloweenSelectArchiveItem.OnClickArchive = function(self)
  -- function num : 0_6
  if self._selectCallback ~= nil then
    (self._selectCallback)(self)
  end
end

return UINHalloweenSelectArchiveItem

