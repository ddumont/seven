local party = require('party');
local config = require('config');
local actions = require('actions');
local packets = require('packets');

local spells = packets.spells;
local status = packets.status;
return {

  -- Can the player cast this spell?
  -- @param the spell id
  -- @param the spell level table
  CanCast = function(self, spell, levels)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local lvl = AshitaCore:GetDataManager():GetParty():GetMemberMainJobLevel(0);
    return player:HasSpell(spell) and lvl >= levels[spell];
  end,

  -- Scans the party (including the current player) for those needing heals
  -- @param status effect buff to check
  -- @returns list of party indicies needing buff
  NeedBuff = function(self, buff)
    local need = {};
    local iparty = AshitaCore:GetDataManager():GetParty();
    local zone = iparty:GetMemberZone(0);
    party:PartyBuffs(function(i, buffs)
      -- print(i .. ' ' .. buff .. ' ' .. tostring(buffs[buff]));
      local samez = zone == iparty:GetMemberZone(i);
      local alive = iparty:GetMemberCurrentHPP(i) > 0;
      if (alive and samez and buffs[buff] == nil) then
        table.insert(need, i);
      end
    end);
    return need;
  end,

  -- cast idle buffs
  -- @param table of spell levels
  IdleBuffs = function(self, levels)
    if (config:get()['IdleBuffs'] ~= true) then return end
    if (AshitaCore:GetDataManager():GetParty():GetMemberCurrentMPP(0) < 50) then return end

    local buffs = party:GetBuffs(0);
    if (self:CanCast(spells.STONESKIN, levels) and buffs[status.EFFECT_STONESKIN] == nil) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Stoneskin', '<me>'))
        :next(partial(wait, 16))
        :next(function(self) actions.busy = false; end));
      return true;
    end

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
      local target = iparty:GetMemberServerId(need[1]);
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Protect', target))
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
      local target = iparty:GetMemberServerId(need[1]);
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, 'Shell', target))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return true;
    end
  end
}
