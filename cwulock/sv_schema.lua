local PLUGIN = PLUGIN;

function PLUGIN:LoadCWULocks()
	local CWULocks = ix.kernel:RestoreSchemaData( "plugins/cwulocks/"..game.GetMap() );

	for k, v in pairs(CWULocks) do
		local entity = ents.Create("ix_cwulock");
		
		ix.player:GivePropertyOffline(v.key, v.uniqueID, entity);
		
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if ( IsValid(physicsObject) ) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

function PLUGIN:SaveCWULocks()
	local CWULocks = {};

	for k, v in pairs( ents.FindByClass("ix_cwulock") ) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if ( IsValid(physicsObject) ) then
			moveable = physicsObject:IsMoveable();
		end;
		
		CWULocks[#CWULocks + 1] = {
			key = ix.entity:QueryProperty(v, "key"),
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = ix.entity:QueryProperty(v, "uniqueID"),
			position = v:GetPos(),
		};
	end;
	
	ix.kernel:SaveSchemaData("plugins/cwulocks/"..game.GetMap(), CWULocks);
end;