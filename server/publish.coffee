Meteor.publish 'room', (name) ->
	Rooms.find {name: name}

Meteor.publish 'rooms', (eyedee, accessCode) ->
	Rooms.find $or: [{_id: eyedee},{accessCode: accessCode}]

Meteor.publish 'logs', (roomID) ->
	Logs.find roomID: roomID

Meteor.publish 'logs-by-room-name', (room_name) ->
	Logs.find room_name: room_name