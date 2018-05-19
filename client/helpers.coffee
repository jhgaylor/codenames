
@markWordAsGuessed = (grid, index, room) ->
	for i, val of grid
		if grid[i] > 1
			grid[i]--
	grid[index] = 4

	openedColour = room.gridColours[index]
	if openedColour == room.colourList[0]
		room.pointsList[0] += 1
	else if openedColour == room.colourList[1]
		room.pointsList[1] += 1

	Rooms.update room._id, $set: gridOpened: grid, pointsList: room.pointsList, updatedAt: new Date


@createLog = (msg) ->
	room = getCurrentRoom()
	if !room
		return
	log = 
		content: msg
		roomID: room._id
		createdAt: new Date
	Logs.insert log
	return

@clearLogs = ->
	room = getCurrentRoom()
	if !room
		return
	logs = Logs.find('roomID': room._id).fetch()
	logs.forEach (log) ->
		Logs.remove log._id
		return
	return


@getCurrentRoom = ->
	roomID = Session.get 'roomID'
	if roomID
		return Rooms.findOne(roomID)
	return


@shuffleArray = (a) ->
	i = a.length
	while --i > 0
		j = ~~(Math.random() * (i + 1)) # ~~ is a common optimization for Math.floor
		t = a[j]
		a[j] = a[i]
		a[i] = t
	a

@generateGridWords = (room) ->
	grid = []
	if room.wordListType == "custom"
		customWordsString = $('textarea#customWords').val()
		if customWordsString
			customWordsArray = customWordsString.split(',')
			customWordsArray = (string.trim() for string in customWordsArray)
			Rooms.update room._id, $set: wordListCustom: customWordsArray, updatedAt: new Date
			wordList = customWordsArray
		else
			wordList = room.wordListCustom
	else
		wordList = words[room.wordListType]
	length = room.width * room.height
	for x in [1..length]
		index = getRandom(wordList.length)
		word = wordList[index]
		wordList.splice(index, 1)
		grid.push(word)
	Rooms.update room._id, $set: gridWords: grid, updatedAt: new Date

@generateGridColours = (room) ->
	grid = []
	length = room.width * room.height
	countB = length - room.count1 - room.count2 - room.countA
	if countB < 0
		return false
	order = ["red", "blue"]
	if getRandom(2)
		order = ["blue", "red"]
	for x in [1..room.count1]
		grid.push(order[0])
	for x in [1..room.count2]
		grid.push(order[1])
	for x in [1..room.countA]
		grid.push("black")
	for x in [1..countB]
		grid.push("yellow")
	shuffleArray(grid)
	Rooms.update room._id, $set: gridColours: grid, colourList: order, updatedAt: new Date

@generateGridOpened = (room) ->
	grid = []
	length = room.width * room.height
	for x in [1..length]
		grid.push(0)
	Rooms.update room._id, $set: gridOpened: grid, pointsList: [0, 0], updatedAt: new Date

@checkNumber = (thingy) ->
	if !thingy or typeof thingy is not "number" or isNaN(thingy)
		return false
	if thingy < 0 or thingy > 25
		return false
	true
