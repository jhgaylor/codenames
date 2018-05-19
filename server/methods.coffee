Meteor.methods
	'becomeTeamSpymasterInRoom': (name, team) ->
		room = Rooms.findOne name: name
		user_id = Meteor.userId()
		if ! room
			return
		room.spyMasters[team] = user_id
		Rooms.update room._id, room
	'ensureRoomExists': (name) ->
		room = Rooms.findOne name: name
		if ! room
			roomId = createNewRoom name
		return !! (roomId || room._id)
	'findRoomByMaster': (masterCode) ->
		Rooms.findOne masterCode: masterCode
	'findRoomByName': (name) ->
		Rooms.findOne name: name
	'joinTeamInRoom': (name, team) ->
		room = Rooms.findOne name: name
		user_id = Meteor.userId()
		other_team = if team == 'red' then 'blue' else 'red'
		if ! room
			return
		# don't allow this behavior while the room is started
		if room.state != 'preparing'
			return
		if ! room.teams[team].includes(user_id)
			console.log("adding " + user_id + " to team " + team)
			room.teams[team].push(user_id)
		# remove from the other team if needed
		if room.teams[other_team].includes(user_id)
			console.log("removing " + user_id + " from team " + other_team)
			index = room.teams[other_team].indexOf(user_id);
			room.teams[other_team].splice(index, 1);
			
		userWasSpymaster = room.spyMasters[other_team] == user_id
		# console.log("was spymaster", userWasSpymaster)
		# if a spymaster changes teams they stop being spymaster
		if userWasSpymaster
			room.spyMasters[other_team] = null
		Rooms.update room._id, room
		# if a spymaster changes teams the board has to be regenerated
		if userWasSpymaster
			resetRoomWords name
		return
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

createNewRoom = (name) ->
	# TODO: is this the name generator what we want?
	name = name || generateAccessCode()
	# TODO: remove any unused fields
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
		spyMasters:
			red: null
			blue: null
		teams: 
			red: []
			blue: []
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
