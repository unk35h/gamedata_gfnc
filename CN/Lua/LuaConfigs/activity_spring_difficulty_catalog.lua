-- params : ...
-- function num : 0 , upvalues : _ENV
local activity_spring_difficulty_catalog = {
[101] = {catalog_des = 219869}
, 
[102] = {catalog_id = 102}
, 
[103] = {catalog_des = 53698, catalog_id = 103}
, 
[104] = {catalog_id = 104}
, 
[105] = {catalog_des = 343550, catalog_id = 105}
, 
[106] = {catalog_des = 112905, catalog_id = 106}
, 
[107] = {catalog_des = 43523, catalog_id = 107}
, 
[108] = {catalog_des = 125888, catalog_id = 108}
, 
[201] = {catalog_des = 519055, catalog_id = 201}
, 
[202] = {catalog_id = 202}
, 
[203] = {catalog_des = 343550, catalog_id = 203}
, 
[204] = {catalog_id = 204}
, 
[205] = {catalog_des = 129840, catalog_id = 205}
, 
[206] = {catalog_des = 112905, catalog_id = 206}
, 
[207] = {catalog_des = 12622, catalog_id = 207}
, 
[208] = {catalog_des = 125888, catalog_id = 208}
, 
[301] = {catalog_des = 257233, catalog_id = 301}
, 
[302] = {catalog_id = 302}
, 
[303] = {catalog_des = 450593, catalog_id = 303}
, 
[304] = {catalog_id = 304}
, 
[305] = {catalog_des = 98939, catalog_id = 305}
, 
[306] = {catalog_des = 112905, catalog_id = 306}
, 
[307] = {catalog_des = 323200, catalog_id = 307}
, 
[308] = {catalog_des = 125888, catalog_id = 308}
, 
[401] = {catalog_des = 22797, catalog_id = 401}
, 
[402] = {catalog_id = 402}
, 
[403] = {catalog_des = 216157, catalog_id = 403}
, 
[404] = {catalog_id = 404}
, 
[405] = {catalog_des = 2447, catalog_id = 405}
, 
[406] = {catalog_des = 112905, catalog_id = 406}
, 
[407] = {catalog_des = 88764, catalog_id = 407}
, 
[408] = {catalog_des = 125888, catalog_id = 408}
, 
[501] = {catalog_des = 450593, catalog_id = 501}
, 
[502] = {catalog_id = 502}
, 
[503] = {catalog_des = 98939, catalog_id = 503}
, 
[504] = {catalog_id = 504}
, 
[505] = {catalog_des = 88764, catalog_id = 505}
, 
[506] = {catalog_des = 112905, catalog_id = 506}
, 
[507] = {catalog_des = 175081, catalog_id = 507}
, 
[508] = {catalog_des = 125888, catalog_id = 508}
, 
[601] = {catalog_des = 333375, catalog_id = 601}
, 
[602] = {catalog_id = 602}
, 
[603] = {catalog_des = 323200, catalog_id = 603}
, 
[604] = {catalog_id = 604}
, 
[605] = {catalog_des = 495834, catalog_id = 605}
, 
[606] = {catalog_des = 112905, catalog_id = 606}
, 
[607] = {catalog_des = 57863, catalog_id = 607}
, 
[608] = {catalog_des = 125888, catalog_id = 608}
, 
[609] = {catalog_des = 375244, catalog_id = 609}
, 
[610] = {catalog_des = 499966, catalog_id = 610}
, 
[611] = {catalog_des = 369645, catalog_id = 611}
, 
[612] = {catalog_des = 224528, catalog_id = 612}
}
local __default_values = {catalog_des = 360354, catalog_id = 101}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in pairs(activity_spring_difficulty_catalog) do
  setmetatable(v, base)
end
local __rawdata = {__basemetatable = base}
setmetatable(activity_spring_difficulty_catalog, {__index = __rawdata})
return activity_spring_difficulty_catalog

