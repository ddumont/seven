local party = require('party');
local actions = require('actions');

return {

  -- Scans the party (including the current player) for those needing heals
  -- @returns list of party indicies needing heals
  NeedHeals = function(self)
    local need = {};
    local player = GetPlayerEntity();
    local iparty = AshitaCore:GetDataManager():GetParty();
    local zone = iparty:GetMemberZone(0);
    local i;
    for i = 0, 5 do
      local hpp = party:GetHPP(i);
      local samez = zone == iparty:GetMemberZone(i);
      local alive = iparty:GetMemberCurrentHPP(i) > 0;
      if (alive and samez and hpp > 0 and hpp < 80) then
        table.insert(need, i);
      end
      table.sort(need, function(a, b)
        return party:GetHPP(a) < party:GetHPP(b)
      end);
    end
    return need;
  end,

  -- Heals a target in the party in need of heals
  -- @param table of spell levels
  Heal = function(self, spell_levels)
    local iparty = AshitaCore:GetDataManager():GetParty();
    local idxs = self:NeedHeals();
    if (#idxs > 0) then
      local target = idxs[1];
      if (target == 0) then
        target = '<me>'
      else
        target = iparty:GetMemberServerId(target);
      end

print('foo')
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, '"Cure II"', target))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));

      return true;
    end
  end

};
