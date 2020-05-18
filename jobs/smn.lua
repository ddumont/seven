local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');
local magic = require('magic');

local spell_levels = {};


local jsmn = {
  spell_levels = spell_levels,
};

function jsmn:tick()
  if (actions.busy) then return end

  local player = AshitaCore:GetDataManager():GetPlayer();
  local cnf = config:get();
  local smn = cnf['summoner'];
  local mana = AshitaCore:GetDataManager():GetParty():GetMemberCurrentMP(0);

  if (player and mana > 50 and smn['practice']) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, 'ifrit', '<me>'))
      :next(partial(wait, 14))
      :next(function(self)
        AshitaCore:GetChatManager():QueueCommand('/ja release <me>', 0);
      end)
      :next(partial(wait, 4))
      :next(function(self) actions.busy = false; end));
    return;
  end
end

function jsmn:attack(tid)

end

function jsmn:summoner(self, command, arg)
  local cnf = config:get();
  local smn = cnf['summoner'];
  local onoff = smn['practice'] and 'on' or 'off';

  if (command ~= nil) then
    if (command == 'practice' and (arg == 'on' or arg == 'true')) then
      smn['practice'] = true;
      onoff = 'on';
    elseif (command == 'practice' and (arg == 'off' or arg == 'false')) then
      smn['practice'] = false;
      onoff = 'off';
    end
    config:save();
  end
end

return jsmn;
