local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');
local jwhm = require('jobs.whm');

local spells = packets.spells;
local stoe = packets.stoe;

local spell_levels = {};
spell_levels[packets.spells.KNIGHTS_MINNE] = 1;
spell_levels[packets.spells.VALOR_MINUET] = 3;
spell_levels[packets.spells.ARMYS_PAEON] = 5;
spell_levels[packets.spells.FOE_REQUIEM] = 7;
spell_levels[packets.spells.HERB_PASTORAL] = 9;
spell_levels[packets.spells.LIGHTNING_THRENODY] = 10;
spell_levels[packets.spells.DARK_THRENODY] = 12;
spell_levels[packets.spells.EARTH_THRENODY] = 14;
spell_levels[packets.spells.ARMYS_PAEON_II] = 15;
spell_levels[packets.spells.FOE_LULLABY] = 16;
spell_levels[packets.spells.WATER_THRENODY] = 16;
spell_levels[packets.spells.FOE_REQUIEM_II] = 17;
spell_levels[packets.spells.WIND_THRENODY] = 18;
spell_levels[packets.spells.FIRE_THRENODY] = 20;
spell_levels[packets.spells.KNIGHTS_MINNE_II] = 21;
spell_levels[packets.spells.ICE_THRENODY] = 22;
spell_levels[packets.spells.VALOR_MINUET_II] = 23;
spell_levels[packets.spells.LIGHTNING_THRENODY] = 24;
spell_levels[packets.spells.MAGES_BALLAD] = 25;
spell_levels[packets.spells.MAGIC_FINALE] = 33;
spell_levels[packets.spells.ARMYS_PAEON_III] = 35;
spell_levels[packets.spells.FOE_REQUIEM_III] = 37;
spell_levels[packets.spells.RAPTOR_MAZURKA] = 37;
spell_levels[packets.spells.VALOR_MINUET_III] = 43;
spell_levels[packets.spells.ARMYS_PAEON_IV] = 45;
spell_levels[packets.spells.FOE_REQUIEM_IV] = 47;
spell_levels[packets.spells.MAGES_BALLAD_II] = 55;
spell_levels[packets.spells.CHOCOBO_MAZURKA] = 73;


return {
  spell_levels = spell_levels,

  tick = function(self)
    if (actions.busy) then return end

    local cnf = config:get();
    if (not(cnf.bard.sing)) then return end

    local status = party:GetBuffs(0);
    if (status[packets.status.EFFECT_INVISIBLE]) then return end

    if (cnf.bard.songvar1 and not(status[stoe[cnf.bard.songvar1]])) then
      if (buffs:CanCast(spells[cnf.bard.songvar1], spell_levels)) then
        actions.busy = true;
        actions:queue(actions:new()
          :next(partial(magic, '"' .. cnf.bard.song1 .. '"', '<me>'))
          :next(partial(wait, 7))
          :next(function(self) actions.busy = false; end));
        return;
      end
    end

    if (cnf.bard.songvar2 and not(status[stoe[cnf.bard.songvar2]])) then
      if (buffs:CanCast(spells[cnf.bard.songvar2], spell_levels)) then
        actions.busy = true;
        actions:queue(actions:new()
          :next(partial(magic, '"' .. cnf.bard.song2 .. '"', '<me>'))
          :next(partial(wait, 7))
          :next(function(self) actions.busy = false; end));
        return;
      end
    end
  end,

  attack = function(self, tid)
    local action = actions:new();

    local strengths = {'III','II',''};
    for i, strength in ipairs(strengths) do
      local key = 'FOE_REQUIEM'
      local spell = 'FOE REQUIEM';
      if (strength ~= '') then
        key = key .. '_' .. strength;
        spell = spell .. ' ' .. strength;
      end
      if (buffs:CanCast(spells[key], spell_levels)) then
        actions.busy = true;
        actions:queue(actions:new()
          :next(partial(magic, '"' .. spell .. '"', tid))
          :next(partial(wait, 7))
          :next(function(self) actions.busy = false; end));
        break;
      end
    end

    local sub = AshitaCore:GetDataManager():GetPlayer():GetSubJob();
    if (sub == Jobs.WhiteMage and buffs:CanCast(spells.DIA, jwhm.spell_levels)) then
      action:next(partial(magic, 'Dia', tid))
        :next(partial(wait, 4));
    end

    if (buffs:CanCast(spells.ICE_THRENODY, spell_levels)) then
      action:next(partial(magic, '"Ice Threnody"', tid))
        :next(partial(wait, 7));
    end

    actions:queue(action);
  end,

  sleep = function(self, tid)
    if (buffs:CanCast(spells.FOE_LULLABY, spell_levels)) then
      actions:queue(actions:new()
        :next(partial(magic, '"Foe Lullaby"', tid))
        :next(partial(wait, 7)));
    end
  end,

  bard = function(self, bard, command, song)
    local cnf = config:get();
    local brd = cnf['bard'];
    local onoff = brd['sing'] and 'on' or 'off';
    local song1 = brd['song1'] or 'none';
    local song2 = brd['song2'] or 'none';

    local songvar;
    if(song ~= nil) then
      songvar = song:upper():gsub("'", ""):gsub(" ", "_");
    end

    if (command ~= nil) then
      if (command == 'on' or command == 'true') then
        brd['sing'] = true;
        onoff = 'on';
      elseif (command == 'off' or command == 'false') then
        brd['sing'] = false;
        onoff = 'off';
      elseif (command == '1' and song and spells[songvar]) then
        brd['song1'] = song;
        brd['songvar1'] = songvar;
        song1 = song;
      elseif (command == '2' and song and spells[songvar]) then
        brd['song2'] = song;
        brd['songvar2'] = songvar;
        song2 = song;
      elseif (command =='1' and song == 'none') then
        brd['song1'] = nil;
        brd['songvar1'] = nil;
        song1 = 'none';
      elseif (command =='2' and song == 'none') then
        brd['song2'] = nil;
        brd['songvar2'] = nil;
        song2 = 'none';
      end
      config:save();
    end

    AshitaCore:GetChatManager():QueueCommand('/l2 I\'m a Bard!\nsinging: ' .. onoff .. '\n1: ' .. song1 .. '\n2: ' .. song2, 1);
  end
};
