createView = require "ceri-dev-server/lib/createView"
module.exports = createView
  mixins: [
    require "ceri/lib/#model"
    require "ceri/lib/computed"
  ]
  structure: template 1, """
    <br/><br/><br/><button>Anchor: "nw"<ceri-dropdown on-body :overlay="overlay" :gutter="gutter" anchor="nw"><li>Content</li><li>Content2</li></ceri-dropdown></button><button>Anchor: "ne"<ceri-dropdown on-body :overlay="overlay" :gutter="gutter" anchor="ne"><li>Content</li><li>Content2</li></ceri-dropdown></button><button>Anchor: "sw"<ceri-dropdown on-body :overlay="overlay" :gutter="gutter" anchor="sw"><li>Content</li><li>Content2</li></ceri-dropdown></button><button>Anchor: "se"<ceri-dropdown on-body :overlay="overlay" :gutter="gutter" anchor="se"><li>Content</li><li>Content2</li></ceri-dropdown></button><br/><br/><span>scroll container with an open ceri-dropdown to see problem of body positioning</span><br/><br/>
    <button @click.toggle=overlay :text=overlayText></button><br/><input #model="gutter" placeholder="gutter in px" />
        <a href="https://github.com/ceri-comps/ceri-dropdown/blob/master/dev/onBody.coffee" style="position:relative;left:100px;">source</a>
        <div style="height:2000px;"></div>
"""
  data: ->
    gutter: null
    overlay: false
  computed:
    overlayText: -> "overlay: #{@overlay}"
  connectedCallback: ->
    @style.display = "block"
    @style.overflowY = "scroll"
    @style.height = "250px"
  tests: (env) ->
    describe "dropdown", ->
      describe "onBody", ->
        after: ->
          env.remove()
        it "works", ->
