Template.inGame.helpers
	accessCode: ->
		room = getCurrentRoom()
		if room
			room.accessCode
	masterCode: ->
		room = getCurrentRoom()
		if room
			room.masterCode
	width: ->
		room = getCurrentRoom()
		if room
			room.width
	height: ->
		room = getCurrentRoom()
		if room
			room.height
	wordListTypes: ->
		room = getCurrentRoom()
		if room
			({key: key, value: value, selected: room.wordListType == key} for key, value of wordListTypes)
	wordListCustom: ->
		room = getCurrentRoom()
		if room
			room.wordListCustom.join(", ")
	customWordsFormClass: ->
		room = getCurrentRoom()
		if room
			if room.wordListType == "custom"
				""
			else
				"hidden"
	count1: ->
		room = getCurrentRoom()
		if room
			room.count1
	count2: ->
		room = getCurrentRoom()
		if room
			room.count2
	countA: ->
		room = getCurrentRoom()
		if room
			room.countA
	gridWords: ->
		room = getCurrentRoom()
		if room
			gridWords = room.gridWords.map((item, index) ->
				colour = room.gridColours[index]
				opened = room.gridOpened[index]
				openedWhen = "opened"+opened
				if opened > 1
					opened = 1
				{index: index, word: item, colour: colour, opened: opened, openedWhen: openedWhen}
			)
			gridWords
	isRoomState: (state) ->
		room = getCurrentRoom()
		if room
			room.state == state
	isSpymaster: ->
		room = getCurrentRoom()
		if room
			room.masterCode == Session.get 'masterCode'
		else
			false
	colourState: ->
		room = getCurrentRoom()
		if room
			colourState = room.colourList[0] + ': ' + room.pointsList[0] + '/' + room.count1 + ' ' + room.colourList[1] + ': ' + room.pointsList[1] + '/' + room.count2
			colourState
		else
			'?'

Template.inGame.events
	'click .card.preparing': (event) ->
		room = getCurrentRoom()
		if !room
			return false
		index = $(event.target).attr('data-index')
		index = parseInt(index)
		newWord = prompt("Replace with:", "")
		if newWord
			newWord = newWord.trim()
			grid = room.gridWords
			existingIndex = grid.indexOf(newWord)
			existingIndex2 = grid.indexOf(newWord.toLowerCase())
			if existingIndex == -1 && existingIndex2 == -1
				grid[index] = newWord
				Rooms.update room._id, $set: gridWords: grid, updatedAt: new Date
			else
				alert("That's a duplicate of a word already on the board")
	'click .card.started': (event) ->
		room = getCurrentRoom()
		if !room
			return false
		index = $(event.target).attr('data-index')
		index = parseInt(index)
		grid = room.gridOpened
		if grid[index] > 0
			return false
		word = $(event.target).text()
		if $('#reqConfirm').is(":checked")
			choice = confirm "Are you sure you want to guess the word '"+word+"'?"
			if !choice
				return false
		markWordAsGuessed(grid, index, room)
	'click button#startGame': ->
		room = getCurrentRoom()
		if !room
			return false
		Rooms.update room._id, $set: state: 'started', updatedAt: new Date
	'click button#prepareGame': ->
		room = getCurrentRoom()
		if !room
			return false
		generateGridWords(room)
		generateGridColours(room)
		generateGridOpened(room)
		Rooms.update room._id, $set: state: 'preparing', updatedAt: new Date
		clearLogs()
	'change select#wordListType': ->
		room = getCurrentRoom()
		if !room
			return false
		wordListType = $('select#wordListType').val()
		Rooms.update room._id, $set: wordListType: wordListType, updatedAt: new Date
	'click button#becomeNormal': ->
		Session.set "masterCode", null
		msg = "Someone has stopped being a spymaster"
		createLog msg
	'click button#becomeMaster': ->
		room = getCurrentRoom()
		if !room
			return false
		masterCode = $('#masterCode').val().trim().toLowerCase()
		if masterCode == room.masterCode
			Session.set "masterCode", masterCode
			msg = "Someone has become a spymaster"
			createLog msg
		else
			FlashMessages.sendError "Sorry, wrong master code"
	'click button#resetMasterCode': ->
		room = getCurrentRoom()
		if !room
			return false
		newMasterCode = generateAccessCode()
		Rooms.update room._id, $set: masterCode: newMasterCode, updatedAt: new Date
		Session.set "masterCode", newMasterCode
		msg = "Someone has reset the master code and become a spymaster"
		createLog msg
	'click button#resetColours': ->
		room = getCurrentRoom()
		if !room
			return false
		count1 = parseInt($('#count1').val().trim())
		count2 = parseInt($('#count2').val().trim())
		countA = parseInt($('#countA').val().trim())
		if !checkNumber(count1) or !checkNumber(count2) or !checkNumber(countA)
			FlashMessages.sendError "Counts must be positive integers within a reasonable range"
			return false
		if room.width * room.height < count1 + count2 + countA
			FlashMessages.sendError "The total number of these card types must not exceed the total number of cards"
			return false
		Rooms.update room._id, $set: count1: count1, count2: count2, countA: countA, updatedAt: new Date
		room = Rooms.findOne(room._id)
		generateGridColours(room)
		generateGridOpened(room)
	'click button#resetWords': ->
		room = getCurrentRoom()
		if !room
			return false
		gridWidth = parseInt($('#gridWidth').val().trim())
		gridHeight = parseInt($('#gridHeight').val().trim())
		if !checkNumber(gridWidth) or !checkNumber(gridHeight)
			FlashMessages.sendError "Grid dimensions must be positive integers within a reasonable range"
			return false
		Rooms.update room._id, $set: width: gridWidth, height: gridHeight, updatedAt: new Date
		room = Rooms.findOne(room._id)
		generateGridWords(room)
		generateGridColours(room) #ensure match grid size
		generateGridOpened(room) #ensure match grid size
	'click button#toggleWords': ->
		$(".word").toggle()
	'click button#leaveRoom': ->
		Session.set 'currentView', 'lobby'
		Session.set 'roomID', null
		Session.set "masterCode", null
