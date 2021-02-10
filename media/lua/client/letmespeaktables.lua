LMSHelp = {
	general = {
		page1 = {
		"/lua codehere -- built in Lua interpreter. can access any global variables in any loaded mod",
		"/toggleconditionalspeech -- toggles conditional speech",
		"/godmode -- toggles god mode",
		"/creative -- toggles creative mode",
		"/deletemode -- toggles delete mode (when enabled, press X to delete what's under your mouse)",
		"/heal -- heals you",
		"Help page 1 of 4. Type '/help commandNameHere' to view specific help, or '/help pageNumber' for a different page."
		},
		page2 = {
		"/refillammo -- refills the ammo of your currently equipped weapon",
		"/repair -- repairs held item",
		"/infiniteammo -- toggles infinite ammo",
		"/infinitedurability -- toggles infinite durability",
		"/noshotdelay -- toggles no shot delay",
		"/toggleneed needhere -- toggles need",
		"Help page 2 of 4. Type '/help commandNameHere' to view specific help, or '/help pageNumber' for a different page."
		},
		page3 = {
		"/firebrush -- toggles fire brush. when enabled, click to spawn fire.",
		"/zombiebrush numberofzombiestospawn -- toggles zombie brush. when enabled, click to spawn zombies.",
		"/levelskill codedefinedskillnamehere numbertolevelto -- levels a skill",
		"/instakill -- toggles melee insta-kill",
		"/settime numbertimehere timeordayormonthoryear -- sets the time",
		"/barricadebrush numberofplanks -- press Z to barricade the object under your mouse",
		"Help page 3 of 4. Type '/help commandNameHere' to view specific help, or '/help pageNumber' for a different page."
		},
		page4 = {
		"/teleport X Y optionalZ -- teleports you to the specified X, Y, and optional Z (height).",
		"/additem caseSensitiveName optionalCount optionalItemBase -- adds the specified number of items.",
		"/keybind key command infinite optional parameters -- binds the selected key to a command.",
		"/unkeybind key -- unbinds the selected key.",
		"/keybinds -- prints a list of all keybinds to the chat box.",
		"/fly -- toggles fly mode",
		"Help page 4 of 4. Type '/help commandNameHere' to view specific help, or '/help pageNumber' for a different page."
		},
		specificHelp = {
		lua = "[/lua codehere]: Runs code. Example: '/lua getPlayer():Say('test')'",
		toggleconditionalspeech = "[/toggleconditionalspeech]: Toggles conditional speech.",
		godmode = "[/godmode]: Toggles god mode.",
		creative = "[/creative]: Toggles creative mode.",
		deletemode = "[/deletemode]: Toggles delete mode. When toggled, press X to destroy the item below your cursor.",
		heal = "[/heal]: Heals you.",
		refillammo = "[/refillammo]: Refills the ammo of your currently equipped item.",
		repair = "[/repair]: Repairs held item.",
		infiniteammo = "[/infiniteammo]: Toggles infinite ammo.",
		infinitedurability = "[/infinitedurability]: Toggles infinite durability.",
		noshotdelay = "[/noshotdelay]: Toggles no shot delay.",
		toggleneed = "[/toggleneed|needName]: Toggles need. Valid needs are Hunger, Thirst, Panic, Sanity, etc.",
		firebrush = "[/firebrush]: Toggles fire brush. When enabled, click to spawn fire under your mouse.",
		zombiebrush = "[/zombiebrush numberOfZombies]: Toggles zombie brush. To disable, type '/zombiebrush 0', '/zombiebrush toggle', '/zombiebrush off', or '/zombiebrush disable'.",
		levelskill = "[/levelskill codeDefinedSkillName level]: Levels a skill.",
		instakill = "[/instakill]: Toggles melee insta-kill.",
		settime = '[/settime | numberTime | timeDayMonthYear]: Sets the time. Type (with quotes) "Time", "Day", "Month", or "Year" to specify what category of time you want to change.',
		barricadebrush = "[/barricadebrush barricadeLevel]: Barricades the object below your mouse, with up to 4 barricade levels (1-4 planks). Press Z to use.",
		teleport = "[/teleport | X | Y | Z]: Teleports you to the specified X, Y, and optional Z (height). Be careful with this.",
		additem = "[/additem caseSensitiveName | optionalCount | optionalCaseSensitiveItemBase]: Adds an item to your inventory. ItemBase is the item base, for mods (ex. HydroCraft)",
		keybind = "[/keybind key | command | asManyParameters | asYou | want]: Binds the key to the selected command. (ex: /keybind p /zombiebrush 10)",
		unkeybind = "[/unkeybind key]: Unbinds the selected key. (ex: /unkeybind p)",
		keybinds = "[/keybinds]: Prints a list of all bound keys to the chat window.",
		fly = "[/fly]: Toggles Fly Mode. Press the up arrow to go up and the down arrow to go down."
		}
	}
}