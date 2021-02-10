LMSWindow = ISPanel:derive("LMSWindow");
LMSWindow.lines = {}
LMSWindow.maxLine = 99999
LMSWindow.lastText = {}
LMSWindow.lastTextCount = 0
LMSWindow.maxMemory = 500

function LMSWindow:initialise()
	ISPanel.initialise(self);
end

function LMSWindow:new(x, y, width, height)
	local o = {};
	o = ISPanel:new(x, y, width, height);
	setmetatable(o, self);
	self.__index = self;
	o.title = "";
	o.pin = false;
	o:noBackground();
	return o;
end

function LMSWindow:updateChat(TextToUpdate, isTechnicalOutput)
	if #LMSWindow.lines > LMSWindow.maxLine then
		local newLines = {};
		for i,v in ipairs(LMSWindow.lines) do
			if i ~= 1 then
				table.insert(newLines, v);
			end
		end
		if isTechnicalOutput == true then
			table.insert(newLines, "["..getPlayer():getDescriptor():getForename().." "..getPlayer():getDescriptor():getSurname().."] "..TextToUpdate.." <LINE> ");
		else
			table.insert(newLines, TextToUpdate.." <LINE> ");
		end
		LMSWindow.lines = newLines;
	else
		if isTechnicalOutput ~= true then
			table.insert(LMSWindow.lines, "["..getPlayer():getDescriptor():getForename().." "..getPlayer():getDescriptor():getSurname().."] "..TextToUpdate.." <LINE> ");
		else
			table.insert(LMSWindow.lines, TextToUpdate.." <LINE> ");
		end
	end
	LMSWindow.LMSChatLog.text = "";
	local newText = "";
	for i,v in ipairs(LMSWindow.lines) do
		if i == #LMSWindow.lines then
			v = string.gsub(v, " <LINE> $", "") 
		end
		newText = newText .. v;
	end
	LMSWindow.LMSChatLog.text = newText;
	LMSWindow.LMSChatLog:paginate();
	LMSWindow.LMSChatLog:setYScroll(-10000);
end
function LMSWindow:createChildren()
	ISPanel.createChildren(self);
	self.LMSChatBar = ISTextEntryBox:new("", 0, 200, 500, 20)
	self.LMSChatBar:initialise();
	self:addChild(self.LMSChatBar);
	self.LMSChatLog = ISRichTextPanel:new(0, 0, 500,200);
	self.LMSChatLog:initialise();
	self.LMSChatLog.maxLines = 500
	self.LMSChatLog.autosetheight = false;
	self.LMSChatLog:ignoreHeightChange()
	self:addChild(self.LMSChatLog)
end

function LMScreate()
	LMSWindow = LMSWindow:new(35, getCore():getScreenHeight() - 250, 500, 220)
	LMSWindow:addToUIManager();
	LMSWindow:setVisible(false);
end

function KeyListener(_keyPressed)
	if _keyPressed == 20 and not LMSWindow.LMSChatBar:getText() ~= nil then
		if not LMSWindow:getIsVisible() then
  		    LMSWindow:setVisible(true);
			LMSWindow.LMSChatBar:focus()
  		else
			LMSWindow.LMSChatBar:focus()
  		end
	elseif _keyPressed == 53 and not LMSWindow.LMSChatBar:getText() ~= nil then
		if not LMSWindow:getIsVisible() then
  		    LMSWindow:setVisible(true);
			LMSWindow.LMSChatBar:focus()
			LMSWindow.LMSChatBar:setText("/")
		end
	end
end

Events.OnGameStart.Add(LMScreate);

Events.OnKeyPressed.Add(KeyListener);