-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoTagListNode = class("UINWarChessInfoTagListNode", base)
local UINWarChessInfoMonsterGroupTag = require("Game.WarChess.UI.Info.Info.UINWarChessInfoMonsterGroupTag")
UINWarChessInfoTagListNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessInfoMonsterGroupTag
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.tagItemPool = (UIItemPool.New)(UINWarChessInfoMonsterGroupTag, (self.ui).tag)
  self.colors = {(self.ui).easy, (self.ui).normal, (self.ui).challgenge}
end

UINWarChessInfoTagListNode.SetWCIIMonsterTag = function(self, monsterData, isMonster)
  -- function num : 0_1 , upvalues : _ENV
  (self.tagItemPool):HideAll()
  if not monsterData or not isMonster then
    return false
  end
  local battleRoomID = monsterData:GetBattleRoomID()
  if battleRoomID ~= nil then
    local mosterGroupTag = ((ConfigData.warchess_room_monster)[battleRoomID]).tag_des
    local monsterGroupTagType = ((ConfigData.warchess_room_monster)[battleRoomID]).tag_type
    if monsterGroupTagType == nil then
      monsterGroupTagType = {}
    end
    local tagIndex = 0
    local tagType = 1
    for _,groupTag in pairs(mosterGroupTag) do
      if groupTag ~= nil then
        tagIndex = tagIndex + 1
        tagType = monsterGroupTagType[tagIndex]
        if type(tagType) ~= "number" or tagType < 1 then
          tagType = 1
        else
          if tagType > 3 then
            tagType = 3
          end
        end
        local item = (self.tagItemPool):GetOne()
        item:InitEnemyTagItem((LanguageUtil.GetLocaleText)(groupTag), (self.colors)[tagType])
        item:Show()
      end
    end
  end
end

UINWarChessInfoTagListNode.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoTagListNode

