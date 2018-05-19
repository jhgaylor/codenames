Router.route '/', ->
	GAnalytics.pageview("main")
	@render 'layout'
	Session.set 'currentView', 'lobby'
	Session.set 'roomName', null

# Note: basically just a friendly redirect
Router.route '/:room', ->
	GAnalytics.pageview("join-game")
	@render 'layout'
	target_room_name = this.params.room.trim().toLowerCase()
	this.redirect('/g/' + target_room_name)

Router.route '/g/:room',
	subscriptions: ->
		room_name = this.params.room.trim().toLowerCase()
		room = Rooms.findOne({name: room_name})
		handles = [
			Meteor.subscribe('room', room_name),
			Meteor.subscribe('logs-by-room-name', room_name),
		]
		return handles
	action: ->
		GAnalytics.pageview("game")
		@render 'layout'
		target_room_name = this.params.room.trim().toLowerCase()
		current_room_name = Session.get "roomName" # careful, this is reactive
		if current_room_name && current_room_name != target_room_name
			if ! confirm "You are already in a game room. Are you sure you want to leave room '" + current_room_name + "' and join a new room with the access code '" + target_room_name + "'?"
				this.redirect('/g/' + current_room_name)
				return
		# createLog target_room_name, 'someone joined the room'+target_room_name
		Session.set 'currentView', 'game'
		Session.set 'roomName', target_room_name
		Meteor.call 'ensureRoomExists', target_room_name, null
