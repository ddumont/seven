local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs');
local nukes = require('behaviors.nukes');
local magic = require('magic');


local spell_levels = {};
spell_levels[packets.spells.STONE] = 1;
spell_levels[packets.spells.WATER] = 5;
spell_levels[packets.spells.AERO] = 9;
spell_levels[packets.spells.FIRE] = 13;
spell_levels[packets.spells.BLIZZARD] = 17;
spell_levels[packets.spells.THUNDER] = 21;
spell_levels[packets.spells.STONE_II] = 26;
spell_levels[packets.spells.WATER_II] = 30;
spell_levels[packets.spells.AERO_II] = 34;
spell_levels[packets.spells.FIRE_II] = 38;
spell_levels[packets.spells.BLIZZARD_II] = 42;
spell_levels[packets.spells.THUNDER_II] = 46;
spell_levels[packets.spells.STONE_III] = 51;
spell_levels[packets.spells.WATER_III] = 55;
spell_levels[packets.spells.AERO_III] = 59;
spell_levels[packets.spells.FIRE_III] = 62;
spell_levels[packets.spells.BLIZZARD_III] = 64;
spell_levels[packets.spells.THUNDER_III] = 66;
spell_levels[packets.spells.STONE_IV] = 68;
spell_levels[packets.spells.WATER_IV] = 70;
spell_levels[packets.spells.AERO_IV] = 72;
spell_levels[packets.spells.FIRE_IV] = 73;
spell_levels[packets.spells.BLIZZARD_IV] = 74;
spell_levels[packets.spells.THUNDER_IV] = 75;

spell_levels[packets.spells.STONEGA ]= 15;
spell_levels[packets.spells.WATERGA] = 19;
spell_levels[packets.spells.AEROGA] = 23;
spell_levels[packets.spells.FIRAGA] = 28;
spell_levels[packets.spells.BLIZZAGA] = 32;
spell_levels[packets.spells.THUNDAGA] = 36;
spell_levels[packets.spells.STONEGA_II] = 40;
spell_levels[packets.spells.WATERGA_II] = 44;
spell_levels[packets.spells.AEROGA_II] = 48;
spell_levels[packets.spells.FIRAGA_II] = 53;
spell_levels[packets.spells.BLIZZAGA_II] = 57;
spell_levels[packets.spells.THUNDAGA_II] = 61;
spell_levels[packets.spells.STONEGA_III] = 63;
spell_levels[packets.spells.WATERGA_III] = 65;
spell_levels[packets.spells.AEROGA_III] = 67;
spell_levels[packets.spells.FIRAGA_III] = 69;
spell_levels[packets.spells.BLIZZAGA_III] = 71;
spell_levels[packets.spells.THUNDAGA_III] = 73;

return {

  tick = function(self)
    if (actions.busy) then return end

  end,

  attack = function(self, tid)
  end,

  sleep = function(self, tid, aoe)
    actions:queue(actions:new():next(partial(magic.cast, magic, 'Sleep', tid)));
  end,

  nuke = function(self, tid)
    nukes:Nuke(tid, spell_levels);
  end

};
