Template.game_scoreboard_card.helpers
	spymasterIsAvailable: ->
		room = this.room
		if ! room
			return
		if ! room.teams[this.color].includes(Meteor.userId())
			return false
		room.spyMasters[this.color] == null
	members: ->
		room = this.room
		if ! room
			return
		spyMasterId = room.spyMasters[this.color]
		room.teams[this.color].map (userId) ->
			user = Meteor.users.findOne(userId)
			isSpyMaster = spyMasterId == userId
			# console.log("is spy", isSpyMaster)
			{name: user.profile.name, isSpyMaster: isSpyMaster}

Template.game_scoreboard_card.events
	'click .become-spymaster': (event) ->
		room = this.room
		if ! room
			# console.log("No room!?")
			return
		if confirm "Are you sure you want to become the spymaster for team '" + this.name + "'?"
			Meteor.call 'becomeTeamSpymasterInRoom', room.name, this.color
	'click .score-card': (event) ->
		room = this.room
		if ! room
			# console.log("No room!?")
			return
		console.log("room", room)
		# ignore if i'm on this team already
		if room.teams[this.color].includes(Meteor.userId())
			return
		if confirm "Are you sure you want to join the '" + this.name + "' team?"
			Meteor.call 'joinTeamInRoom', room.name, this.color