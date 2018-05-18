Template.lobby.events
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
