-- params : ...
-- function num : 0 , upvalues : _ENV
local WCInteractClassDic = {}
local eWCInteractType = require("Game.WarChess.Interact.Base.eWCInteractType")
WCInteractClassDic[eWCInteractType.born] = require("Game.WarChess.Interact.WCI_Born")
WCInteractClassDic[eWCInteractType.battle] = require("Game.WarChess.Interact.WCI_Battle")
WCInteractClassDic[eWCInteractType.gridIntr] = require("Game.WarChess.Interact.WCI_ShowInfo")
WCInteractClassDic[eWCInteractType.pickRes] = require("Game.WarChess.Interact.WCI_PickRes")
WCInteractClassDic[eWCInteractType.switch] = require("Game.WarChess.Interact.WCI_Switch")
WCInteractClassDic[eWCInteractType.store] = require("Game.WarChess.Interact.WCI_Store")
WCInteractClassDic[eWCInteractType.standSwitch] = require("Game.WarChess.Interact.WCI_StandSwitch")
WCInteractClassDic[eWCInteractType.pushBox] = require("Game.WarChess.Interact.WCI_PushBox")
WCInteractClassDic[eWCInteractType.cannonFire] = require("Game.WarChess.Interact.WCI_Cannon")
WCInteractClassDic[eWCInteractType.rougeDoorIntr] = require("Game.WarChess.Interact.WCI_LobbyDoorInfo")
WCInteractClassDic[eWCInteractType.wcsSave] = require("Game.WarChess.Interact.WCI_Save")
WCInteractClassDic[eWCInteractType.infoWithoutTeam] = require("Game.WarChess.Interact.WCI_ShowInfoWhitoutTeam")
return WCInteractClassDic

