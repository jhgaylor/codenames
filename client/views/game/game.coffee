Template.game.helpers
	context: ->
		room = getCurrentRoom()
		{ room: room }
	name: ->
		Session.get 'roomName'


# Template.game.events
