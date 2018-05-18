access_code_components = ['ace', 'act', 'add', 'age', 'ago', 'aha', 'aid', 'aim', 'air', 'ali', 'all', 'amp', 'and', 'ann', 'any', 'apt', 'arc', 'are', 'arm', 'art', 'ask', 'ate', 'aye', 'bad', 'bag', 'ban', 'bar', 'bat', 'bay', 'bed', 'ben', 'bet', 'bid', 'big', 'bin', 'bit', 'bob', 'bot', 'bow', 'box', 'boy', 'bud', 'bus', 'but', 'buy', 'bye', 'cab', 'can', 'cap', 'car', 'cat', 'cor', 'cos', 'cot', 'cow', 'cry', 'cup', 'cut', 'dad', 'dan', 'day', 'dec', 'des', 'did', 'die', 'dim', 'dna', 'dog', 'don', 'dos', 'dry', 'due', 'ear', 'eat', 'egg', 'ego', 'end', 'era', 'erm', 'etc', 'eve', 'eye', 'fan', 'far', 'fat', 'fax', 'fed', 'fee', 'few', 'fey', 'fig', 'fit', 'fix', 'fly', 'fog', 'for', 'fox', 'fry', 'fun', 'fur', 'gap', 'gas', 'gdp', 'get', 'gnp', 'god', 'got', 'gps', 'gun', 'gut', 'guy', 'had', 'ham', 'has', 'hat', 'hay', 'her', 'hey', 'hid', 'him', 'hip', 'his', 'hit', 'hmm', 'hog', 'hot', 'how', 'hub', 'hut', 'ian', 'ice', 'icy', 'ill', 'inc', 'ink', 'inn', 'its', 'jam', 'jan', 'jaw', 'jay', 'jet', 'jim', 'job', 'joe', 'joy', 'key', 'kid', 'kin', 'kit', 'lad', 'lap', 'law', 'lay', 'lea', 'led', 'lee', 'leg', 'leo', 'les', 'let', 'lid', 'lie', 'lip', 'lit', 'log', 'lot', 'low', 'ltd', 'mad', 'man', 'map', 'max', 'may', 'men', 'met', 'min', 'mix', 'mrs', 'mud', 'mug', 'mum', 'nag', 'nay', 'net', 'new', 'nhs', 'non', 'nor', 'not', 'now', 'nut', 'oak', 'odd', 'off', 'oil', 'old', 'one', 'ooh', 'our', 'out', 'owe', 'owl', 'own', 'pan', 'par', 'pat', 'pay', 'pen', 'per', 'pie', 'pig', 'pin', 'pit', 'pop', 'pot', 'pro', 'pry', 'pub', 'pug', 'put', 'ran', 'rat', 'raw', 'ray', 'red', 'ref', 'rex', 'rid', 'rob', 'rod', 'ron', 'ros', 'rot', 'row', 'roy', 'rug', 'run', 'sad', 'sam', 'san', 'sat', 'saw', 'say', 'sea', 'see', 'set', 'she', 'shy', 'sin', 'sir', 'sit', 'six', 'sky', 'son', 'sri', 'sue', 'sum', 'sun', 'tap', 'tax', 'tea', 'ted', 'ten', 'the', 'thy', 'tie', 'tim', 'tin', 'tip', 'tom', 'ton', 'too', 'top', 'try', 'two', 'usa', 'use', 'van', 'vat', 'via', 'vic', 'von', 'wan', 'war', 'was', 'wax', 'way', 'wee', 'wet', 'who', 'why', 'win', 'wit', 'won', 'yep', 'yer', 'yes', 'yet', 'you'];

@generateAccessCode = ->
	code = access_code_components[getRandom(access.length)] + ' ' + access[getRandom(access.length)] + ' ' + access[getRandom(access.length)]
	code

@markWordAsGuessed = (grid, index, room) ->
	for i, val of grid
		if grid[i] > 1
			grid[i]--
	grid[index] = 4

	openedColour = room.gridColours[index]
	if openedColour == room.colourList[0]
		room.pointsList[0] += 1
	else if openedColour == room.colourList[1]
		room.pointsList[1] += 1

	Rooms.update room._id, $set: gridOpened: grid, pointsList: room.pointsList, updatedAt: new Date
