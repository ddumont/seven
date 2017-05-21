require 'ffxi.recast';

local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');
local jwhm = require('jobs.whm');
local magic = require('magic');

local spells = packets.spells;
local status = packets.status;
local stoe = packets.stoe;

local spell_levels = {};
spell_levels[spells.KNIGHTS_MINNE] = 1;
spell_levels[spells.VALOR_MINUET] = 3;
spell_levels[spells.ARMYS_PAEON] = 5;
spell_levels[spells.FOE_REQUIEM] = 7;
spell_levels[spells.HERB_PASTORAL] = 9;
spell_levels[spells.LIGHTNING_THRENODY] = 10;
spell_levels[spells.SWORD_MADRIGAL] = 11;
spell_levels[spells.DARK_THRENODY] = 12;
spell_levels[spells.EARTH_THRENODY] = 14;
spell_levels[spells.ARMYS_PAEON_II] = 15;
spell_levels[spells.FOE_LULLABY] = 16;
spell_levels[spells.WATER_THRENODY] = 16;
spell_levels[spells.FOE_REQUIEM_II] = 17;
spell_levels[spells.WIND_THRENODY] = 18;
spell_levels[spells.FIRE_THRENODY] = 20;
spell_levels[spells.KNIGHTS_MINNE_II] = 21;
spell_levels[spells.ICE_THRENODY] = 22;
spell_levels[spells.VALOR_MINUET_II] = 23;
spell_levels[spells.LIGHTNING_THRENODY] = 24;
spell_levels[spells.MAGES_BALLAD] = 25;
spell_levels[spells.HORDE_LULLABY] = 27;
spell_levels[spells.MAGIC_FINALE] = 33;
spell_levels[spells.ARMYS_PAEON_III] = 35;
spell_levels[spells.FOE_REQUIEM_III] = 37;
spell_levels[spells.RAPTOR_MAZURKA] = 37;
spell_levels[spells.BATTLEFIELD_ELEGY] = 39;
spell_levels[spells.VALOR_MINUET_III] = 43;
spell_levels[spells.ARMYS_PAEON_IV] = 45;
spell_levels[spells.ICE_CAROL] = 46;
spell_levels[spells.FOE_REQUIEM_IV] = 47;
spell_levels[spells.BLADE_MADRIGAL] = 51;
spell_levels[spells.MAGES_BALLAD_II] = 55;
spell_levels[spells.FOE_REQUIEM_V] = 57;
spell_levels[spells.VICTORY_MARCH] = 60;
spell_levels[spells.ARMYS_PAEON_V] = 65;
spell_levels[spells.FOE_REQUIEM_VI] = 67;
spell_levels[spells.CHOCOBO_MAZURKA] = 73;

-- spells to effect
local stoe = {
  MAGES_BALLAD = status.EFFECT_BALLAD,
  MAGES_BALLAD_II = status.EFFECT_BALLAD,
  ARMYS_PAEON = status.EFFECT_PAEON,
  ARMYS_PAEON_II = status.EFFECT_PAEON,
  ARMYS_PAEON_III = status.EFFECT_PAEON,
  ARMYS_PAEON_IV = status.EFFECT_PAEON,
  ARMYS_PAEON_V = status.EFFECT_PAEON,
  RAPTOR_MAZURKA = status.EFFECT_MAZURKA,
  SWORD_MADRIGAL = status.EFFECT_MADRIGAL,
  BLADE_MADRIGAL = status.EFFECT_MADRIGAL,
  VICTORY_MARCH = status.EFFECT_MARCH,
  ADVANCING_MARCH = status.EFFECT_MARCH,
  ICE_CAROL = status.EFFECT_CAROL,
};

local jbrd = {
  spell_levels = spell_levels,
  stack_toggle = 0;
};

function jbrd:tick()
  local cnf = config:get();
  local tid = AshitaCore:GetDataManager():GetTarget():GetTargetServerId();
  if (cnf.ATTACK_TID and tid ~= cnf.ATTACK_TID) then
    cnf.ATTACK_TID = nil;
    AshitaCore:GetChatManager():QueueCommand("/follow " .. cnf.leader, 1);
  end

  if (actions.busy) then return end
  if (not(cnf.bard.sing)) then return end

  local status = party:GetBuffs(0);
  local statustbl = AshitaCore:GetDataManager():GetPlayer():GetStatusIcons();
  if (status[packets.status.EFFECT_INVISIBLE]) then return end

  if (not(not(cnf.bard.songvar1)) and ashita.ffxi.recast.get_spell_recast_by_index(spells[cnf.bard.songvar1]) == 0) then
    local need = not(status[stoe[cnf.bard.songvar1]]);
    if (not(need) and stoe[cnf.bard.songvar1] == stoe[cnf.bard.songvar2]) then
      local buffcount = 0;
      for slot = 0, 31, 1 do
        local buff = statustbl[slot];
        if (buff == stoe[cnf.bard.songvar1]) then
          buffcount = buffcount + 1;
        end
      end
      if (buffcount < 2) then
        need = true;
      end
    end
    if (cnf.bard.songvar1 and need) then
      if (buffs:CanCast(spells[cnf.bard.songvar1], spell_levels)) then
        actions.busy = true;
        actions:queue(actions:new()
        :next(partial(magic.cast, magic, '"' .. cnf.bard.song1 .. '"', '<me>'))
        :next(partial(wait, 7))
        :next(function(self) actions.busy = false; end));
        return;
      end
    end
  end

  if (not(not(cnf.bard.songvar2)) and ashita.ffxi.recast.get_spell_recast_by_index(spells[cnf.bard.songvar2]) == 0) then
    need = not(status[stoe[cnf.bard.songvar2]]);
    if (not(need) and stoe[cnf.bard.songvar1] == stoe[cnf.bard.songvar2]) then
      local buffcount = 0;
      for slot = 0, 31, 1 do
        local buff = statustbl[slot];
        if (buff == stoe[cnf.bard.songvar2]) then
          buffcount = buffcount + 1;
        end
      end
      if (buffcount < 2) then
        need = true;
      end
    end
    if (cnf.bard.songvar2 and need) then
      if (buffs:CanCast(spells[cnf.bard.songvar2], spell_levels)) then
        actions.busy = true;
        actions:queue(actions:new()
          :next(partial(magic.cast, magic, '"' .. cnf.bard.song2 .. '"', '<me>'))
          :next(partial(wait, 7))
          :next(function(self) actions.busy = false; end));
        return;
      end
    end
  end
end

function jbrd:attack(tid)
  local cnf = config:get();
  local action = actions:new();

  if (cnf['bard']['melee']) then
    action:next(function(self)
      AshitaCore:GetChatManager():QueueCommand('/attack ' .. tid, 0);
    end)
    :next(function(self)
      cnf.ATTACK_TID = tid;
      AshitaCore:GetChatManager():QueueCommand('/follow ' .. tid, 0);
    end)
    :next(partial(wait, 10));
  end

  if (buffs:CanCast(spells.BATTLEFIELD_ELEGY, spell_levels)) then
    actions.busy = true;
    action:next(partial(magic.cast, magic, '"Battlefield Elegy"', tid))
    :next(partial(wait, 7));
  end

  local spell = magic:highest('FOE_REQUIEM', spell_levels);
  if (spell) then
    actions.busy = true;
    action:next(partial(magic.cast, magic, '"' .. spell .. '"', tid))
      :next(partial(wait, 7));
  end

  local sub = AshitaCore:GetDataManager():GetPlayer():GetSubJob();
  if (sub == Jobs.WhiteMage and buffs:CanCast(spells.DIA, jwhm.spell_levels)) then
    actions.busy = true;
    action:next(partial(magic.cast, magic, 'Dia', tid))
      :next(partial(wait, 5));
  end

  if (buffs:CanCast(spells.LIGHTNING_THRENODY, spell_levels)) then
    actions.busy = true;
    action:next(partial(magic.cast, magic, '"Ltng. Threnody"', tid))
      :next(partial(wait, 7));
  end
  action:next(function(self) actions.busy = false; end);
  actions:queue(action);
end

function jbrd:sleep(tid, aoe)
  if (not(aoe) and magic:can(spells.FOE_LULLABY, spell_levels)) then
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, '"Foe Lullaby"', tid))
      :next(partial(wait, 7)));
  elseif (aoe and magic:can(spells.HORDE_LULLABY, spell_levels)) then
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, '"Horde Lullaby"', tid))
      :next(partial(wait, 7)));
  end
end

function jbrd:bard(bard, command, song, silent)
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
    elseif (command == 'run') then
      jbrd:bard(bard, '1', 'raptor mazurka', true);
      jbrd:bard(bard, '2', 'chocobo mazurka');
      return;
    elseif (command == 'sustain') then
      jbrd:bard(bard, '1', "mage's ballad ii", true);
      jbrd:bard(bard, '2', "army's paeon v");
      return;
    elseif (command == 'mana') then
      jbrd:bard(bard, '1', "mage's ballad ii", true);
      jbrd:bard(bard, '2', "mage's ballad");
      return;
    elseif (command == 'melee') then
      brd['melee'] = not(brd['melee']);
    end
    config:save();
  end

  if (not(silent)) then
    local msg = "I'm a ";
    if (brd['melee']) then
      msg = msg .. 'MELEE ';
    end
    msg = msg .. 'Bard!\nsinging: ' .. onoff .. '\n1: ' .. song1 .. '\n2: ' .. song2;
    AshitaCore:GetChatManager():QueueCommand('/l2 ' .. msg, 1);
  end
end

return jbrd;
