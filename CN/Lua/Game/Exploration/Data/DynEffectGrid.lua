-- params : ...
-- function num : 0 , upvalues : _ENV
local DynEffectGrid = class("DynEffectGrid")
DynEffectGrid.ctor = function(self, coord, id)
  -- function num : 0_0 , upvalues : _ENV
  self.coord = coord
  self.x = (BattleUtil.Pos2XYCoord)(coord)
  self.id = id
  local gridCfg = (ConfigData.battle_grid)[id]
  if gridCfg == nil then
    error("battle grid cfg is null,id:" .. tostring(id))
    return 
  end
  self.gridCfg = gridCfg
  self.gridSrcNames = self:__LoadGridSrcCfg()
end

DynEffectGrid.__LoadGridSrcCfg = function(self)
  -- function num : 0_1 , upvalues : _ENV
  if (self.gridCfg).creations ~= nil and #(self.gridCfg).creations > 0 then
    local gridSrcNames = {}
    for _,v in ipairs((self.gridCfg).creations) do
      local creationCfg = (ConfigData.grid_creation)[v]
      if creationCfg ~= nil then
        (table.insert)(gridSrcNames, creationCfg.src_name)
      else
        error("battle grid creation_cfg is null,id:" .. tostring(id))
      end
    end
    return gridSrcNames
  end
end

DynEffectGrid.GetGridName = function(self)
  -- function num : 0_2 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.gridCfg).name)
end

DynEffectGrid.GetGridInfo = function(self)
  -- function num : 0_3 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.gridCfg).info)
end

DynEffectGrid.GetGridType = function(self)
  -- function num : 0_4
  return (self.gridCfg).type or 0
end

DynEffectGrid.GetGridSrcName = function(self)
  -- function num : 0_5
  return self.gridSrcNames
end

DynEffectGrid.GetGridSkillScript = function(self)
  -- function num : 0_6
  return (self.gridCfg).grid_skill
end

DynEffectGrid.GetGridIconSprite = function(self)
  -- function num : 0_7 , upvalues : _ENV
  return CRH:GetSprite((self.gridCfg).icon, CommonAtlasType.ExplorationIcon)
end

DynEffectGrid.IsContainObstacle = function(self)
  -- function num : 0_8
  return (self.gridCfg).contain_obstacle
end

DynEffectGrid.IsAbandonEquipmentTower = function(self)
  -- function num : 0_9
  return (self.gridCfg).abandon_equipment
end

DynEffectGrid.GetGridAutoCareer = function(self)
  -- function num : 0_10
  return (self.gridCfg).auto_career
end

DynEffectGrid.GetGridPriority = function(self)
  -- function num : 0_11
  return (self.gridCfg).priority
end

DynEffectGrid.GetGridCareerPriority = function(self)
  -- function num : 0_12
  return (self.gridCfg).career_priority
end

DynEffectGrid.GetGridNecessaryFormulaValue = function(self, tab)
  -- function num : 0_13 , upvalues : _ENV
  local formulaFunc = (self.gridCfg).necessary
  if type(formulaFunc) ~= "function" then
    formulaFunc = (load("return function(tab) return " .. formulaFunc .. " end"))()
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.gridCfg).necessary = formulaFunc
  end
  local result = formulaFunc(tab)
  return result
end

DynEffectGrid.GetGridAttrFormulaValue = function(self, tab)
  -- function num : 0_14 , upvalues : _ENV
  local formulaFunc = (self.gridCfg).attr_formula
  if type(formulaFunc) ~= "function" then
    formulaFunc = (load("return function(tab) return " .. formulaFunc .. " end"))()
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.gridCfg).attr_formula = formulaFunc
  end
  local result = formulaFunc(tab)
  return result
end

DynEffectGrid.GetAutoIsMax = function(self)
  -- function num : 0_15
  return (self.gridCfg).auto_order
end

DynEffectGrid.IsMetalGearGrid = function(self)
  -- function num : 0_16
  do return (self.gridCfg).grid_show_type == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynEffectGrid.GetIsUncorverGrid = function(self)
  -- function num : 0_17
  return (self.gridCfg).isuncover
end

DynEffectGrid.GetCorverPriority = function(self)
  -- function num : 0_18
  return (self.gridCfg).cover_priority
end

DynEffectGrid.GetIsHaveLifeTime = function(self)
  -- function num : 0_19
  do return (self.gridCfg).duration > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynEffectGrid.GetDefaultLifeTime = function(self)
  -- function num : 0_20
  return (self.gridCfg).duration
end

DynEffectGrid.GetIsRelativeTypeGrid = function(self)
  -- function num : 0_21
  return (self.gridCfg).type_relative
end

return DynEffectGrid

