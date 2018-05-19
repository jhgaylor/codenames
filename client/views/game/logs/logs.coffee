Template.game_logs.helpers
	logs: ->
		room = this.room
		if !room
			return null
		Logs.find({ 'room_name': room.name }, sort: createdAt: -1).fetch()
