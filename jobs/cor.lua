local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');
local jdnc = require('jobs.dnc');
local jbrd = require('jobs.brd');

local spells = packets.spells;
local stoe = packets.stoe;
local abilities = packets.abilities;

local ability_levels = {};
ability_levels[abilities.CORSAIRS_ROLL] = 5;
ability_levels[abilities.NINJA_ROLL] = 8;
ability_levels[abilities.HUNTERS_ROLL] = 11;
ability_levels[abilities.CHAOS_ROLL] = 14;
ability_levels[abilities.MAGUSS_ROLL] = 17;
ability_levels[abilities.HEALERS_ROLL] = 20;
ability_levels[abilities.DRACHEN_ROLL] = 23;
ability_levels[abilities.CHORAL_ROLL] = 26;
ability_levels[abilities.MONKS_ROLL] = 31;
ability_levels[abilities.BEAST_ROLL] = 34;
ability_levels[abilities.SAMURAI_ROLL] = 37;
ability_levels[abilities.EVOKERS_ROLL] = 40;
ability_levels[abilities.ROGUES_ROLL] = 43;
ability_levels[abilities.WARLOCKS_ROLL] = 46;
ability_levels[abilities.FIGHTERS_ROLL] = 49;
ability_levels[abilities.PUPPET_ROLL] = 52;
ability_levels[abilities.GALLANTS_ROLL] = 55;
ability_levels[abilities.WIZARDS_ROLL] = 58;
ability_levels[abilities.DANCERS_ROLL] = 61;
ability_levels[abilities.SCHOLARS_ROLL] = 64;

local jcor = {
  ability_levels = ability_levels
};

function jcor:tick()
  if (actions.busy) then return end

  local status = party:GetBuffs(0);
  if (status[packets.status.EFFECT_INVISIBLE]) then return end

  -- CORSAIR ROLLS - TO BE FIXED TO RE-ROLL FOR DOUBLE UPS --
  local cnf = config:get();
  if (cnf.corsair.rollvar1 and not(status[stoe[cnf.corsair.rollvar1]])) then
    if (buffs:IsAble(abilities[cnf.corsair.rollvar1], ability_levels)) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(ability, '"' .. cnf.corsair.roll1 .. '"', '<me>'))
        :next(partial(wait, 7))
        :next(function(self) actions.busy = false; end));
      return;
    end
  end
  if (cnf.corsair.rollvar2 and not(status[stoe[cnf.corsair.rollvar2]])) then
    if (buffs:IsAble(abilities[cnf.corsair.rollvar2], ability_levels)) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(ability, '"' .. cnf.corsair.roll2 .. '"', '<me>'))
        :next(partial(wait, 7))
        :next(function(self) actions.busy = false; end));
      return;
    end
  end

  -- ATTACKING AND WEAPONSKILLING
  local tp = AshitaCore:GetDataManager():GetParty():GetMemberCurrentTP(0);
  local tid = AshitaCore:GetDataManager():GetTarget():GetTargetServerId();
  if (cnf.ATTACK_TID and tid ~= cnf.ATTACK_TID) then
    cnf.ATTACK_TID = nil;
    AshitaCore:GetChatManager():QueueCommand("/follow " .. cnf.leader, 1);
  elseif (cnf.ATTACK_TID and tid == cnf.ATTACK_TID and tp >= 1000) then
    if (cnf.WeaponSkillID ~= nil ) then
      if AshitaCore:GetDataManager():GetPlayer():HasWeaponSkill(tonumber(cnf.WeaponSkillID)) then
        for k, v in pairs(packets.weaponskills) do
          if (tonumber(cnf.WeaponSkillID) == tonumber(v)) then
            AshitaCore:GetChatManager():QueueCommand('/ws "' .. string.gsub(k,"_"," ") .. '" <t>', 1);
          end
        end
      end
    end
  elseif (cnf.ATTACK_TID) then
    AshitaCore:GetChatManager():QueueCommand("/ra <t>", 1);
  end

  -- SUBJOBS
  local sub = AshitaCore:GetDataManager():GetPlayer():GetSubJob();
  -- IF SUBJOB IS DANCER, DO DANCER THINGS
  if (sub == Jobs.Dancer and cnf.ATTACK_TID ~= nil) then
    local status = party:GetBuffs(0);
    if (tp >= 150 and buffs:IsAble(abilities.DRAIN_SAMBA, jdnc.ability_levels) and status[stoe.DRAIN_SAMBA] ~= true) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(ability, '"Drain Samba"', '<me>'))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return;
    end
  -- IF SUBJOB IS BARD, DO BARD THINGS
  elseif (sub == Jobs.Bard and (cnf.bard.songvar1 and not(status[stoe[cnf.bard.songvar1]]))) then
    if (buffs:CanCast(spells[cnf.bard.songvar1], jbrd.spell_levels, true)) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, '"' .. cnf.bard.song1 .. '"', '<me>'))
        :next(partial(wait, 7))
        :next(function(self) actions.busy = false; end));
      return;
    end
  end
end

function jcor:attack(tid)
  actions:queue(actions:new()
    :next(function(self)
      AshitaCore:GetChatManager():QueueCommand('/attack ' .. tid, 0);
    end)
    :next(function(self)
      config:get().ATTACK_TID = tid;
      AshitaCore:GetChatManager():QueueCommand('/follow ' .. tid, 0);
    end)
    );
end

function jcor:corsair(corsair, command, roll)
  local cnf = config:get();
  local cor = cnf['corsair'];
  local onoff = cor['roll'] and 'on' or 'off';
  local roll1 = cor['roll1'] or 'none';
  local roll2 = cor['roll2'] or 'none';

  local rollvar;
  if(roll ~= nil) then
    rollvar = roll:upper():gsub("'", ""):gsub(" ", "_");
  end

  if (command ~= nil) then
    if (command == 'on' or command == 'true') then
      cor['roll'] = true;
      onoff = 'on';
    elseif (command == 'off' or command == 'false') then
      cor['roll'] = false;
      onoff = 'off';
    elseif (command == '1' and roll and abilities[rollvar]) then
      cor['roll1'] = roll;
      cor['rollvar1'] = rollvar;
      roll1 = roll;
    elseif (command == '2' and roll and abilities[rollvar]) then
      cor['roll2'] = roll;
      cor['rollvar2'] = rollvar;
      roll2 = roll;
    elseif (command =='1' and roll == 'none') then
      cor['roll1'] = nil;
      cor['rollvar1'] = nil;
      roll1 = 'none';
    elseif (command =='2' and roll == 'none') then
      cor['roll2'] = nil;
      cor['rollvar2'] = nil;
      roll2 = 'none';
    end
    config:save();
  end

  AshitaCore:GetChatManager():QueueCommand('/l2 I\'m a Corsair!\nrolling: ' .. onoff .. '\n1: ' .. roll1 .. '\n2: ' .. roll2, 1);
end

return jcor;
