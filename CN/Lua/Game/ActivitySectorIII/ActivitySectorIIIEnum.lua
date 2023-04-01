-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivitySectorIIIEnum = {}
ActivitySectorIIIEnum.eActRedDotTypeId = {task = "task", tech = "tech", map = "map"}
ActivitySectorIIIEnum.eActRedDotIsRedType = {[(ActivitySectorIIIEnum.eActRedDotTypeId).task] = true}
return ActivitySectorIIIEnum

