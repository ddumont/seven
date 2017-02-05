local party = require('party');
local actions = require('actions');
local healing = require('behaviors.healing');

return {

  tick = function(self)
    if (actions.busy) then
      return;
    end

    local iparty = AshitaCore:GetDataManager():GetParty();
    healing:Heal(); -- first priority...


    -- party:PartyBuffs(function(i, buffs)
    --
    -- end);
  end

};
