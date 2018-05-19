Template.game_controls.helpers
	name: ->
		Session.get 'roomName'

Template.game_controls.events
	'click .reset-words': (event) ->
		room = getCurrentRoom()
		if !room
			return false
		Meteor.call('resetRoomWords', room.name)

	'click .reset-colors': (event) ->
		room = getCurrentRoom()
		if !room
			return false
		Meteor.call('resetRoomWordsColors', room.name)

	'click .start-game': (event) ->
		room = getCurrentRoom()
		if !room
			return false
		Meteor.call('startGameInRoom', room.name)

	'click .new-game': (event) ->
		room = getCurrentRoom()
		if !room
			return false
		Meteor.call('newGameInRoom', room.name)


	'click .leave-room': (event) ->
		Router.go('/')