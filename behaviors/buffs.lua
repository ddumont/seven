local party = require('party');
local config = require('config');
local actions = require('actions');
local packets = require('packets');

local spells = packets.spells;
local status = packets.status;

-- What is level, and are we talking about your main job or sub job?  Takes into account level sync!
-- @param true/false on checking for SUBJOB
function JobLvlCheck (isSub)
    local iparty = AshitaCore:GetDataManager():GetParty();
    local lvl = AshitaCore:GetDataManager():GetParty():GetMemberMainJobLevel(0);
    if (isSub) then
      local maxlvlsub = AshitaCore:GetDataManager():GetPlayer():GetSubJobLevel();
      lvl = math.min(math.modf(lvl/2),maxlvlsub);
    end
    return lvl
end

return {

  -- Can the player cast this spell?
  -- @param the spell id
  -- @param the spell level table
  -- @param true/false on checking for SUBJOB
  CanCast = function(self, spell, levels, isSub)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local lvl = JobLvlCheck(isSub);
    return player:HasSpell(spell) and levels[spell] ~= nil and lvl >= levels[spell];
  end,

  -- Can the player use this ability?
  -- @param the ability id
  -- @param the ability level table
  -- @param true/false on checking for SUBJOB
  IsAble = function(self, ability, levels, isSub)
    local iparty = AshitaCore:GetDataManager():GetParty();
    local lvl = JobLvlCheck(isSub);
    return levels[ability] ~= nil and lvl >= levels[ability];
  end,

  -- Scans the party (including the current player) for those needing heals
  -- @param status effect buff to check
  -- @returns list of party indicies needing buff
  NeedBuff = function(self, buff, ...)
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
  end,

  -- Scans the party (including the current player) for those needing heals
  -- @param status effect buff to check
  -- @returns list of party indicies needing buff
  NeedCleanse = function(self, status)
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
  end,

  -- cast idle buffs
  -- @param table of spell levels
  IdleBuffs = function(self, levels)
    local buffs = party:GetBuffs(0);
    -- if (buffs[status.EFFECT_REFRESH] == nil) then
    --   actions.busy = true;
    --   actions:queue(actions:new()
    --     :next(partial(magic, 'Refresh', '<me>'))
    --     :next(partial(wait, 16))
    --     :next(function(self) actions.busy = false; end));
    --   return true;
    -- end

    if (config:get()['IdleBuffs'] ~= true) then return end
    if (AshitaCore:GetDataManager():GetParty():GetMemberCurrentMPP(0) < 70) then return end

    local need = self:NeedBuff(status.EFFECT_PROTECT);
    -- print('need prot ' .. ashita.settings.JSON:encode_pretty(need, nil, { pretty = true, align_keys = false, indent = '    ' }));
    if (self:CanCast(spells.PROTECTRA, levels) and #need > 1) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Protectra', '<me>'))
        :next(partial(wait, 18))
        :next(function(self) actions.busy = false; end));
      return true;
    elseif (self:CanCast(spells.PROTECT, levels) and #need > 0) then
      local iparty = AshitaCore:GetDataManager():GetParty();
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Protect', need[math.random(#need)]))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return true;
    end

    need = self:NeedBuff(status.EFFECT_SHELL);
    -- print('need shell ' .. ashita.settings.JSON:encode_pretty(need, nil, { pretty = true, align_keys = false, indent = '    ' }));
    if (self:CanCast(spells.SHELLRA, levels) and #need > 1) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Shellra', '<me>'))
        :next(partial(wait, 18))
        :next(function(self) actions.busy = false; end));
      return true;
    elseif (self:CanCast(spells.SHELL, levels) and #need > 0) then
      local iparty = AshitaCore:GetDataManager():GetParty();
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Shell', need[math.random(#need)]))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return true;
    end

    if (self:CanCast(spells.STONESKIN, levels) and buffs[status.EFFECT_STONESKIN] == nil) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Stoneskin', '<me>'))
        :next(partial(wait, 16))
        :next(function(self) actions.busy = false; end));
      return true;
    end
  end,

  Cleanse = function(self, levels)
    local iparty = AshitaCore:GetDataManager():GetParty();
    local need = self:NeedCleanse(status.EFFECT_POISON);
    if (self:CanCast(spells.POISONA, levels) and #need > 0) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Poisona', need[math.random(#need)]))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return true;
    end
    need = self:NeedCleanse(status.EFFECT_BLINDNESS);
    if (self:CanCast(spells.BLINDNA, levels) and #need > 0) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Blindna', need[math.random(#need)]))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return true;
    end
    need = self:NeedCleanse(status.EFFECT_PARALYSIS);
    if (self:CanCast(spells.PARALYNA, levels) and #need > 0) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Paralyna', need[math.random(#need)]))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return true;
    end
  end,

  SneakyTime = function(self, levels)
    if (config:get()['SneakyTime'] ~= true) then return end
    local iparty = AshitaCore:GetDataManager():GetParty();
    if (iparty:GetMemberCurrentMPP(0) < 15) then return end

    local need = self:NeedBuff(status.EFFECT_SNEAK, Jobs.WhiteMage);
    if (self:CanCast(spells.SNEAK, levels) and #need > 0) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Sneak', need[math.random(#need)]))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return true;
    end
    need = self:NeedBuff(status.EFFECT_INVISIBLE, Jobs.WhiteMage);
    if (self:CanCast(spells.INVISIBLE, levels) and #need > 0) then
      -- print('need invis ' .. ashita.settings.JSON:encode_pretty(need, nil, { pretty = true, align_keys = false, indent = '    ' }));
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Invisible', need[math.random(#need)]))
        :next(partial(wait, 12))
        :next(function(self) actions.busy = false; end));
      return true;
    end
  end
}
