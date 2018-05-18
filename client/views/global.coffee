Template.registerHelper 'equals', (a, b) ->
	a == b

Template.registerHelper 'formatDateTime', (datetime) ->
	moment(datetime).format('D MMM hh:mm A')

$(document).ready ->
	lastTouchY = 0
	preventPullToRefresh = false
	$('body').on 'touchstart', (e) ->
		if e.originalEvent.touches.length != 1
			return
		lastTouchY = e.originalEvent.touches[0].clientY
		preventPullToRefresh = window.pageYOffset == 0
		return
	$('body').on 'touchmove', (e) ->
		touchY = e.originalEvent.touches[0].clientY
		touchYDelta = touchY - lastTouchY
		lastTouchY = touchY
		if preventPullToRefresh
			# To suppress pull-to-refresh it is sufficient to preventDefault the first overscrolling touchmove.
			preventPullToRefresh = false
			if touchYDelta > 0
				e.preventDefault()
				return
		return
	return
