Template.game_scoreboard.helpers
	blueTeam: ->
		return {name: "blue", color: "blue", room: this.room, members: [{name: "Jake", isSpyMaster: false}, {name: "Amos", isSpyMaster: true}, {name: "Tyler", isSpyMaster: false}], cardsRemaining: 8}
	redTeam: ->
		return {name: "red", color: "red", room: this.room, members: [{name: "Cody", isSpyMaster: true}, {name: "Kendra", isSpyMaster: false}, {name: "KC", isSpyMaster: false}], cardsRemaining: 9}