-- params : ...
-- function num : 0 , upvalues : _ENV
local RenameHelper = {}
RenameHelper.GetNameLength = function(self, targetString)
  -- function num : 0_0 , upvalues : _ENV
  if targetString == nil then
    return nil
  end
  if (string.IsNullOrEmpty)(targetString) then
    return 0
  end
  local length = 0
  local iByte = 1
  while 1 do
    local currentByte = (string.byte)(targetString, iByte)
    local byteCount = 1
    local lengthCount = 2
    if currentByte > 239 then
      byteCount = 4
    else
      if currentByte > 223 then
        byteCount = 3
      else
        if currentByte > 127 then
          byteCount = 2
        else
          byteCount = 1
          lengthCount = 1
        end
      end
    end
    iByte = iByte + byteCount
    length = length + lengthCount
  end
  do
    if #targetString >= iByte then
      return length
    end
  end
end

RenameHelper.ClampNameInLength = function(self, targetString, lengthLimit)
  -- function num : 0_1 , upvalues : _ENV
  if targetString == nil or type(lengthLimit) ~= "number" then
    return nil
  end
  if (string.IsNullOrEmpty)(targetString) or lengthLimit == 0 then
    return ""
  end
  local length = 0
  local iByte = 1
  while 1 do
    local currentByte = (string.byte)(targetString, iByte)
    local byteCount = 1
    local lengthCount = 2
    if currentByte > 239 then
      byteCount = 4
    else
      if currentByte > 223 then
        byteCount = 3
      else
        if currentByte > 127 then
          byteCount = 2
        else
          byteCount = 1
          lengthCount = 1
        end
      end
    end
    length = length + lengthCount
    if lengthLimit < length then
      return (string.sub)(targetString, 1, iByte - 1)
    end
    iByte = iByte + byteCount
  end
  do
    if #targetString >= iByte then
      return length
    end
  end
end

return RenameHelper

