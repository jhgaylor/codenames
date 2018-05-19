Template.game_board.helpers
	room: ->
		this.room
	cards: ->
		room = this.room
		if ! room
			return []
		room.cards