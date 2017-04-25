local actions = require('actions');
local packets = require('packets');
local config = require('config');
local party = require('party');
local pgen = require('pgen');

local jblm = require('jobs.blm');
local jbrd = require('jobs.brd');
local jdnc = require('jobs.dnc');
local jdrk = require('jobs.drk');
local jrdm = require('jobs.rdm');
local jsch = require('jobs.sch');
local jthf = require('jobs.thf');
local jwar = require('jobs.war');
local jwhm = require('jobs.whm');
local jmnk = require('jobs.mnk');
local jsmn = require('jobs.smn');

local map = {};
map[Jobs.BlackMage] = jblm;
map[Jobs.Bard] = jbrd;
map[Jobs.Dancer] = jdnc;
map[Jobs.DarkKnight] = jdrk;
map[Jobs.RedMage] = jrdm;
map[Jobs.Scholar] = jsch;
map[Jobs.Thief] = jthf;
map[Jobs.Warrior] = jwar;
map[Jobs.WhiteMage] = jwhm;
map[Jobs.Monk] = jmnk;
map[Jobs.Summoner] = jsmn;

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
    local main = AshitaCore:GetDataManager():GetPlayer():GetMainJob();

    for jobid, job in pairs(map) do
      if (main == jobid and job.nuke) then
        return job:nuke(tid);
      end
    end
  end,


  sleep = function(self, tid)
    local main = AshitaCore:GetDataManager():GetPlayer():GetMainJob();

    for jobid, job in pairs(map) do
      if (main == jobid and job.sleep) then
        return job:sleep(tid);
      end
    end
  end,


  attack = function(self, tid)
    local main = AshitaCore:GetDataManager():GetPlayer():GetMainJob();

    for jobid, job in pairs(map) do
      if (main == jobid and job.attack) then
        return job:attack(tid);
      end
    end
  end,


  tick = function(self)
    if (config:get() == nil) then return end
    local main = AshitaCore:GetDataManager():GetPlayer():GetMainJob();

    for jobid, job in pairs(map) do
      if (main == jobid and job.tick) then
        return job:tick(tid);
      end
    end
  end
};
