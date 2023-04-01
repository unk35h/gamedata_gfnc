-- params : ...
-- function num : 0 , upvalues : _ENV
local UICharacterDungeon = class("UICharacterDungeon", UIBaseWindow)
local base = UIBaseWindow
local CharDunConfig = require("Game.ActivityHeroGrow.ActivityCharDunConfig")
local cs_ResLoader = CS.ResLoader
UICharacterDungeon.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV
  self.resloader = (cs_ResLoader.Create)()
  ;
  (UIUtil.SetTopStatus)(self, self.__OnClickClose)
end

UICharacterDungeon.InitCharactorDungeonMain = function(self, heroGrowAct, enterSecotrFunc, closeCallback)
  -- function num : 0_1 , upvalues : CharDunConfig, _ENV
  self.closeCallback = closeCallback
  local frameId = heroGrowAct:GetActFrameId()
  if frameId == nil then
    return 
  end
  local data = (CharDunConfig.prefabCfg)[frameId]
  if isGameDev and data == nil then
    data = (CharDunConfig.prefabCfg)[(CharDunConfig.chaDunID).python]
    error("注：当前这个个人本UI是临时入口")
  end
  local charaDungeonNode = ((require(data.preClass)).New)(self)
  self.charaDungeonNode = charaDungeonNode
  local prefab = (self.resloader):LoadABAsset(PathConsts:GetCharDunPrefabPath(data.preName))
  local go = prefab:Instantiate((self.ui).tran_Holder)
  charaDungeonNode:Init(go)
  charaDungeonNode:InitCharaDungeonNode(heroGrowAct, enterSecotrFunc, self.resloader)
end

UICharacterDungeon.OnEnterHeroGrowSector = function(self, sectorId)
  -- function num : 0_2
  if self.charaDungeonNode ~= nil then
    (self.charaDungeonNode):OnEnterHeroGrowSector(sectorId)
  end
end

UICharacterDungeon.__OnClickClose = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:DeleteWindow(UIWindowTypeID.CharacterDungeon)
  if self.closeCallback ~= nil then
    (self.closeCallback)(false)
  end
end

UICharacterDungeon.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (self.charaDungeonNode):Delete()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UICharacterDungeon

