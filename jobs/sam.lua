local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local status = packets.status;
local abilities = packets.abilities;
local stoe = packets.stoe;

local ability_levels = {};
ability_levels[packets.abilities.THIRD_EYE] = 15;
ability_levels[packets.abilities.HASSO] = 25;
ability_levels[packets.abilities.MEDITATE] = 30;
ability_levels[packets.abilities.SEIGAN] = 35;
ability_levels[packets.abilities.SEKKANOKI] = 40;
ability_levels[packets.abilities.KONZENITTAI] = 65;

local jsam = {
  spell_levels = spell_levels,
};

function jsam:tick()
  if (actions.busy) then return end

  local cnf = config:get();
  local tid = AshitaCore:GetDataManager():GetTarget():GetTargetServerId();
  local tp = AshitaCore:GetDataManager():GetParty():GetMemberCurrentTP(0);
  local player = AshitaCore:GetDataManager():GetPlayer();

  if (cnf.ATTACK_TID and tid ~= cnf.ATTACK_TID) then
    cnf.ATTACK_TID = nil;
    AshitaCore:GetChatManager():QueueCommand("/follow " .. cnf.leader, 1);
  -- Attempt to weaponskill when you have TP
  elseif (cnf.ATTACK_TID and tid == cnf.ATTACK_TID and tp >= 1000) then
    if (cnf.WeaponSkillID ~= nil ) then
      if player:HasWeaponSkill(tonumber(cnf.WeaponSkillID)) then
        for k, v in pairs(packets.weaponskills) do
          if (tonumber(cnf.WeaponSkillID) == tonumber(v)) then
            AshitaCore:GetChatManager():QueueCommand('/ws "' .. string.gsub(string.gsub(k,"_"," "),"TACHI","TACHI:") .. '" <t>', 1);
          end
        end
      end
    end
  end
  if (party:GetBuffs(0)[packets.status.EFFECT_INVISIBLE]) then return end

  if (buffs:IsAble(abilities.HASSO, ability_levels) and party:GetBuffs(0)[stoe.HASSO] ~= true and not(buffs:AbilityOnCD("Hasso"))) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(ability, '"Hasso"', '<me>'))
      :next(partial(wait, 3))
      :next(function(self) actions.busy = false; end));
      return true;
  end

  local queueJobAbility = nil;
  if not(buffs:AbilityOnCD("Meditate")) then
    queueJobAbility = '"Meditate"';
  --elseif not(buffs:AbilityOnCD("Third Eye")) then
  --  queueJobAbility = '"Third Eye"';
  end
  if (queueJobAbility ~= nil) then
    actions.busy = true;
    actions:queue(actions:new()
      :next(partial(ability, queueJobAbility, '<me>'))
      :next(partial(wait, 3))
      :next(function(self) actions.busy = false; end));
    return true;
  end
end

function jsam:attack(tid)
  actions:queue(actions:new()
    :next(function(self)
      AshitaCore:GetChatManager():QueueCommand('/attack ' .. tid, 0);
    end)
    :next(function(self)
      config:get().ATTACK_TID = tid;
      AshitaCore:GetChatManager():QueueCommand('/follow ' .. tid, 0);
    end));
end

return jsam;
