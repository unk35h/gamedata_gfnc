-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoMonsterGroupTag = class("UINWarChessInfoMonsterGroupTag", base)
UINWarChessInfoMonsterGroupTag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessInfoMonsterGroupTag.InitEnemyTagItem = function(self, tagTex, color)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_tag).text = tagTex
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  if color ~= nil then
    ((self.ui).image_tag).color = color
  end
end

UINWarChessInfoMonsterGroupTag.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoMonsterGroupTag

