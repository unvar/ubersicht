command: "dscacheutil -q user -a name $(whoami) | fgrep gecos | sed -e 's/.*gecos: \\(.*\\)/\\1/'"

refreshFrequency: 90000

style: """
   color: white;
   
   left: 25px;
   bottom: 180px;
   
   font-family: Ubuntu, -apple-system, Helvetica Neue;
   font-weight: 500;
   letter-spacing: 1px;

   .name
    font-weight: bold
    font-size: 24px
"""

#Render function
render: -> """
	<div class="greeting"></div>
"""

# Update function.
update: (output, domEl) ->

  # Greeting segments for the day.
  firstname = output.split(' ')[0]
  segments = [
    "Good morning, <span class=\"name\">#{firstname}</span>",
    "Good afternoon, <span class=\"name\">#{firstname}</span>",
    "Good evening, <span class=\"name\">#{firstname}</span>"
  ]

  # Fetch the current hour.
  hour = (new Date()).getHours()

  # Greeting logic.
  greeting = segments[0] if hour <= 11
  greeting = segments[1] if 11 < hour <= 17
  greeting = segments[2] if 17 < hour <= 24

  # DOM manipulation.
  $(domEl).find('.greeting').html("#{greeting}")