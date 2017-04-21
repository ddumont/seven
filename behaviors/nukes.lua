local party = require('party');
local config = require('config');
local actions = require('actions');
local packets = require('packets');

local spells = packets.spells;
local status = packets.status;
return {

  -- Can the player cast this spell?
  -- @param the spell id
  -- @param the spell level table
  CanCast = function(self, spell, levels)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local lvl = AshitaCore:GetDataManager():GetParty():GetMemberMainJobLevel(0);
    return player:HasSpell(spell) and levels[spell] ~= nil and lvl >= levels[spell];
  end,

  -- cast nuke on target
  -- @param table of spell levels
  Nuke = function(self, tid, levels)
    local names = {'THUNDER','BLIZZARD','FIRE','AERO','WATER','STONE'};
    local strengths = {'IV','III','II',''};
    local waits = {12,6,4,2};

    for i, strength in ipairs(strengths) do
      for j, name in ipairs(names) do
        local key = name;
        local spell = name;
        if (strength ~= '') then
          key = key .. '_' .. strength;
          spell = spell .. ' ' .. strength;
        end

        if (self:CanCast(spells[key], levels)) then
          actions.busy = true;
          actions:queue(actions:new()
            :next(partial(magic, '"' .. spell .. '"', tid))
            :next(partial(wait, waits[i]))
            :next(function(self) actions.busy = false; end));
          return;
        end
      end
    end
  end

};
