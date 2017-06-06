local configs = {};

function load_settings(player)
  configs[player] = ashita.settings.load_merged(_addon.path .. '/settings/' .. player .. '/settings.json', {
    bard = {},
    corsair = {},
    summoner = {}
  });
  return configs[player];
end

return {
  get = function()
    local entity = GetPlayerEntity();
    if (not(entity)) then return end
    local player = entity.Name;

    if (configs[player] == nil) then
      load_settings(player);
    end

    return configs[player];
  end,

  save = function(self)
    ashita.settings.save(_addon.path .. '/settings/' .. GetPlayerEntity().Name .. '/settings.json', self:get());
  end
};
