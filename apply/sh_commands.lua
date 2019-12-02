local PLUGIN = PLUGIN

ix.command.Add("Apply", {
	description = "Says your name and CID to a CP.",
	arguments = ix.type.string,
	OnRun = function(itemTable, client, data, entity, index)
	
	local item = ix.item.Get("cid")
	
	if (!client:IsCombine(player)) then
		client:ConCommand("say "..(data.Name or "no one")..", "..(data.Digits or "00000"))
		return false
    end
	
	elseif (!item) then return end
		client:ConCommand("say "..(data.Name or "no one")..", "..(data.Digits or "00000"))
		return false
	end
	
	elseif (item) then return end
		ix.player:Notify(player, "You don´t own a CID!");
		return false
	end
end
})

ix.command.Add("Name", {
	description = "Says your name.",
	arguments = ix.type.string,
	OnRun = function (client, data, entity, index)
    
	if (!client:IsCombine(player)) then
	    client:ConCommand("say "..(data.Name or "no one")..;
		return false
    end
	elseif (client:IsCombine(player)) then
		client:ConCommand("say "..(data.Name or "no one")..;
		return false
	end
end
})