require "./basic.css"
window.customElements.define "ceri-dropdown", require "../src/dropdown.coffee"
createView = require "ceri-dev-server/lib/createView"
module.exports = createView
  mixins: [
    require "ceri/lib/#model"
    require "ceri/lib/computed"
  ]
  structure: template 1, """
    <button style="float:left;" #ref=floatleft>Click
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" #ref=floatleftdd>
        <li>Content</li>
        <li>Content2</li>
      </ceri-dropdown>
    </button>
    <button style="float:right;"
    v-el:floatright="v-el:floatright">Click
    <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" v-ref:floatright="v-ref:floatright"><li>Content</li><li>Content2</li></ceri-dropdown></button>
  <div class="clear" style="clear:both;"></div><br/><button v-el:nw="v-el:nw">Anchor: "nw"<ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" anchor="nw" v-ref:nw="v-ref:nw"><li>Content</li><li>Content2</li></ceri-dropdown></button><button v-el:ne="v-el:ne">Anchor: "ne"<ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" anchor="ne" v-ref:ne="v-ref:ne"><li>Content</li><li>Content2</li></ceri-dropdown></button>
  <button
    v-el:sw="v-el:sw">Anchor: "sw"
    <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" anchor="sw" v-ref:sw="v-ref:sw">
      <li>Content</li>
      <li>Content2</li>
    </ceri-dropdown>
    </button><button v-el:se="v-el:se">Anchor: "se"<ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" anchor="se" v-ref:se="v-ref:se"><li>Content</li><li>Content2</li></ceri-dropdown></button>
    <button class="absolute" style="top:80px;left:10px;"
      v-el:topleft="v-el:topleft">Click
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" v-ref:topleft="v-ref:topleft"><li>Content</li><li>Content2</li></ceri-dropdown></button>
    <button class="absolute"
     style="top:80px;right:10px;" v-el:topright="v-el:topright">Click
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" v-ref:topright="v-ref:topright">
        <li>Content</li>
        <li>Content2</li>
      </ceri-dropdown>
      </button>
      <button class="absolute" style="bottom:10px;left:10px;" v-el:bottomleft="v-el:bottomleft">Click
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" v-ref:bottomleft="v-ref:bottomleft"><li>Content</li><li>Content2</li></ceri-dropdown></button>
      <button class="absolute"
       style="bottom:10px;right:10px;" v-el:bottomright="v-el:bottomright">Click
        <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :offset="offset" v-ref:bottomright="v-ref:bottomright">
          <li>Content</li>
          <li>Content2</li>
        </ceri-dropdown>
        </button><br/><br/><br/><span>dropdown changes anchor automatically to be always in viewport</span><br/><span>Blue buttons are positioned absolutely</span><br/><span>change overlay and offset to see different behavior</span><br/>
        <button @click.toggle=overlay :text=overlayText></button>
        <button @click.toggle=constrainWidth :text=constrainWidthText></button>
        <br/>
        <input #model="offset" placeholder="offset in px" />
        <a href="https://github.com/ceri-comps/ceri-dropdown/blob/master/dev/basic.coffee" style="position:relative;left:100px;">source</a>
        """
  data: ->
    offset: null
    overlay: false
    constrainWidth: false
  computed:
    overlayText: -> "overlay: #{@overlay}"
    constrainWidthText: -> "constrainWidth: #{@constrainWidth}"
