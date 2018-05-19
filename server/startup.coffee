cleanUpCollections = ->
	cutOff = moment().subtract(7, 'days').toDate()
	numRoomsRemoved = Rooms.remove(updatedAt: $lt: cutOff)
	return

cleanUpMessages = ->
	cutOff = moment().subtract(1, 'days').toDate()
	numLogsRemoved = Logs.remove(createdAt: $lt: cutOff)
	return

Meteor.startup ->
	###
	// Delete all collections on startup
	Rooms.remove({});
	Logs.remove({});
	###
	ServiceConfiguration.configurations.remove({
	    service: "discord"
	});
	ServiceConfiguration.configurations.insert({
	    service: "discord",
	    clientId: DISCORD_CLIENT_ID,
	    secret: DISCORD_CLIENT_SECRET
	});

MyCron = new Cron(3600000) #ms
MyCron.addJob 12, cleanUpCollections #hour
MyCron.addJob 12, cleanUpMessages #hour
