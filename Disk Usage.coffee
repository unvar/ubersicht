# You may exclude certain drives (separate with a pipe)
# Example: exclude = 'MyBook' or exclude = 'MyBook|WD Passport'
# Set as something obscure to show all drives (strange, but easier than editing the command)
exclude   = 'NONE'

# Use base 10 numbers, i.e. 1GB = 1000MB. Leave this true to show disk sizes as
# OS X would (since Snow Leopard)
base10       = true

# appearance
filledStyle  = false # set to true for the second style variant. bgColor will become the text color

width        = '360px'
barHeight    = '40px'
labelColor   = '#fff'
usedColor    = 'rgba(#FFF,1)'
freeColor    = 'rgba(#FFF,0.2)'
bgColor      = 'rgba(#0,0)'
borderRadius = '3px'
bgOpacity    = 0.1

# You may optionally limit the number of disk to show
maxDisks: 1


command: "df -#{if base10 then 'H' else 'h'} | grep '/dev/' | while read -r line; do fs=$(echo $line | awk '{print $1}'); name=$(diskutil info $fs | grep 'Volume Name' | awk '{print substr($0, index($0,$3))}'); echo $(echo $line | awk '{print $2, $3, $4, $5}') $(echo $name | awk '{print substr($0, index($0,$1))}'); done | grep -vE '#{exclude}'"

refreshFrequency: 60000

style: """
  bottom: 100px
  left: 815px
  width: 20000px
  font-family: -apple-system, Helvetica Neue
  font-weight: 300

  .label
    font-size: 12px
    color: #{labelColor}
    margin-left: 1px

    .total
      display: inline-block
      margin-left: 223px
      font-weight: 800
      color: lightgray

  .disk:not(:first-child)
    margin-top: 16px

  .wrapper
    height: #{barHeight}
    font-size: #{Math.round(parseInt(barHeight)*0.8)}px
    line-height: 1
    width: #{width}
    max-width: #{width}
    margin: 4px 0 0 0
    position: relative
    overflow: hidden
    border-radius: #{borderRadius}
    border solid 1px rgba(#fff, 0.3)
    background: rgba(#{bgColor}, #{bgOpacity})
    #{'background: none' if filledStyle }

  .wrapper:first-of-type
    margin: 0px

  .bar
    position: absolute
    top: 0
    bottom: 0px

    &.used
      border-radius: #{borderRadius} 0 0 #{borderRadius}
      background: rgba(#{usedColor}, #{ if filledStyle then bgOpacity else 0.08 })
      border-bottom: 1px solid #{usedColor}
      #{'border-bottom: none' if filledStyle }

    &.free
      right: 0
      border-radius: 0 #{borderRadius} #{borderRadius} 0
      background: rgba(#{freeColor}, #{ if filledStyle then bgOpacity else 0.05 })
      border-bottom:  1px solid #{freeColor}
      #{'border-bottom: none' if filledStyle }


  .stats
    display: inline-block
    font-size: 0.5em
    line-height: 1
    word-spacing: -2px
    text-overflow: ellipsis
    vertical-align: middle
    position: relative
    width: 100%

    span
      font-size: 0.8em
      margin-left: 2px

    .free, .used
      display: inline-block
      white-space: nowrap

    .free
      color: rgba(#FFF,0.8)
      float: right
      margin-right: 6px

    .used
      color: #{if filledStyle then bgColor else usedColor}
      margin-left: 6px

  .needle
    width: 0px
    border-left: 1px dashed rgba(#{usedColor}, 0.3)
    position: absolute
    top: 0
    bottom: -2px
    display: #{'none' if filledStyle}

    &:after, &:before
      content: ' '
      border-top: 5px solid #{usedColor}
      border-left: 4px solid transparent
      border-right: 4px solid transparent
      position: absolute
      left: -4px
"""

humanize: (sizeString) ->
  sizeString.slice(0, sizeString.length - 1) + ' ' + sizeString.slice(sizeString.length - 1, sizeString.length) + 'B'


renderInfo: (total, used, free, pctg, name) -> """
  <div class='disk'>
    <div class='label'>#{name} <span class='total'>#{@humanize(total)}</span></div>
    <div class='wrapper'>
      <div class='bar used' style='width: #{pctg}'></div>
      <div class='bar free' style='width: #{100 - parseInt(pctg)}%'></div>

      <div class='stats'>
	      <div class='used'>#{@humanize(used)} <span style='font-size:7pt; font-weight:800; opacity:0.7;'> USED</span></div>
        <div class='free' style='margin-left: #{parseInt(pctg) - 16}pt'>#{@humanize(free)} <span style='font-size:7pt; font-weight:800; opacity:0.7;'> FREE</span> </div>
      </div>
      <div class='needle' style="left: #{pctg}"></div>
    </div>
  </div>
"""

update: (output, domEl) ->
  disks = output.split('\n')
  $(domEl).html ''

  for disk, i in disks[..(@maxDisks - 1)]
    args = disk.split(' ')
    if (args[4])
      args[4] = args[4..].join(' ')
      $(domEl).append @renderInfo(args...)
