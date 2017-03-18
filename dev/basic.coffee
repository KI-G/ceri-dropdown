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
    </button>
    <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" #ref=floatleftdd>
      <li>Content</li>
      <li>Content2</li>
    </ceri-dropdown>
    <button style="float:right;"
    #ref=floatright>Click
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" #ref=floatrightdd>
        <li>Content</li>
        <li>Content2</li>
      </ceri-dropdown>
    </button>
    <div class="clear" style="clear:both;"></div>
    <br/>
    <button #ref=nw>Anchor: "nw"
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" anchor="nw" #ref=nwdd>
        <li>Content</li>
        <li>Content2</li>
      </ceri-dropdown>
    </button>
    <button #ref=ne>Anchor: "ne"
    </button>
    <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" anchor="ne" #ref=nedd>
      <li>Content</li>
      <li>Content2</li>
    </ceri-dropdown>
    <button
      #ref=sw>Anchor: "sw"
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" anchor="sw" #ref=swdd>
        <li>Content</li>
        <li>Content2</li>
      </ceri-dropdown>
    </button>
    <button #ref=se>Anchor: "se"
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" anchor="se" #ref=sedd>
        <li>Content</li>
        <li>Content2</li>
      </ceri-dropdown>
    </button>
    <button class="absolute" style="top:80px;left:10px;"
      #ref=topleft>Click
    </button>
    <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" #ref=topleftdd>
      <li>Content</li>
      <li>Content2</li>
    </ceri-dropdown>
    <button class="absolute"
     style="top:80px;right:10px;" #ref=topright>Click
    </button>
    <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" #ref=toprightdd>
      <li>Content</li>
      <li>Content2</li>
    </ceri-dropdown>
    <button class="absolute" style="bottom:10px;left:10px;" #ref=bottomleft>Click
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" #ref=bottomleftdd>
        <li>Content</li>
        <li>Content2</li>
      </ceri-dropdown>
    </button>
    <button class="absolute"
      style="bottom:10px;right:10px;" #ref=bottomright>Click
      <ceri-dropdown :constrain-width=constrainWidth :overlay=overlay :gutter="gutter" #ref=bottomrightdd>
        <li>Content</li>
        <li>Content2</li>
      </ceri-dropdown>
    </button>
    <br/><br/><br/>
    <span>dropdown changes anchor automatically to be always in viewport</span>
    <br/>
    <span>Blue buttons are positioned absolutely
    </span>
    <br/>
    <span>change overlay and gutter to see different behavior
    </span>
    <br/>
    <button @click.toggle=overlay :text=overlayText></button>
    <button @click.toggle=constrainWidth :text=constrainWidthText></button>
    <br/>
    <input #model="gutter" placeholder="gutter in px" />
    <a href="https://github.com/ceri-comps/ceri-dropdown/blob/master/dev/basic.coffee" style="position:relative;left:100px;">source
    </a>
      """
  data: ->
    gutter: null
    overlay: false
    constrainWidth: false
  computed:
    overlayText: -> "overlay: #{@overlay}"
    constrainWidthText: -> "constrainWidth: #{@constrainWidth}"
  tests: (env) ->

    clickNWait = (el,cb) ->
      e = new MouseEvent("click",{
        "view": window,
        "bubbles": true,
        "cancelable": true
      })
      el.dispatchEvent(e)
      setTimeout cb,300

    roundBox = (box) ->
      left: Math.round(box.left)
      right: Math.round(box.right)
      top: Math.round(box.top)
      bottom: Math.round(box.bottom)
      width: Math.round(box.width)
      height: Math.round(box.height)

    getBoundingBoxes = (name,cb) ->
      btn = env[name]
      clickNWait btn, ->
        dd = env[name+"dd"]
        dd.open.should.be.true
        box1 = btn.getBoundingClientRect()
        box2 = dd.getBoundingClientRect()
        clickNWait btn, ->
          dd.open.should.be.false
          cb(roundBox(box1),roundBox(box2))
    startCond = (obj, cb) ->
      obj ?= {}
      obj.gutter ?= 0
      env.overlay = obj.overlay
      env.gutter = obj.gutter
      if cb?
        env.$nextTick cb
    describe "dropdown", ->

      describe "basic env", ->

        describe "floating", ->
          it "should work for left", (done) ->
            startCond {}, ->
              getBoundingBoxes "floatleft", (box1,box2) ->
                box2.left.should.equal box1.left, "floatleft-left"
                box2.top.should.equal box1.bottom, "floatleft-top"
                done()
          it "should work for right", (done) ->
            startCond {}, ->
              getBoundingBoxes "floatright", (box1,box2) ->
                box2.right.should.equal box1.right, "floatright-right"
                box2.top.should.equal box1.bottom, "floatright-top"
                done()
          it "should work with overlay", (done) ->
            startCond overlay:true, ->
              getBoundingBoxes "floatleft", (box1,box2) ->
                box2.left.should.equal box1.left, "floatleft-left"
                box2.top.should.equal box1.top, "floatleft-top"
                getBoundingBoxes "floatright", (box1,box2) ->
                  box2.right.should.equal box1.right, "floatright-right"
                  box2.top.should.equal box1.top, "floatright-top"
                  done()
          it "should work with gutter", (done) ->
            startCond gutter:20, ->
              getBoundingBoxes "floatleft", (box1,box2) ->
                box2.left.should.equal box1.left+env.gutter, "floatleft-left"
                box2.top.should.equal box1.bottom, "floatleft-top"
                getBoundingBoxes "floatright", (box1,box2) ->
                  box2.right.should.equal box1.right-env.gutter, "floatright-right"
                  box2.top.should.equal box1.bottom, "floatright-top"
                  done()
          it "should work with overlay and gutter", (done) ->
            startCond gutter:20,overlay:true, ->
              getBoundingBoxes "floatleft", (box1,box2) ->
                box2.left.should.equal box1.left+env.gutter, "floatleft-left"
                box2.top.should.equal box1.top, "floatleft-top"
                getBoundingBoxes "floatright", (box1,box2) ->
                  box2.right.should.equal box1.right-env.gutter, "floatright-right"
                  box2.top.should.equal box1.top, "floatright-top"
                  done()

        describe "anchor", ->
          it "should work for all anchors", (done) ->
            @timeout(5000)
            startCond {}, ->
              getBoundingBoxes "nw", (box1,box2) ->
                box2.left.should.equal box1.left, "nw-left"
                box2.bottom.should.equal box1.top, "nw-bottom"
                getBoundingBoxes "ne", (box1,box2) ->
                  box2.right.should.equal box1.right, "ne-right"
                  box2.bottom.should.equal box1.top, "ne-bottom"
                  getBoundingBoxes "sw", (box1,box2) ->
                    box2.left.should.equal box1.left, "sw-left"
                    box2.top.should.equal box1.bottom, "sw-top"
                    getBoundingBoxes "se", (box1,box2) ->
                      box2.right.should.equal box1.right, "se-right"
                      box2.top.should.equal box1.bottom, "se-top"
                      done()
          it "should work with overlay", (done) ->
            @timeout(5000)
            startCond overlay:true, ->
              getBoundingBoxes "nw", (box1,box2) ->
                box2.left.should.equal box1.left, "nw-left"
                box2.top.should.equal box1.top, "nw-top"
                getBoundingBoxes "ne", (box1,box2) ->
                  box2.right.should.equal box1.right, "ne-right"
                  box2.top.should.equal box1.top, "ne-top"
                  getBoundingBoxes "sw", (box1,box2) ->
                    box2.left.should.equal box1.left, "sw-left"
                    box2.bottom.should.equal box1.bottom, "sw-bottom"
                    getBoundingBoxes "se", (box1,box2) ->
                      box2.right.should.equal box1.right, "se-right"
                      box2.bottom.should.equal box1.bottom, "se-bottom"
                      done()
          it "should work with gutter", (done) ->
            @timeout(5000)
            startCond gutter:20, ->
              getBoundingBoxes "nw", (box1,box2) ->
                box2.left.should.equal box1.left+env.gutter, "nw-left"
                box2.bottom.should.equal box1.top, "nw-bottom"
                getBoundingBoxes "ne", (box1,box2) ->
                  box2.right.should.equal box1.right-env.gutter, "ne-right"
                  box2.bottom.should.equal box1.top, "ne-bottom"
                  getBoundingBoxes "sw", (box1,box2) ->
                    box2.left.should.equal box1.left+env.gutter, "sw-left"
                    box2.top.should.equal box1.bottom, "sw-top"
                    getBoundingBoxes "se", (box1,box2) ->
                      box2.right.should.equal box1.right-env.gutter, "se-right"
                      box2.top.should.equal box1.bottom, "se-top"
                      done()
          it "should work with overlay and gutter", (done) ->
            @timeout(5000)
            startCond gutter:20,overlay:true, ->
              getBoundingBoxes "nw", (box1,box2) ->
                box2.left.should.equal box1.left+env.gutter, "nw-left"
                box2.top.should.equal box1.top, "nw-top"
                getBoundingBoxes "ne", (box1,box2) ->
                  box2.right.should.equal box1.right-env.gutter, "ne-right"
                  box2.top.should.equal box1.top, "ne-top"
                  getBoundingBoxes "sw", (box1,box2) ->
                    box2.left.should.equal box1.left+env.gutter, "sw-left"
                    box2.bottom.should.equal box1.bottom, "sw-bottom"
                    getBoundingBoxes "se", (box1,box2) ->
                      box2.right.should.equal box1.right-env.gutter, "se-right"
                      box2.bottom.should.equal box1.bottom, "se-bottom"
                      done()

        # describe "absolute positioned", ->
        #   it "should work for all", (done) ->
        #     @timeout(5000)
        #     startCond {}, ->
        #       getBoundingBoxes "topleft", (box1,box2) ->
        #         box2.left.should.equal box1.left, "topleft-left"
        #         box2.top.should.equal box1.bottom, "topleft-top"
        #         getBoundingBoxes "topright", (box1,box2) ->
        #           box2.right.should.equal box1.right, "topright-right"
        #           box2.top.should.equal box1.bottom, "topright-top"
        #           getBoundingBoxes "bottomleft", (box1,box2) ->
        #             box2.left.should.equal box1.left, "bottomleft-left"
        #             box2.bottom.should.equal box1.top, "bottomleft-bottom"
        #             getBoundingBoxes "bottomright", (box1,box2) ->
        #               box2.right.should.equal box1.right, "bottomright-right"
        #               box2.bottom.should.equal box1.top, "bottomright-bottom"
        #               done()
        #   it "should work with overlay", (done) ->
        #     @timeout(5000)
        #     startCond overlay:true, ->
        #       getBoundingBoxes "topleft", (box1,box2) ->
        #         box2.left.should.equal box1.left, "topleft-left"
        #         box2.top.should.equal box1.top, "topleft-top"
        #         getBoundingBoxes "topright", (box1,box2) ->
        #           box2.right.should.equal box1.right, "topright-right"
        #           box2.top.should.equal box1.top, "topright-top"
        #           getBoundingBoxes "bottomleft", (box1,box2) ->
        #             box2.left.should.equal box1.left, "bottomleft-left"
        #             box2.bottom.should.equal box1.bottom, "bottomleft-bottom"
        #             getBoundingBoxes "bottomright", (box1,box2) ->
        #               box2.right.should.equal box1.right, "bottomright-right"
        #               box2.bottom.should.equal box1.bottom, "bottomright-bottom"
        #               done()
        #   it "should work with gutter", (done) ->
        #     @timeout(5000)
        #     startCond gutter:20, ->
        #       getBoundingBoxes "topleft", (box1,box2) ->
        #         box2.left.should.equal box1.left+env.gutter, "topleft-left"
        #         box2.top.should.equal box1.bottom, "topleft-top"
        #         getBoundingBoxes "topright", (box1,box2) ->
        #           box2.right.should.equal box1.right-env.gutter, "topright-right"
        #           box2.top.should.equal box1.bottom, "topright-top"
        #           getBoundingBoxes "bottomleft", (box1,box2) ->
        #             box2.left.should.equal box1.left+env.gutter, "bottomleft-left"
        #             box2.bottom.should.equal box1.top, "bottomleft-bottom"
        #             getBoundingBoxes "bottomright", (box1,box2) ->
        #               box2.right.should.equal box1.right-env.gutter, "bottomright-right"
        #               box2.bottom.should.equal box1.top, "bottomright-bottom"
        #               done()
        #   it "should work with both", (done) ->
        #     @timeout(5000)
        #     startCond overlay:true,gutter:20, ->
        #       getBoundingBoxes "topleft", (box1,box2) ->
        #         box2.left.should.equal box1.left+env.gutter, "topleft-left"
        #         box2.top.should.equal box1.top, "topleft-top"
        #         getBoundingBoxes "topright", (box1,box2) ->
        #           box2.right.should.equal box1.right-env.gutter, "topright-right"
        #           box2.top.should.equal box1.top, "topright-top"
        #           getBoundingBoxes "bottomleft", (box1,box2) ->
        #             box2.left.should.equal box1.left+env.gutter, "bottomleft-left"
        #             box2.bottom.should.equal box1.bottom, "bottomleft-bottom"
        #             getBoundingBoxes "bottomright", (box1,box2) ->
        #               box2.right.should.equal box1.right-env.gutter, "bottomright-right"
        #               box2.bottom.should.equal box1.bottom, "bottomright-bottom"
        #               done()