local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs');
local healing = require('behaviors.healing');
local magic = require('magic');
local ja = require('ja');

local spell_levels = {};
spell_levels[packets.spells.INDI_POISON] = 1;
spell_levels[packets.spells.INDI_VOIDANCE] = 4;
spell_levels[packets.spells.STONE] = 4;
spell_levels[packets.spells.GEO_POISON] = 5;
spell_levels[packets.spells.GEO_VOIDANCE] = 8;
spell_levels[packets.spells.WATER] = 9;
spell_levels[packets.spells.INDI_PRECISION] = 10;
spell_levels[packets.spells.AERO] = 14;
spell_levels[packets.spells.GEO_PRECISION] = 14;
-- spell_levels[packets.spells.DRAIN] = 15;
spell_levels[packets.spells.INDI_REGEN] = 15;
spell_levels[packets.spells.INDI_ATTUNEMENT] = 16;
spell_levels[packets.spells.FIRE] = 19;
spell_levels[packets.spells.GEO_REGEN] = 19;
spell_levels[packets.spells.GEO_ATTUNEMENT] = 20;
spell_levels[packets.spells.INDI_FOCUS] = 22;
spell_levels[packets.spells.BLIZZARD] = 24;
-- spell_levels[packets.spells.STONERA] = 25;
spell_levels[packets.spells.GEO_FOCUS] = 26;
spell_levels[packets.spells.INDI_BARRIER] = 28;
spell_levels[packets.spells.THUNDER] = 29;
spell_levels[packets.spells.INDI_REFRESH] = 30;
-- spell_levels[packets.spells.ASPIR] = 30;
spell_levels[packets.spells.INDI_CHR] = 30;
-- spell_levels[packets.spells.WATERA] = 30;
spell_levels[packets.spells.GEO_BARRIER] = 32;
spell_levels[packets.spells.INDI_MND] = 33;
spell_levels[packets.spells.INDI_FURY] = 34;
spell_levels[packets.spells.GEO_REFRESH] = 34;
spell_levels[packets.spells.GEO_CHR] = 34;
spell_levels[packets.spells.STONE_II] = 34;
-- spell_levels[packets.spells.AERA] = 35;
-- spell_levels[packets.spells.SLEEP] = 35;
spell_levels[packets.spells.INDI_INT] = 36;
spell_levels[packets.spells.GEO_MND] = 37;
spell_levels[packets.spells.GEO_FURY] = 38;
spell_levels[packets.spells.WATER_II] = 38;
spell_levels[packets.spells.INDI_AGI] = 39;
spell_levels[packets.spells.INDI_FEND] = 40;
spell_levels[packets.spells.GEO_INT] = 40;
-- spell_levels[packets.spells.FIRA] = 40;
spell_levels[packets.spells.AERO_II] = 42;
spell_levels[packets.spells.INDI_VIT] = 42;
spell_levels[packets.spells.GEO_AGI] = 43;
spell_levels[packets.spells.GEO_FEND] = 44;
spell_levels[packets.spells.INDI_DEX] = 45;
-- spell_levels[packets.spells.BLIZZARA] = 45;
spell_levels[packets.spells.FIRE_II] = 46;
spell_levels[packets.spells.INDI_ACUMEN] = 46;
spell_levels[packets.spells.GEO_VIT] = 46;
spell_levels[packets.spells.INDI_STR] = 48;
spell_levels[packets.spells.INDI_SLOW] = 48;
spell_levels[packets.spells.GEO_DEX] = 49;
spell_levels[packets.spells.BLIZZARD_II] = 50;
spell_levels[packets.spells.GEO_ACUMEN] = 50;
-- spell_levels[packets.spells.THUNDARA] = 50;
spell_levels[packets.spells.INDI_TORPOR] = 52;
spell_levels[packets.spells.GEO_STR] = 52;
spell_levels[packets.spells.GEO_SLOW] = 52;
spell_levels[packets.spells.THUNDER_II] = 54;
spell_levels[packets.spells.GEO_TORPOR] = 56;
spell_levels[packets.spells.INDI_SLIP] = 58;
spell_levels[packets.spells.STONE_III] = 58;
spell_levels[packets.spells.WATER_III] = 61;
spell_levels[packets.spells.GEO_SLIP] = 62;
spell_levels[packets.spells.AERO_III] = 64;
spell_levels[packets.spells.INDI_LANGUOR] = 64;
spell_levels[packets.spells.FIRE_III] = 67;
spell_levels[packets.spells.INDI_PARALYSIS] = 68;
spell_levels[packets.spells.GEO_LANGUOR] = 68;
spell_levels[packets.spells.BLIZZARD_III] = 70;
spell_levels[packets.spells.INDI_VEX] = 70;
-- spell_levels[packets.spells.SLEEP_II] = 70;
-- spell_levels[packets.spells.STONERA_II] = 70;
spell_levels[packets.spells.GEO_PARALYSIS] = 72;
spell_levels[packets.spells.THUNDER_III] = 73;
spell_levels[packets.spells.GEO_VEX] = 74;
-- spell_levels[packets.spells.WATERA_II] = 75;
spell_levels[packets.spells.INDI_FRAILTY] = 76;
spell_levels[packets.spells.STONE_IV] = 76;
spell_levels[packets.spells.WATER_IV] = 79;
spell_levels[packets.spells.GEO_FRAILTY] = 80;
-- spell_levels[packets.spells.AERA_II] = 80;
spell_levels[packets.spells.AERO_IV] = 82;
spell_levels[packets.spells.INDI_WILT] = 82;
-- spell_levels[packets.spells.FIRA_II] = 85;
spell_levels[packets.spells.FIRE_IV] = 85;
spell_levels[packets.spells.GEO_WILT] = 86;
spell_levels[packets.spells.BLIZZARD_IV] = 88;
spell_levels[packets.spells.INDI_GRAVITY] = 88;
spell_levels[packets.spells.INDI_MALAISE] = 88;
-- spell_levels[packets.spells.ASPIR_II] = 90;
-- spell_levels[packets.spells.BLIZZARA_II] = 90;
spell_levels[packets.spells.THUNDER_IV] = 91;
spell_levels[packets.spells.GEO_GRAVITY] = 92;
spell_levels[packets.spells.GEO_MALAISE] = 92;
spell_levels[packets.spells.INDI_HASTE] = 93;
spell_levels[packets.spells.INDI_FADE] = 94;
-- spell_levels[packets.spells.THUNDARA_II] = 95;
spell_levels[packets.spells.GEO_HASTE] = 97;
spell_levels[packets.spells.GEO_FADE] = 98;
-- spell_levels[packets.spells.STONE_V] = 99;
-- spell_levels[packets.spells.WATER_V] = 99;
-- spell_levels[packets.spells.AERO_V] = 99;
-- spell_levels[packets.spells.FIRE_V] = 99;
-- spell_levels[packets.spells.BLIZZARD_V] = 99;
-- spell_levels[packets.spells.THUNDER_V] = 99;
-- spell_levels[packets.spells.ASPIR_III] = 99;
-- spell_levels[packets.spells.STONERA_III] = 99;
-- spell_levels[packets.spells.WATERA_III] = 99;
-- spell_levels[packets.spells.AERA_III] = 99;
-- spell_levels[packets.spells.FIRA_III] = 99;
-- spell_levels[packets.spells.BLIZZARA_III] = 99;
-- spell_levels[packets.spells.THUNDARA_III] = 99;



local jgeo = {
  spell_levels = spell_levels,
};



function jgeo:tick()
  if (jgeo:Hate()) then return end
  if (actions.busy) then return end
  if (buffs:SneakyTime(spell_levels)) then return end
  if (jgeo:IdleBuffs()) then return end

  local player = AshitaCore:GetDataManager():GetPlayer();
  local cnf = config:get();
  local geo = cnf['geomancer'];
  local mana = AshitaCore:GetDataManager():GetParty():GetMemberCurrentMP(0);

  if (player and mana > 50 and geo and geo['practice']) then
    -- actions.busy = true;
    -- actions:queue(actions:new()
    --   :next(partial(magic.cast, magic, 'ifrit', '<me>'))
    --   :next(partial(wait, 14))
    --   :next(function(self)
    --     AshitaCore:GetChatManager():QueueCommand('/ja release <me>', 0);
    --   end)
    --   :next(partial(wait, 4))
    --   :next(function(self) actions.busy = false; end));
    -- return;
  end
end

function jgeo:IdleBuffs()
  local cnf = config:get();
  local geo = cnf['geomancer'];
  if (cnf['IdleBuffs'] ~= true and geo['practice'] ~= true) then return end

  local buff_table = party:GetBuffs(0);
  if (buff_table[packets.status.EFFECT_INVISIBLE]) then return end

  local sub = AshitaCore:GetDataManager():GetPlayer():GetSubJob();
  if (sub == Jobs.RedMage and buff_table[packets.status.EFFECT_REFRESH] == nil) then
    actions.busy = true;
    actions:queue(
      actions:new()
      :next(partial(wait, 3))
      :next(partial(magic.cast, magic, "refresh", "<me>"))
      :next(partial(wait, 5))
      :next(function() actions.busy = false; end)
    );
    return true;
  end

  if (geo['indispell'] == nil and geo['geospell'] == nil) then return end
  local player = AshitaCore:GetDataManager():GetPlayer();
  local iparty = AshitaCore:GetDataManager():GetParty();
  local mana = iparty:GetMemberCurrentMP(0);
  local alive = iparty:GetMemberCurrentHPP(0) > 0;
  if (player and alive and mana > 50) then
    local action = nil;

    -- indi
    if (geo['indispell'] ~= nil) then
      local target = 0; -- self
      local target_buffs = party:GetBuffs(target);
      for i = 1, 5 do
        local name = iparty:GetMemberName(i);
        if (name:lower() == geo['inditarget']:lower()) then
          local pid = AshitaCore:GetDataManager():GetParty():GetMemberServerId(i);
          target = i;
          target_buffs = party:GetBuffs(pid);
          break;
        end
      end

      local spell = 'INDI_' .. geo['indispell']:upper():gsub("INDI[-]", "");
      if (packets.spells[spell] ~= nil and target_buffs[packets.stoe[spell]] == nil or geo['practice']) then
        -- if we already have a colure active, don't recast if its the same spell.
        if (party:GetBuffs(0)[packets.status.COLURE_ACTIVE] == nil or geo['indilast'] ~= spell or geo['practice']) then
          if (buffs:CanCast(packets.spells[spell], spell_levels)) then
            if (action == nil) then action = actions:new(); end
            geo['indilast'] = spell;
            config:save();

            action = action
            :next(partial(magic.cast, magic, '"' .. spell:gsub("[_]", "-") .. '"', iparty:GetMemberName(target)))
            :next(partial(wait, 7));
          end
        end
      end
    end

    -- geo
    if (geo['geospell'] ~= nil) then
      local target = 0; -- self
      local target_buffs = party:GetBuffs(target);
      for i = 1, 5 do
        local name = iparty:GetMemberName(i);
        if (name:lower() == geo['geotarget']:lower()) then
          local pid = AshitaCore:GetDataManager():GetParty():GetMemberServerId(i);
          target = i;
          target_buffs = party:GetBuffs(pid);
          break;
        end
      end

      local spell = 'GEO_' .. geo['geospell']:upper():gsub("GEO[-]", "");
      if (packets.spells[spell] ~= nil and target_buffs[packets.stoe[spell]] == nil or geo['practice']) then
        if (buffs:CanCast(packets.spells[spell], spell_levels)) then
          if (action == nil) then action = actions:new(); end
          action = action
          :next(partial(wait, 5))
          :next(function(self)
            local pid = AshitaCore:GetDataManager():GetParty():GetMemberServerId(target);
            local buff_table = party:GetBuffs(0);
            if (target ~= 0) then buff_table = party:GetBuffs(pid); end
            if (buff_table[packets.stoe[spell]] == nil or geo['practice']) then -- still no geo buff
              ja.cast(ja, '"Full Circle"', '<me>');
            end
          end)
          :next(partial(wait, 5))
          :next(partial(magic.cast, magic, '"' .. spell:gsub("[_]", "-") .. '"', iparty:GetMemberName(target)))
          :next(partial(wait, 7));
        end
      end
    end

    if (action ~= nil) then
      actions.busy = true;
      if (geo['practice']) then
        action:next(partial(wait, 30)) -- don't burn mana so fast... usually practicing with refresh up, so can maintain longer
      end
      actions:queue(action:next(function(self) actions.busy = false; end));
    end
  end
end

function jgeo:Hate()
  if (jgeo.hate) then return end
  local cnf = config:get();
  if (cnf['IdleBuffs'] ~= true) then return end
  local geo = cnf['geomancer'];

  local bt = jgeo:bt();
  -- print(bt)
  if (bt == nil or bt.ServerId == geo['hatetargetlasttarget']) then return end

  geo['hatetargetlasttarget'] = bt.ServerId;
  config:save();
  print(bt.ServerId);
  jgeo.hate = true;
  actions:queue(
    actions:new()
    :next(partial(wait, 5))
    :next(partial(magic.cast, magic, "cure", bt.ClaimServerId))
    :next(partial(wait, 3))
    :next(function() jgeo.hate = false; end)
  );
  return true;
end

function jgeo:geo(self, command, arg)
  local cnf = config:get();
  local geo = cnf['geomancer'];
  local onoff = geo['practice'] and 'on' or 'off';

  if (command ~= nil) then
    if (command == 'practice' and (arg == 'on' or arg == 'true')) then
      geo['practice'] = true;
      onoff = 'on';
    elseif (command == 'practice' and (arg == 'off' or arg == 'false')) then
      geo['practice'] = false;
      onoff = 'off';
    elseif (command == 'inditarget' and arg ~= nil) then
      geo['inditarget'] = arg;
    elseif (command == 'geotarget' and arg ~= nil) then
      geo['geotarget'] = arg;
    elseif (command == 'indispell' and arg ~= nil) then
      geo['indispell'] = arg;
    elseif (command == 'geospell' and arg ~= nil) then
      geo['geospell'] = arg;
    elseif (command == 'hatetarget' and arg ~= nil) then
      geo['hatetarget'] = arg;
    end
    config:save();
  end
end

function jgeo:bt()
  local iparty = AshitaCore:GetDataManager():GetParty();
  local ids = {};
  for x = 0, 5 do
    local serverid = iparty:GetMemberServerId(x);
    if (serverid ~= nil and serverid ~= 0) then
      ids[serverid] = true;
    end
  end

  for x = 0, 2303 do
    local entity = GetEntity(x);
    if (entity ~= nil and entity.WarpPointer ~= 0 and ids[entity.ClaimServerId] == true) then
      if (entity.StatusServer ~= 2 and entity.StatusServer ~= 3) then
        return entity;
      end
    end
  end
end

return jgeo;
