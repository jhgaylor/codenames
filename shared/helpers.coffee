access_code_components = ['ace', 'act', 'add', 'age', 'ago', 'aha', 'aid', 'aim', 'air', 'ali', 'all', 'amp', 'and', 'ann', 'any', 'apt', 'arc', 'are', 'arm', 'art', 'ask', 'ate', 'aye', 'bad', 'bag', 'ban', 'bar', 'bat', 'bay', 'bed', 'ben', 'bet', 'bid', 'big', 'bin', 'bit', 'bob', 'bot', 'bow', 'box', 'boy', 'bud', 'bus', 'but', 'buy', 'bye', 'cab', 'can', 'cap', 'car', 'cat', 'cor', 'cos', 'cot', 'cow', 'cry', 'cup', 'cut', 'dad', 'dan', 'day', 'dec', 'des', 'did', 'die', 'dim', 'dna', 'dog', 'don', 'dos', 'dry', 'due', 'ear', 'eat', 'egg', 'ego', 'end', 'era', 'erm', 'etc', 'eve', 'eye', 'fan', 'far', 'fat', 'fax', 'fed', 'fee', 'few', 'fey', 'fig', 'fit', 'fix', 'fly', 'fog', 'for', 'fox', 'fry', 'fun', 'fur', 'gap', 'gas', 'gdp', 'get', 'gnp', 'god', 'got', 'gps', 'gun', 'gut', 'guy', 'had', 'ham', 'has', 'hat', 'hay', 'her', 'hey', 'hid', 'him', 'hip', 'his', 'hit', 'hmm', 'hog', 'hot', 'how', 'hub', 'hut', 'ian', 'ice', 'icy', 'ill', 'inc', 'ink', 'inn', 'its', 'jam', 'jan', 'jaw', 'jay', 'jet', 'jim', 'job', 'joe', 'joy', 'key', 'kid', 'kin', 'kit', 'lad', 'lap', 'law', 'lay', 'lea', 'led', 'lee', 'leg', 'leo', 'les', 'let', 'lid', 'lie', 'lip', 'lit', 'log', 'lot', 'low', 'ltd', 'mad', 'man', 'map', 'max', 'may', 'men', 'met', 'min', 'mix', 'mrs', 'mud', 'mug', 'mum', 'nag', 'nay', 'net', 'new', 'nhs', 'non', 'nor', 'not', 'now', 'nut', 'oak', 'odd', 'off', 'oil', 'old', 'one', 'ooh', 'our', 'out', 'owe', 'owl', 'own', 'pan', 'par', 'pat', 'pay', 'pen', 'per', 'pie', 'pig', 'pin', 'pit', 'pop', 'pot', 'pro', 'pry', 'pub', 'pug', 'put', 'ran', 'rat', 'raw', 'ray', 'red', 'ref', 'rex', 'rid', 'rob', 'rod', 'ron', 'ros', 'rot', 'row', 'roy', 'rug', 'run', 'sad', 'sam', 'san', 'sat', 'saw', 'say', 'sea', 'see', 'set', 'she', 'shy', 'sin', 'sir', 'sit', 'six', 'sky', 'son', 'sri', 'sue', 'sum', 'sun', 'tap', 'tax', 'tea', 'ted', 'ten', 'the', 'thy', 'tie', 'tim', 'tin', 'tip', 'tom', 'ton', 'too', 'top', 'try', 'two', 'usa', 'use', 'van', 'vat', 'via', 'vic', 'von', 'wan', 'war', 'was', 'wax', 'way', 'wee', 'wet', 'who', 'why', 'win', 'wit', 'won', 'yep', 'yer', 'yes', 'yet', 'you'];

@generateAccessCode = ->
	code = access_code_components[getRandom(access_code_components.length)] + '-' + access_code_components[getRandom(access_code_components.length)] + '-' + access_code_components[getRandom(access_code_components.length)]
	code

@getRandom = (length) ->
	#return Math.floor(Math.random() * length);
	Math.floor Random.fraction() * length

# DEPRECATED
@joinRoomWithCode = (accessCode) ->
	Meteor.call 'findRoomByMaster', accessCode, (error, result) ->
		if error
			FlashMessages.sendError "Sorry, could not connect to server. Please try again later."
		else
			room = result
			roomID = null
			subAccessCode = accessCode
			if room
				roomID = room._id
				subAccessCode = null
			Meteor.subscribe 'rooms', roomID, subAccessCode,
				onReady: ->
					room = Rooms.findOne({accessCode: accessCode})
					isMaster = false
					if !room
						room = Rooms.findOne({masterCode: accessCode})
						isMaster = true
					if room
						Meteor.subscribe "logs", room._id
						Session.set 'currentView', 'inGame'
						Session.set 'roomID', room._id
						if isMaster
							Session.set 'masterCode', accessCode
							msg = "Someone has joined as a spymaster"
							createLog msg
					else
						FlashMessages.sendError "Sorry, could not find any room with that access code."
						# below is only necessary as this method is called from the access code route as well
						Session.set 'currentView', 'old_lobby'
						Session.set 'roomID', null
