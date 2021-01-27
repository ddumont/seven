require 'ffxi.recast';

local party = require('party');
local config = require('config');
local actions = require('actions');
local magic = require('magic');
local util = require('util');
local packets = require('packets');

local spells = packets.spells;
local status = packets.status;

local buffs = {};

-- Can the player cast this spell?
-- @param the spell id
-- @param the spell level table
function buffs:CanCast(spell, levels, isSub)
  local iparty = AshitaCore:GetDataManager():GetParty();
  local player = AshitaCore:GetDataManager():GetPlayer();
  local lvl = iparty:GetMemberMainJobLevel(0);
  if (isSub) then
    lvl = ipary:GetMemberSubJobLevel(0);
  end
  return player:HasSpell(spell) and levels[spell] ~= nil and lvl >= levels[spell];
end

-- Can the player use this ability?
-- @param the ability id
-- @param the ability level table
-- @param true/false on checking for SUBJOB
function buffs:IsAble(ability, levels, isSub)
  local lvl = util:JobLvlCheck(isSub);
  return levels[ability] ~= nil and lvl >= levels[ability];
end

-- Scans the party (including the current player) for those needing heals
-- @param status effect buff to check
-- @returns list of party indicies needing buff
function buffs:NeedBuff(buff, ...)
  local need = {};
  local iparty = AshitaCore:GetDataManager():GetParty();
  local zone = iparty:GetMemberZone(0);
  local exclude_classes = {...};
  local exclude = {}; -- turn into a map
  for i = 1, #exclude_classes do
    exclude[exclude_classes[i]] = true;
  end

  party:PartyBuffs(function(i, buffs, pid)
    if (i == 0) then return end
    local idx = party:ById(pid);
    local samez = zone == iparty:GetMemberZone(idx);
    local alive = iparty:GetMemberCurrentHPP(idx) > 0;
    if (alive and samez and buffs[buff] == nil) then
      if (exclude[iparty:GetMemberMainJob(idx)] ~= true) then
        table.insert(need, pid);
      end
    end
  end);

  if (#need == 0) then
    local alive = iparty:GetMemberCurrentHPP(0) > 0;
    if (alive and party:GetBuffs(0)[buff] == nil) then
      table.insert(need, GetPlayerEntity().ServerId);
    end
  end
  return need;
end

-- Scans the party (including the current player) for those needing heals
-- @param status effect buff to check
-- @returns list of party indicies needing buff
function buffs:NeedCleanse(status)
  local need = {};
  local iparty = AshitaCore:GetDataManager():GetParty();
  local zone = iparty:GetMemberZone(0);
  party:PartyBuffs(function(i, buffs, pid)
    local idx = party:ById(pid);
    local samez = zone == iparty:GetMemberZone(idx);
    local alive = iparty:GetMemberCurrentHPP(idx) > 0;
    if (alive and samez and buffs[status] ~= nil) then
      table.insert(need, pid);
    end
  end);
  return need;
end

-- cast idle buffs
-- @param table of spell levels
function buffs:IdleBuffs(levels)
  if (not(config:get())) then return end
  if (config:get()['IdleBuffs'] ~= true) then return end

  local need = buffs:NeedBuff(status.EFFECT_PROTECT);
  if (#need > 0) then
    local strengths = {'IV','III','II',''};
    local waits = {6,5,4,3};

    for i, strength in ipairs(strengths) do
      local key = 'PROTECTRA';
      local spell = 'Protectra';
      if (strength ~= '') then
        key = key .. '_' .. strength;
        spell = spell .. ' ' .. strength;
      end

      if (buffs:CanCast(spells[key], levels)) then
        actions.busy = true;
        actions:queue(actions:new()
        :next(partial(magic.cast, magic, '"' .. spell .. '"', '<me>'))
        :next(partial(wait, waits[i]))
        :next(function(self) actions.busy = false; end));
        return true;
      end
    end
  end

  need = buffs:NeedBuff(status.EFFECT_SHELL);
  if (#need > 0) then
    local strengths = {'IV','III','II',''};
    local waits = {6,5,4,3};

    for i, strength in ipairs(strengths) do
      local key = 'SHELLRA';
      local spell = 'Shellra';
      if (strength ~= '') then
        key = key .. '_' .. strength;
        spell = spell .. ' ' .. strength;
      end

      if (buffs:CanCast(spells[key], levels)) then
        actions.busy = true;
        actions:queue(actions:new()
        :next(partial(magic.cast, magic, '"' .. spell .. '"', '<me>'))
        :next(partial(wait, waits[i]))
        :next(function(self) actions.busy = false; end));
        return true;
      end
    end
  end

  if (config:get().ATTACK_TID ~= nil) then
    need = buffs:NeedBuff(status.EFFECT_AUSPICE);
    if (#need > 0 and buffs:CanCast(spells.AUSPICE, levels)) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic.cast, magic, 'Auspice', '<me>'))
        :next(partial(wait, 4))
        :next(function(self) actions.busy = false; end));
      return true;
    end
  end

  if (AshitaCore:GetDataManager():GetParty():GetMemberCurrentMPP(0) < 70) then return end
  -- local mybuffs = party:GetBuffs(0);
  -- if (buffs:CanCast(spells.STONESKIN, levels) and mybuffs[status.EFFECT_STONESKIN] == nil) then
  --   actions.busy = true;
  --   actions:queue(actions:new()
  --     :next(partial(magic.cast, magic, 'Stoneskin', '<me>'))
  --     :next(partial(wait, 16))
  --     :next(function(self) actions.busy = false; end));
  --   return true;
  -- end
end

function buffs:Cleanse(levels)
  local iparty = AshitaCore:GetDataManager():GetParty();
  local need = buffs:NeedCleanse(status.EFFECT_POISON);
  if (buffs:CanCast(spells.POISONA, levels) and #need > 0) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, 'Poisona', need[math.random(#need)]))
      :next(partial(wait, 8))
      :next(function(self) actions.busy = false; end));
    return true;
  end
  need = buffs:NeedCleanse(status.EFFECT_BLINDNESS);
  if (buffs:CanCast(spells.BLINDNA, levels) and #need > 0) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, 'Blindna', need[math.random(#need)]))
      :next(partial(wait, 8))
      :next(function(self) actions.busy = false; end));
    return true;
  end
  need = buffs:NeedCleanse(status.EFFECT_PARALYSIS);
  if (buffs:CanCast(spells.PARALYNA, levels) and #need > 0) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, 'Paralyna', need[math.random(#need)]))
      :next(partial(wait, 8))
      :next(function(self) actions.busy = false; end));
    return true;
  end
  need = buffs:NeedCleanse(status.EFFECT_CURSE_I);
  if (buffs:CanCast(spells.CURSNA, levels) and #need > 0) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, 'Cursna', need[math.random(#need)]))
      :next(partial(wait, 8))
      :next(function(self) actions.busy = false; end));
    return true;
  end
  need = buffs:NeedCleanse(status.EFFECT_CURSE_II);
  if (buffs:CanCast(spells.CURSNA, levels) and #need > 0) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, 'Cursna', need[math.random(#need)]))
      :next(partial(wait, 8))
      :next(function(self) actions.busy = false; end));
    return true;
  end
  need = buffs:NeedCleanse(status.EFFECT_PETRIFICATION);
  if (buffs:CanCast(spells.STONA, levels) and #need > 0) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, 'Stona', need[math.random(#need)]))
      :next(partial(wait, 8))
      :next(function(self) actions.busy = false; end));
    return true;
  end
end

function buffs:SneakyTime(levels)
  if (config:get()['SneakyTime'] ~= true) then return end
  local iparty = AshitaCore:GetDataManager():GetParty();
  if (iparty:GetMemberCurrentMPP(0) < 15) then return end

  local need = buffs:NeedBuff(status.EFFECT_SNEAK, Jobs.WhiteMage);
  if (buffs:CanCast(spells.SNEAK, levels) and #need > 0) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, 'Sneak', need[math.random(#need)]))
      :next(partial(wait, 8))
      :next(function(self) actions.busy = false; end));
    return true;
  end
  need = buffs:NeedBuff(status.EFFECT_INVISIBLE, Jobs.WhiteMage);
  if (buffs:CanCast(spells.INVISIBLE, levels) and #need > 0) then
    -- print('need invis ' .. ashita.settings.JSON:encode_pretty(need, nil, { pretty = true, align_keys = false, indent = '    ' }));
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(magic.cast, magic, 'Invisible', need[math.random(#need)]))
      :next(partial(wait, 12))
      :next(function(self) actions.busy = false; end));
    return true;
  end
end

function buffs:AbilityOnCD(abilityName)
  local r = AshitaCore:GetResourceManager();
  local onCD = false;
  for x = 0, 31 do
    if (ashita.ffxi.recast.get_ability_recast_by_index(x) > 0) then
      local ability = r:GetAbilityByTimerId(ashita.ffxi.recast.get_ability_id_from_index(x));
      if (ability.Name[0] == abilityName) then
        onCD = true;
      end
    end
  end
  return onCD;
end

return buffs;
