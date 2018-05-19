Template.lobby.events
	'click button#newRoom': ->
		# TODO: get more fun names
		room_name = generateAccessCode()
		Router.go('/'+room_name)
	'click button#joinRoom': ->
		room_name = $('#room_name').val().trim().toLowerCase()
		Router.go('/'+room_name)
