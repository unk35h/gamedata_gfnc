-- params : ...
-- function num : 0 , upvalues : _ENV
MathUtil = {}
local bezierPool = (CommonPool.New)(function()
  -- function num : 0_0
  return {}
end
, function(p)
  -- function num : 0_1 , upvalues : _ENV
  while #p > 0 do
    (table.remove)(p)
  end
  return true
end
)
-- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

MathUtil.BezierN = function(t, p)
  -- function num : 0_2 , upvalues : bezierPool, _ENV
  if #p < 2 then
    return p[1]
  end
  local newp = bezierPool:PoolGet()
  for i = 1, #p - 1 do
    local p0p1 = p[i] * (1 - t) + p[i + 1] * t
    ;
    (table.insert)(newp, p0p1)
  end
  local result = (MathUtil.BezierN)(t, newp)
  bezierPool:PoolPut(newp)
  return result
end

-- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

MathUtil.GetIntersectWithLineAndPlane = function(self, point, direct, planeNormal, planePoint)
  -- function num : 0_3 , upvalues : _ENV
  local directNormal = (Vector3.Normalize)(direct)
  local result = (Vector3.Dot)(directNormal, planeNormal)
  if result == 0 then
    return nil
  end
  local d = (Vector3.Dot)(planePoint - point, planeNormal) / result
  return directNormal * d + point
end

local CrossV2 = function(a, b)
  -- function num : 0_4
  return a.x * b.y - b.x * a.y
end

-- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

MathUtil.SegmentsInterPointV2 = function(self, a, b, c, d)
  -- function num : 0_5 , upvalues : CrossV2, _ENV
  local ab = b - a
  local ac = c - a
  local ad = d - a
  local abXac = CrossV2(ab, ac)
  local abXad = CrossV2(ab, ad)
  if abXac * abXad >= 0 then
    return false
  end
  local cd = d - c
  local ca = a - c
  local cb = b - c
  local cdXca = CrossV2(cd, ca)
  local cdXcb = CrossV2(cd, cb)
  if cdXca * cdXcb >= 0 then
    return false
  end
  local t = CrossV2(ca, cd) / CrossV2(cd, b - a)
  local dx = t * (b.x - a.x)
  local dy = t * (b.y - a.y)
  local IntrPos = (Vector2.New)(a.x + dx, a.y + dy)
  return true, IntrPos
end


