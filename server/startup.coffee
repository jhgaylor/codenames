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

	# Listen for new connections, login, logoff and application exit to manage user status and register methods to be used by client to set user status and default status
	UserPresence.start();
	# Active logs for every changes
	# Listen for changes in UserSessions and Meteor.users to set user status based on active connections
	UserPresenceMonitor.start();

MyCron = new Cron(3600000) #ms
MyCron.addJob 12, cleanUpCollections #hour
MyCron.addJob 12, cleanUpMessages #hour
