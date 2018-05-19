Accounts.ui.config
  requestPermissions:
    discord: ['identify', 'email', 'connections', 'guilds', 'guilds.join']

Meteor.startup ->
	# Time of inactivity to set user as away automaticly. Default 60000
	UserPresence.awayTime = 60000
	# Set user as away when window loses focus. Defaults false
	UserPresence.awayOnWindowBlur = false
	# Start monitor for user activity
	UserPresence.start()

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
