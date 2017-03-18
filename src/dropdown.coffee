ceri = require "ceri/lib/wrapper"
module.exports = ceri

  mixins: [
    require "ceri/lib/props"
    require "ceri/lib/computed"
    require "ceri/lib/styles"
    require "ceri/lib/events"
    require "ceri/lib/animate"
    require "ceri/lib/open"
    require "ceri/lib/getViewportSize"
    require "ceri/lib/@popstate"
    require "ceri/lib/getScrollPos"
  ]

  props:
    keepOpen:
      type: Boolean
    constrainWidth:
      type: Boolean
    overlay:
      type: Boolean
    gutter:
      type: Number
      default: 0
    anchor:
      type: String
    onBody:
      type: Boolean
    hover:
      type: Boolean

  data: ->
    position: 
      top: null
      left: null

  events:
    popstate:
      active: -> @openingOrOpen and @onBody
      cbs: -> @hide(false)
    mouseover:
      el: "target"
      active: -> @hover and !@openingOrOpen
      cbs: "show"
      destroy: true
    mouseleave:
      active: -> @hover and @openingOrOpen
      cbs: "hide"

    click:
      target:
        active: -> !@hover and !@openingOrOpen
        notPrevented: true
        prevent: true
        cbs: "show"
        destroy: true
      this:
        notPrevented: true
        prevent: true
        cbs: "hide"
      outside: 
        el: document.documentElement
        outside: true
        cbs: "hide"
        active: "openingOrOpen"
        delay: true
        destroy: true
    
    keyup:
      el:document.documentElement
      notPrevented: true
      destroy: true
      keyCode: [27]
      active: "openingOrOpen"
      cbs: "hide"
  initStyle:
    position: "absolute"
    display: "block"
  styles:
    this:
      computed: ->
        width: [@width,"px"]
        boxSizing: if @width then "border-box" else null
        left: [@position.left,"px"]

  computed:
    cAnchor: ->
      return @anchor if @anchor
      return "nw" if @overlay
      return "sw"
    target: ->
        if @__placeholder.previousElementSibling
          return @__placeholder.previousElementSibling
        else
          return @__parentElement
    totalWidth: ->
      if @constrainWidth
        return @target.offsetWidth-@gutter
      else
        return @offsetWidth+@gutter
    width: ->
      return @totalWidth if @constrainWidth
      return null
    totalHeight: ->
      if @overlay
        return @offsetHeight 
      else
        return @offsetHeight + @target.offsetHeight
  methods:

    enter: (o) ->
      o.preserve = ["overflow","height"]
      o.init = overflow: "hidden"
      o.style = 
        height: [0,@offsetHeight, "px"]
        opacity: [0,1]
      if @position.asTop
        o.init.top = @position.top + "px"
      else
        o.style.top = [@position.top+@offsetHeight,@position.top, "px"]
      return @$animate(o)

    leave: (o) ->
      o.preserve = ["overflow","height"]
      o.init = overflow: "hidden"
      o.duration = 200
      o.style =
        height: [@offsetHeight,0, "px"]
        opacity: [1,0]
      unless @position.asTop
        o.style.top = [@position.top, @position.top+@offsetHeight, "px"]
      return @$animate(o)

    beforeShow: ->
      targetPos = @target.getBoundingClientRect()
      windowSize = @getViewportSize()

      asTop = true
      if (@cAnchor[0] == "n" and @overlay) or (@cAnchor[0] == "s" and not @overlay)
        asTop = targetPos.top + @totalHeight < windowSize.height
      else
        asTop = targetPos.bottom - @totalHeight < 0

      asLeft = true
      if @cAnchor[1] == "e"
        asLeft = targetPos.right - @totalWidth < 0
      else
        asLeft = targetPos.left + @totalWidth < windowSize.width

      top = if asTop then 0 else -@totalHeight 
      top += @target.offsetHeight unless asTop and @overlay

      left = 0
      if asLeft
        left += @gutter
      else
        left -= @totalWidth - @target.offsetWidth

      if @onBody
        scroll = @getScrollPos()
        top += scroll.top + targetPos.top
        left += scroll.left + targetPos.left
      else
        parentStyle = getComputedStyle(@parentElement)
        isPositioned = /relative|absolute|fixed/.test(parentStyle.getPropertyValue("position"))
        if @parentElement == @target and isPositioned
          left -= parseInt(parentStyle.getPropertyValue("border-left-width").replace("px",""))
          top -= parseInt(parentStyle.getPropertyValue("border-top-width").replace("px",""))
        else
          top += @target.offsetTop
          left += @target.offsetLeft
      @position = top: top, left: left, asTop: asTop 
  