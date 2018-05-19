
@markWordAsGuessed = (grid, index, room) ->
	for i, val of grid
		if grid[i] > 1
			grid[i]--
	grid[index] = 4

	openedColour = room.gridColours[index]
	if openedColour == room.colourList[0]
		room.pointsList[0] += 1
	else if openedColour == room.colourList[1]
		room.pointsList[1] += 1

	Rooms.update room._id, $set: gridOpened: grid, pointsList: room.pointsList, updatedAt: new Date

@clearLogs = ->
	room = getCurrentRoom()
	if !room
		return
	logs = Logs.find('roomID': room._id).fetch()
	logs.forEach (log) ->
		Logs.remove log._id
		return
	return


@getCurrentRoom = ->
	room_name = Session.get 'roomName'
	if room_name
		return Rooms.findOne({name: room_name})
	return




@generateGridOpened = (room) ->
	grid = []
	length = room.width * room.height
	for x in [1..length]
		grid.push(0)
	Rooms.update room._id, $set: gridOpened: grid, pointsList: [0, 0], updatedAt: new Date

@checkNumber = (thingy) ->
	if !thingy or typeof thingy is not "number" or isNaN(thingy)
		return false
	if thingy < 0 or thingy > 25
		return false
	true
