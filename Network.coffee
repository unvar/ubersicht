command: "echo \"$(ipconfig getifaddr en0)|$(curl -s ifconfig.co/json)\""

refreshFrequency: "120s"

render: (output) -> """
  <div class="ifconfig"></div>
"""

style: """
  bottom: 100px
  left: 1205px
  color: #fff
  font-family: -apple-system, Helvetica Neue
  font-size: 11px

  .ifconfig
    color: #fff

    .label
      text-transform: uppercase
      margin-bottom: 6px

    .details
      display: flex
      flex-direction: col      
      border: 1px solid rgba(#fff, 0.3)
      border-radius: 3px 3px 3px 3px

      .label
        font-size: 10px

    .internal
      border-right: 1px solid rgba(#fff, 0.3)
      padding: 5px

    .external
      padding: 5px
   
      .city::before
        content: '@ '
        color: #00a2fa

      .city::after
        content: ', '
"""

update: (output, domEl) ->
  parts = output.split('|')
  internal = parts[0]
  external = JSON.parse(parts[1])

  $(domEl).find('.ifconfig').html("""
    <div class="label">Network</div>
    <div class="details">
      <div class="internal">
        <div class="label">Internal</div>
        #{internal}
      </div>
      <div class="external">
        <div class="label">External</div>
        <span class="ip">#{external.ip}</span>
        <span class="city">#{external.city}</span>
        <span class="country">#{external.country}</span>
      </div>
    </div>
  """)