local PLUGIN = PLUGIN
PLUGIN.name = "Area Display"
PLUGIN.author = "Chessnut ported to Helix by FatherSquirrel"
PLUGIN.desc = "Shows which location you are at."

if (SERVER) then
	PLUGIN.areas = PLUGIN.areas or {}

	timer.Create("ix_AreaManager", 5, 0, function()
		local areas = PLUGIN.areas

		if (#areas > 0) then
			for k = 1, #areas do
				local v = areas[k]
				local entities = ents.FindInBox(v.min, v.max)

				for k2, v2 in pairs(entities) do
					if (IsValid(v2) and v2:IsPlayer() and v2.character and v2:GetNetVar("area", "") != v.name) then
						v2:SetNetVar("area", v.name)

						hook.Run("PlayerEnterArea", v2, v, entities)
						netstream.Start(v2, "ix_PlayerEnterArea", v2)
					end
				end
			end
		end
	end)

	function PLUGIN:PlayerEnterArea(client, area)
		local text = area.name

		if (area.showTime) then
			text = text..", "..os.date("!%X", ix.util.GetTime()).."."
		end

		ix.scroll.Send(text, client)
	end

	function PLUGIN:LoadData()
		self.areas = ix.util.ReadTable("areas")
	end

	function PLUGIN:SaveData()
		ix.util.WriteTable("areas", self.areas)
	end
else
	netstream.Hook("ix_PlayerEnterArea", function(data)
		hook.Run("PlayerEnterArea", data)
	end)
end

ix.command.Add("Areaadd", {
	adminOnly = true,
	syntax = "<string name> [bool showTime]",
	onRun = function(client, arguments)
		local name = arguments[1] or "Area"
		local showTime = util.tobool(arguments[2] or "true")

		if (!client:GetVar("areaMin")) then
			if (!name) then
				ix.util.Notify(ix.lang.Get("missing_arg", 1), client)

				return
			end

			client:SetNutVar("areaMin", client:GetPos())
			client:SetNutVar("areaName", name)
			client:SetNutVar("areaShowTime", showTime)

			ix.util.Notify("Run the command again at a different position to set a maximum point.", client)
		else
			local data = {}
			data.min = client:GetNutVar("areaMin")
			data.max = client:GetPos()
			data.name = client:GetNutVar("areaName")
			data.showTime = client:GetNutVar("areaShowTime")

			client:SetVar("areaMin", nil)
			client:SetVar("areaName", nil)
			client:SetVar("areaShowTime", nil)

			table.insert(PLUGIN.areas, data)

			ix.util.WriteTable("areas", PLUGIN.areas)
			ix.util.Notify("You've added a new area.", client)
		end
	end
})

ix.command.Add("Arearemove", {
	adminOnly = true,
	onRun = function(client, arguments)
		local count = 0

		for k, v in pairs(PLUGIN.areas) do
			if (table.HasValue(ents.FindInBox(v.min, v.max), client)) then
				table.remove(PLUGIN.areas, k)

				count = count + 1
			end
		end

		ix.util.WriteTable("areas", PLUGIN.areas)
		ix.util.Notify("You've removed "..count.." areas.", client)
	end
})