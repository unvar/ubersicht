command: "ps axo \"rss,pid,ucomm\" | sort -nr | tail +1 | head -n3 | awk '{printf \"%8.0f MB,%s,%s\\n\", $1/1024, $3, $2}'"

refreshFrequency: 5000

style: """
  border-radius: 3px 3px 3px 3px
  border: 1px solid rgba(#fff, 0.5)
  
  bottom: 100px
  left: 420px
  color: #fff
  font-family: -apple-system, Helvetica Neue

  table
    border-collapse: collapse
    table-layout: fixed

    &:after
      content: 'MEMORY'
      position: absolute
      left: 0
      top: -18px
      font-size: 11px

  td
    font-size: 14px
    font-weight: 300
    width: 120px
    max-width: 120px
    overflow: hidden

  .wrapper
    padding: 4px 6px 4px 6px
    position: relative

  .col1
    background: rgba(#fff, 0.2)
    border-right: 1px solid rgba(#fff, 0.3)

  .col2
    background: rgba(#fff, 0.1)
    border-right: 1px solid rgba(#fff, 0.3)

  p
    padding: 0
    margin: 0
    font-size: 10px
    font-weight: normal
    max-width: 100%
    color: rgb(170,170,170)
    text-overflow: ellipsis

  .pid
    position: absolute
    top: 2px
    right: 2px
    font-size: 10px
    color: rgb(170,170,170)
    font-weight: normal

"""


render: ->
  """
  <table>
    <tr>
      <td class='col1'></td>
      <td class='col2'></td>
      <td class='col3'></td>
    </tr>
  </table>
"""

update: (output, domEl) ->
  processes = output.split('\n')
  table     = $(domEl).find('table')

  renderProcess = (cpu, name, id) ->
    "<div class='wrapper'>" +
      "#{cpu}<p>#{name}</p>" +
      "<div class='pid'>#{id}</div>" +
    "</div>"

  for process, i in processes
    args = process.split(',')
    table.find(".col#{i+1}").html renderProcess(args...)

