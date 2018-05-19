Template.lobby.events
	'click button#newRoom': ->
		# TODO: get more fun names
		room_name = generateAccessCode()
		Router.go('/'+room_name)
	'click button#joinRoom': ->
		room_name = $('#room_name').val().trim().toLowerCase()
		Router.go('/'+room_name)


Template.old_lobby.events
	'click button#newRoom': ->
		roomID = generateNewRoom()
		room = Rooms.findOne(roomID)
		if room
			generateGridWords(room)
			generateGridColours(room)
			generateGridOpened(room)
			Meteor.subscribe "rooms", roomID, null,
				onReady: ->
					Session.set 'currentView', 'inGame'
					Session.set 'roomID', roomID
					Session.set "masterCode", room.masterCode
			Meteor.subscribe "logs", roomID
	'click button#joinRoom': ->
		accessCode = $('#accessCode').val().trim().toLowerCase()
		joinRoomWithCode(accessCode)
