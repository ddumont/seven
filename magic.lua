local util = require('util');
local packets = require('packets');
local spells = packets.spells;
local status = packets.status;

local magic = {};

local ranks = {'', 'II', 'III', 'IV', 'V', 'VI', 'VII'};

function magic:cast(spell, target)
  AshitaCore:GetChatManager():QueueCommand('/magic ' .. spell .. ' ' .. target, 0);
end

function magic:highest(names, levels, maxrank)
  if (type(names) == 'string') then
    names = {names};
  end
  if (maxrank == nil or maxrank > 7) then
    maxrank = #ranks;
  end

  for i = #ranks, 1, -1 do
    local rank = ranks[i];
    for j, name in ipairs(names) do
      local key = name;
      local spell = name:gsub("_", " ");
      if (strength ~= '') then
        key = key .. '_' .. rank;
        spell = spell .. ' ' .. rank;
      end

      if (spells[key] and magic:can(spells[key], levels)) then
        return spell, i, spells[key];
      end
    end
  end
end

-- Can the player cast this spell?
-- @param the spell id
-- @param the spell level table
-- @param true/false on checking for SUBJOB
function magic:can(spell, levels, isSub)
  local iparty = AshitaCore:GetDataManager():GetParty();
  local player = AshitaCore:GetDataManager():GetPlayer();
  local lvl = util:JobLvlCheck(isSub);
  if (isSub) then
    lvl = ipary:GetMemberSubJobLevel(0);
  end
  return player:HasSpell(spell) and levels[spell] ~= nil and lvl >= levels[spell];
end

return magic;
