local util = {};

-- What is level, and are we talking about your main job or sub job?  Takes into account level sync!
-- @param true/false on checking for SUBJOB
function util:JobLvlCheck (isSub)
  local lvl = AshitaCore:GetDataManager():GetParty():GetMemberMainJobLevel(0);
  if (isSub) then
    lvl = math.min(math.modf(lvl / 2), AshitaCore:GetDataManager():GetPlayer():GetSubJobLevel());
  end
  return lvl;
end

return util;
