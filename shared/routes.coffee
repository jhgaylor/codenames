Router.route '/old', ->
	GAnalytics.pageview("main")
	@render 'layout'
	if !Session.get('currentView')
		Session.set 'currentView', 'old_lobby'
	else
		Meteor.subscribe 'rooms', Session.get('roomID'), null, null
		Meteor.subscribe 'logs', Session.get('roomID')
	return

Router.route '/code/:accessCode', ->
	GAnalytics.pageview("code")
	@render 'layout'
	accessCode = this.params.accessCode.trim().toLowerCase()
	if Session.get "roomID" # careful, this is reactive
		if confirm "You are already in a game room. Are you sure you want to leave and join a new room with the access code '" + accessCode + "'?"
			joinRoomWithCode(accessCode)
	else
		joinRoomWithCode(accessCode)
	#window.history.pushState({}, null, "/")
	#window.history.replaceState({}, null, "/")
	this.redirect('/old')

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
		Session.set 'currentView', 'game'
		Session.set 'roomName', target_room_name
		Meteor.call 'ensureRoomExists', target_room_name, null

	# if Session.get('currentView')
	# 	Meteor.call 'findRoomByName', name, (error, roomId) ->
	# 		Meteor.subscribe 'room', name, {
	# 			onStop: (error) ->
	# 				if error
	# 					FlashMessages.sendError "Sorry, could not connect to server. Please try again later."
	# 			onReady: () ->
	# 				if ! room
	# 					# TODO: deal with looking for a room that doesn't exist. create it maybe.
	# 					return
	# 				isMaster = false
	# 				if ! room
	# 					FlashMessages.sendError "Sorry, could not find any room with that name. An attempt to create it failed."
	# 					return
	# 				Meteor.subscribe "logs", room._id
	# 				Session.set 'currentView', 'game'
	# 				roomID = room._id
	# else
	# 	Session.set 'currentView', 'game'
	# return




