local party = require('party');
local actions = require('actions');

return {
  IdleBuffs = function(self)
    local buffs = party:GetBuffs(0);
    if (~buffs[packets.status.EFFECT_STONESKIN]) then

    end
  end
}
