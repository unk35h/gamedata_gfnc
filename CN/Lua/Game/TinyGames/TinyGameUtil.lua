-- params : ...
-- function num : 0 , upvalues : _ENV
local TinyGameUtil = {}
TinyGameUtil.CreateMineTinyGameGrade = function(maxScore)
  -- function num : 0_0 , upvalues : _ENV
  local mineGrade = {}
  mineGrade.name = PlayerDataCenter:GetSelfName()
  mineGrade.uid = PlayerDataCenter:GetSelfId()
  mineGrade.score = maxScore or 0
  return mineGrade
end

TinyGameUtil.CreateFriendTinyGameDatas = function(cat, gameId)
  -- function num : 0_1 , upvalues : _ENV
  if not (PlayerDataCenter.friendDataCenter):IsFriendDataCenterInited() then
    return {}
  end
  local friendsData = (PlayerDataCenter.friendDataCenter):GetFreindList()
  if friendsData == nil or #friendsData <= 0 then
    return {}
  end
  local allGrades = {}
  for _,v in ipairs(friendsData) do
    local eachFriendGrade = {}
    eachFriendGrade.name = v:GetUserName()
    eachFriendGrade.score = 0
    eachFriendGrade.uid = v:GetUserUID()
    local tinyGame = v:GetTinyGameData(cat, gameId)
    if tinyGame ~= nil then
      eachFriendGrade.score = tinyGame.score
    end
    ;
    (table.insert)(allGrades, eachFriendGrade)
  end
  return allGrades
end

TinyGameUtil.SortTinyGameRankDatas = function(allFriendData, mineGrade)
  -- function num : 0_2 , upvalues : _ENV
  if #allFriendData > 1 then
    (table.sort)(allFriendData, function(a, b)
    -- function num : 0_2_0
    if a.uid >= b.uid then
      do return a.score ~= b.score end
      do return b.score < a.score end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
)
  end
  if mineGrade == nil then
    return 0
  end
  local myRank = 0
  for index,data in pairs(allFriendData) do
    if data == mineGrade then
      myRank = index
    end
  end
  return myRank
end

return TinyGameUtil

