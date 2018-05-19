Meteor.publish 'room', (name) ->
	Rooms.find {name: name}

Meteor.publish 'rooms', (eyedee, accessCode) ->
	Rooms.find $or: [{_id: eyedee},{accessCode: accessCode}]

Meteor.publish 'logs', (roomID) ->
	Logs.find roomID: roomID

Meteor.publish 'logs-by-room-name', (room_name) ->
	Logs.find room_name: room_name

Meteor.publish 'room-members', (name) ->
	room = Rooms.findOne name: name
	if ! room
		console.log("No room found", name)
		return
	userIds = room.teams.red.concat(room.teams.blue)
	Meteor.users.find { _id: { $in: userIds }}, {fields: {profile:1}}
