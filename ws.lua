local ws = {};

function ws:cast(skill, target)
  AshitaCore:GetChatManager():QueueCommand('/ws ' .. skill .. ' ' .. target, 0);
end

return ws;
