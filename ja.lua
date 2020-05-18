local ja = {};


function ja:cast(ability, target)
  AshitaCore:GetChatManager():QueueCommand('/ja ' .. ability .. ' ' .. target, 0);
end

return ja;
