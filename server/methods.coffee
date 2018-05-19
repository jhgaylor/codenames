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

# TODO: remove all other Rooms.insert calls
createNewRoom = (name) ->
	# TODO: is this the name generator what we want?
	name = name || generateAccessCode()
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
	roomID
