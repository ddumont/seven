local config = nil;

function load_settings(player)
  config = ashita.settings.load_merged(_addon.path .. '/settings/' .. player .. '/settings.json', {
    bard = {}
  });
  return config;
end

return {
  get = function(self, cb)
    if (config == nil) then
      local player = GetPlayerEntity();
      if (player == nil or player.Name == nil) then
        error('error loading config, player name not found.');
        return nil;
      end

      load_settings(player.Name);
    end

    if cb ~= nil then
      cb(config);
    end

    return config;
  end,

  save = function(self)
    ashita.settings.save(_addon.path .. '/settings/' .. GetPlayerEntity().Name .. '/settings.json', self:get());
  end
};
