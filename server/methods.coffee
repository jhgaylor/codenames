Meteor.methods
	'ensureRoomExists': (name) ->
		room = Rooms.findOne name: name
		if ! room
			roomId = createNewRoom name
		return !! (roomId || room._id)
	'findRoomByMaster': (masterCode) ->
		Rooms.findOne masterCode: masterCode
	'findRoomByName': (name) ->
		Rooms.findOne name: name
	'resetRoomWords': (name) ->
		resetRoomWords(name)
	'resetRoomWordsColors': (name) ->
		resetRoomWordsColors(name)
	'startGameInRoom': (name) ->
		room = Rooms.findOne name: name
		if ! room
			return
		room.state = 'playing'
		Rooms.update room._id, room
		return
	'newGameInRoom': (name) ->
		room = Rooms.findOne name: name
		if ! room
			return
		room.state = 'preparing'
		Rooms.update room._id, room
		resetRoomWords(name)
		return

resetRoomWordsColors = (name) ->
	room = Rooms.findOne name: name
	if ! room
		return
	neutral_count = room.cards.length - room.count1 - room.count2 - room.countA
	if neutral_count < 0
		return false
	new_cards = []
	new_colors = []
	order = ["red", "blue"]
	if getRandom(2)
		order = ["blue", "red"]
	for x in [1..room.count1]
		new_colors.push(order[0])
	for x in [1..room.count2]
		new_colors.push(order[1])
	for x in [1..room.countA]
		new_colors.push("dead")
	for x in [1..neutral_count]
		new_colors.push("neutral")
	shuffleArray(new_colors)
	for color in new_colors
		current_card = room.cards[new_cards.length]
		current_card.team = color
		new_cards.push(current_card)
	# TODO: do i need colourList?
	Rooms.update room._id, $set: cards: new_cards, colourList: order, updatedAt: new Date


resetRoomWords = (name) ->
	# TODO: get count from room object which needs to get it from ui
	count = 25
	# TODO: get word list name from room object which needs to get it from ui
	wordListName = "original"
	wordList = words[wordListName]
	cards = []
	for x in [1..count]
		index = getRandom(wordList.length)
		word = wordList[index]
		wordList.splice(index, 1)
		cards.push({word: word, team: null})
	shuffleArray(cards)
	console.log("setting cards", cards)
	Rooms.update {name: name}, $set: cards: cards, updatedAt: new Date
	resetRoomWordsColors(name)
	# TODO: implement this method from the old world
	# generateGridOpened(room)

# TODO: remove all other Rooms.insert calls
createNewRoom = (name) ->
	# TODO: is this the name generator what we want?
	name = name || generateAccessCode()
	# TODO: add tracker of if a game is running
	room = 
		name: name
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
	resetRoomWords(name)
	roomID

shuffleArray = (a) ->
	i = a.length
	while --i > 0
		j = ~~(Math.random() * (i + 1)) # ~~ is a common optimization for Math.floor
		t = a[j]
		a[j] = a[i]
		a[i] = t
	a
