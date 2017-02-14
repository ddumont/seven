local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spell_levels = {};

return {

  tick = function(self)
    if (actions.busy) then return end

  end

};
