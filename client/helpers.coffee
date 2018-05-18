access_code_components = ['ace', 'act', 'add', 'age', 'ago', 'aha', 'aid', 'aim', 'air', 'ali', 'all', 'amp', 'and', 'ann', 'any', 'apt', 'arc', 'are', 'arm', 'art', 'ask', 'ate', 'aye', 'bad', 'bag', 'ban', 'bar', 'bat', 'bay', 'bed', 'ben', 'bet', 'bid', 'big', 'bin', 'bit', 'bob', 'bot', 'bow', 'box', 'boy', 'bud', 'bus', 'but', 'buy', 'bye', 'cab', 'can', 'cap', 'car', 'cat', 'cor', 'cos', 'cot', 'cow', 'cry', 'cup', 'cut', 'dad', 'dan', 'day', 'dec', 'des', 'did', 'die', 'dim', 'dna', 'dog', 'don', 'dos', 'dry', 'due', 'ear', 'eat', 'egg', 'ego', 'end', 'era', 'erm', 'etc', 'eve', 'eye', 'fan', 'far', 'fat', 'fax', 'fed', 'fee', 'few', 'fey', 'fig', 'fit', 'fix', 'fly', 'fog', 'for', 'fox', 'fry', 'fun', 'fur', 'gap', 'gas', 'gdp', 'get', 'gnp', 'god', 'got', 'gps', 'gun', 'gut', 'guy', 'had', 'ham', 'has', 'hat', 'hay', 'her', 'hey', 'hid', 'him', 'hip', 'his', 'hit', 'hmm', 'hog', 'hot', 'how', 'hub', 'hut', 'ian', 'ice', 'icy', 'ill', 'inc', 'ink', 'inn', 'its', 'jam', 'jan', 'jaw', 'jay', 'jet', 'jim', 'job', 'joe', 'joy', 'key', 'kid', 'kin', 'kit', 'lad', 'lap', 'law', 'lay', 'lea', 'led', 'lee', 'leg', 'leo', 'les', 'let', 'lid', 'lie', 'lip', 'lit', 'log', 'lot', 'low', 'ltd', 'mad', 'man', 'map', 'max', 'may', 'men', 'met', 'min', 'mix', 'mrs', 'mud', 'mug', 'mum', 'nag', 'nay', 'net', 'new', 'nhs', 'non', 'nor', 'not', 'now', 'nut', 'oak', 'odd', 'off', 'oil', 'old', 'one', 'ooh', 'our', 'out', 'owe', 'owl', 'own', 'pan', 'par', 'pat', 'pay', 'pen', 'per', 'pie', 'pig', 'pin', 'pit', 'pop', 'pot', 'pro', 'pry', 'pub', 'pug', 'put', 'ran', 'rat', 'raw', 'ray', 'red', 'ref', 'rex', 'rid', 'rob', 'rod', 'ron', 'ros', 'rot', 'row', 'roy', 'rug', 'run', 'sad', 'sam', 'san', 'sat', 'saw', 'say', 'sea', 'see', 'set', 'she', 'shy', 'sin', 'sir', 'sit', 'six', 'sky', 'son', 'sri', 'sue', 'sum', 'sun', 'tap', 'tax', 'tea', 'ted', 'ten', 'the', 'thy', 'tie', 'tim', 'tin', 'tip', 'tom', 'ton', 'too', 'top', 'try', 'two', 'usa', 'use', 'van', 'vat', 'via', 'vic', 'von', 'wan', 'war', 'was', 'wax', 'way', 'wee', 'wet', 'who', 'why', 'win', 'wit', 'won', 'yep', 'yer', 'yes', 'yet', 'you'];

@generateAccessCode = ->
	code = access_code_components[getRandom(access_code_components.length)] + ' ' + access_code_components[getRandom(access_code_components.length)] + ' ' + access_code_components[getRandom(access_code_components.length)]
	code

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

@joinRoomWithCode = (accessCode) ->
	Meteor.call 'findRoomByMaster', accessCode, (error, result) ->
		if error
			FlashMessages.sendError "Sorry, could not connect to server. Please try again later."
		else
			room = result
			roomID = null
			subAccessCode = accessCode
			if room
				roomID = room._id
				subAccessCode = null
			Meteor.subscribe 'rooms', roomID, subAccessCode,
				onReady: ->
					room = Rooms.findOne({accessCode: accessCode})
					isMaster = false
					if !room
						room = Rooms.findOne({masterCode: accessCode})
						isMaster = true
					if room
						Meteor.subscribe "logs", room._id
						Session.set 'currentView', 'inGame'
						Session.set 'roomID', room._id
						if isMaster
							Session.set 'masterCode', accessCode
							msg = "Someone has joined as a spymaster"
							createLog msg
					else
						FlashMessages.sendError "Sorry, could not find any room with that access code."
						# below is only necessary as this method is called from the access code route as well
						Session.set 'currentView', 'lobby'
						Session.set 'roomID', null

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

@generateNewRoom = ->
	room = 
		accessCode: generateAccessCode()
		masterCode: generateAccessCode()
		state: 'preparing'
		record: ''
		gridWords: []
		gridColours: []
		gridOpened: []
		colourList: ['?']
		pointsList: [0, 0]
		wordListType: 'original'
		wordListCustom: ["example 1", "example 2", "example 3"]
		width: 5
		height: 5
		count1: 9
		count2: 8
		countA: 1
		createdAt: new Date
		updatedAt: new Date
	roomID = Rooms.insert(room)
	#room = Rooms.findOne(roomID);
	roomID

@getCurrentRoom = ->
	roomID = Session.get 'roomID'
	if roomID
		return Rooms.findOne(roomID)
	return

@getRandom = (length) ->
	#return Math.floor(Math.random() * length);
	Math.floor Random.fraction() * length
	
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
