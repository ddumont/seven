local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spell_levels = {};


local jsmn = {
  spell_levels = spell_levels,
};

function jsmn:tick()

end

function jsmn:attack(tid)

end

return jsmn;
