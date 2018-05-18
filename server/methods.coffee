Meteor.methods
	'findRoomByMaster': (masterCode) ->
		Rooms.findOne masterCode: masterCode
