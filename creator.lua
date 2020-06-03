HouseCreator = {}
HouseCreator.__index = HouseCreator

function HouseCreator:new(...)
	local object = setmetatable({}, {__index = self})
	if object.constructor then
		object:constructor(...)
	end
	return object
end

function HouseCreator:hide()
	guiSetVisible(self.gui.window, false)
	showCursor(false)
	exports["mm_notifications"]:alert("success", "Zamknięto kreator lokali")
end

function HouseCreator:constructor(...)
	self.gui = {
		edit = {},
		label = {},
		window = {},
		combobox = {},
		memo = {},
		button = {}
	}
	
	showCursor(true)
	self.gui.window = guiCreateWindow(0.30, 0.32, 0.40, 0.36, "Tworzenie nowego lokalu", true)
	guiWindowSetMovable(self.gui.window, false)
	guiWindowSetSizable(self.gui.window, false)
	
	self.gui.label[1] = guiCreateLabel(0.02, 0.10, 0.60, 0.09, "1. Wielkość lokalu (mały/średni/duży)", true, self.gui.window)
	guiLabelSetHorizontalAlign(self.gui.label[1], "left", true)
	
	self.gui.combobox[1] = guiCreateComboBox(0.02, 0.19, 0.54, 0.35, "", true, self.gui.window)
		guiComboBoxAddItem(self.gui.combobox[1], "Mały ")
		guiComboBoxAddItem(self.gui.combobox[1], "Średni")
		guiComboBoxAddItem(self.gui.combobox[1], "Duży ")
	
	self.gui.label[2] = guiCreateLabel(0.02, 0.31, 0.60, 0.09, "2. Rodzaj interioru (mieszkalny/garaż/inny)", true, self.gui.window)
	guiLabelSetHorizontalAlign(self.gui.label[2], "left", true)
	
	self.gui.combobox[2] = guiCreateComboBox(0.02, 0.39, 0.54, 0.35, "", true, self.gui.window)
	guiComboBoxAddItem(self.gui.combobox[2], "Mieszkalny")
	guiComboBoxAddItem(self.gui.combobox[2], "Garaż")
	guiComboBoxAddItem(self.gui.combobox[2], "Inny")
	
	self.gui.label[3] = guiCreateLabel(0.02, 0.52, 0.60, 0.09, "3. Cena interioru", true, self.gui.window)
	guiLabelSetHorizontalAlign(self.gui.label[3], "left", true)
	
	self.gui.edit[1] = guiCreateEdit(0.02, 0.60, 0.54, 0.10, "", true, self.gui.window)
	guiEditSetMaxLength(self.gui.edit[1], 5)
	
	self.gui.label[4] = guiCreateLabel(0.02, 0.74, 0.60, 0.09, "4. Nazwa lokalu", true, self.gui.window)
	guiLabelSetHorizontalAlign(self.gui.label[4], "left", true)
	
	self.gui.edit[2] = guiCreateEdit(0.02, 0.83, 0.54, 0.10, "", true, self.gui.window)
	guiEditSetMaxLength(self.gui.edit[2], 32)
	
	self.gui.label[5] = guiCreateLabel(0.57, 0.10, 0.60, 0.09, "5. Ogólny opis", true, self.gui.window)
	guiLabelSetHorizontalAlign(self.gui.label[5], "left", true) 
	
	self.gui.memo[1] = guiCreateMemo(0.57, 0.19, 0.41, 0.59, "", true, self.gui.window)
	self.gui.button[1] = guiCreateButton(0.57, 0.81, 0.35, 0.12, "Stwórz nowy lokal", true, self.gui.window)  
	self.gui.button[2] = guiCreateButton(0.93, 0.81, 0.05, 0.12, "X", true, self.gui.window)  
	
	addEventHandler("onClientGUIClick", resourceRoot, function(button, state)
		if button == "left" and state == "up" then
			if source == self.gui.button[1] then
				local item = guiComboBoxGetSelected(self.gui.combobox[1])

				
				local sort = guiComboBoxGetSelected(self.gui.combobox[2])

				
				local size = guiComboBoxGetItemText(self.gui.combobox[1], item)
				local genre = guiComboBoxGetItemText(self.gui.combobox[2], sort)
				local cost = tonumber(guiGetText(self.gui.edit[1]))
				
				if not cost or cost < 500 or cost ~= math.floor(cost) then
					exports['mm_notifications']:alert('error','Minimalna cena domu musi wynosić 500$')
					return
				end
				
				local name = guiGetText(self.gui.edit[2])
				if not name or #name < 1 then
					exports['mm_notifications']:alert('error','Podaj nazwę lokalu ')
					return
				end
				
				local description = guiGetText(self.gui.memo[1])
				if not description or #description < 6 then
					exports['mm_notifications']:alert('error','Opis lokalu musi zawierać minimum 6 znaków')
					return
				end
				
				triggerServerEvent("createHouse", resourceRoot, size, genre, cost, name, description)
			elseif source == self.gui.button[2] then
				self:hide()
			end
		end
	end)
end
--HouseCreator:new()

addCommandHandler("ch", function()
	exports['mm_notifications']:alert('success', "Otworzyłeś kreator lokali")
	HouseCreator:new()
end)

addCommandHandler("beta", function()
	outputConsole('/ch - panel tworzenia lokalu')
end)
