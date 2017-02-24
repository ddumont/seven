local actions = require('actions');
local packets = require('packets');
local config = require('config');
local party = require('party');
local pgen = require('pgen');

local jblm = require('jobs.blm');
local jbrd = require('jobs.brd');
local jdnc = require('jobs.dnc');
local jrdm = require('jobs.rdm');
local jsch = require('jobs.sch');
local jthf = require('jobs.thf');
local jwar = require('jobs.war');
local jwhm = require('jobs.whm');
local jmnk = require('jobs.mnk');

local healing = false;

return {
  ATTACK_TID = nil,

  debuff = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == Jobs.WhiteMage) then
      actions:queue(actions:new()
        :next(partial(magic, 'Slow', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Paralyze', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Dia', tid)));

    elseif (main == Jobs.BlackMage) then
      actions:queue(actions:new()
        :next(partial(magic, 'Blind', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Poison', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Bio', tid)));
    end
  end,


  nuke = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == Jobs.WhiteMage) then
      -- actions:queue(actions:new()
      --   :next(partial(magic, 'Banish', tid)));
    elseif (main == Jobs.BlackMage) then
      actions:queue(actions:new():next(function(self)
        -- multiple casts in a row seem to crsh the client
        -- magic('Thunder', tid);
        -- magic('Blizzard', tid);
        -- magic('Fire', tid);
        -- magic('Aero', tid);
        -- magic('Water', tid);
        magic('Stone', tid);
      end));
    elseif (main == Jobs.RedMage) then
      actions:queue(actions:new():next(function(self)
        -- multiple casts in a row seem to crsh the client
        -- magic('Thunder', tid);
        -- magic('Blizzard', tid);
        -- magic('Fire', tid);
        magic('Aero', tid);
        -- magic('Water', tid);
        -- magic('Stone', tid);
      end));
    elseif (main == Jobs.Scholar) then
      actions:queue(actions:new():next(function(self)
        -- multiple casts in a row seem to crsh the client
        -- magic('Thunder', tid);
        -- magic('Blizzard', tid);
        -- magic('Fire', tid);
        magic('Aero', tid);
        -- magic('Water', tid);
        -- magic('Stone', tid);
      end));
    end
  end,


  sleep = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == Jobs.BlackMage) then
      actions:queue(actions:new():next(partial(magic, 'Sleep', tid)));
    end
  end,


  attack = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();

    if (main == Jobs.WhiteMage) then
      jwhm:attack(tid);
    elseif (main == Jobs.RedMage) then
      jrdm:attack(tid);
    elseif (main == Jobs.Bard) then
      jbrd:attack(tid);
    elseif (main == Jobs.Thief) then
      jthf:attack(tid);
    elseif (main == Jobs.Warrior) then
      jwar:attack(tid);
    elseif (main == Jobs.Scholar) then
      jsch:attack(tid);
    elseif (main == Jobs.Dancer) then
      jdnc:attack(tid);
    elseif (main == Jobs.BlackMage) then
      jblm:attack(tid);
    elseif (main == Jobs.DarkKnight) then
      jdrk:attack(tid);
    elseif (main == Jobs.Monk) then
      jmnk:attack(tid);
    end

    if (main == Jobs.Thief or main == Jobs.Warrior or main == Jobs.Monk) then
      actions:queue(actions:new()
        :next(function(self)
          AshitaCore:GetChatManager():QueueCommand('/attack ' .. tid, 0);
        end)
        :next(function(self)
          config:get().ATTACK_TID = tid;
          AshitaCore:GetChatManager():QueueCommand('/follow ' .. tid, 0);
        end));
    end
  end,


  tick = function(self)
    local datamgr = AshitaCore:GetDataManager();
    local tid = datamgr:GetTarget():GetTargetServerId();

    local player = datamgr:GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == Jobs.WhiteMage) then
      jwhm:tick();
    elseif (main == Jobs.RedMage) then
      jrdm:tick();
    elseif (main == Jobs.Bard) then
      jbrd:tick();
    elseif (main == Jobs.Thief) then
      jthf:tick();
    elseif (main == Jobs.Warrior) then
      jwar:tick();
    elseif (main == Jobs.Scholar) then
      jsch:tick();
    elseif (main == Jobs.Dancer) then
      jdnc:tick();
    elseif (main == Jobs.BlackMage) then
      jblm:tick();
    elseif (main == Jobs.DarkKnight) then
      jdrk:tick();
    elseif (main == Jobs.Monk) then
      jmnk:tick();
    end

  end
};
