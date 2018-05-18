Template.logs.helpers
	logs: ->
		room = getCurrentRoom()
		if !room
			return null
		logs = Logs.find({ 'roomID': room._id }, sort: createdAt: -1).fetch()
		logs
