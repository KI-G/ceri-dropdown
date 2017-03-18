require("./materialize.config.scss")
createView = require "ceri-dev-server/lib/createView"
module.exports = createView

  structure: template 1, """
    <br/><br/><br/>
    <button class=btn>Click me!</button>
    <ceri-dropdown class=materialize constrain-width overlay>
      <li><span>Content</span></li>
      <li><span>Content2</span></li>
      </ceri-dropdown>
    
    <button style="margin-left: 20px" class=btn>Click me, too!</button>
    <ceri-dropdown class=materialize constrain-width overlay anchor="sw">
      <li><span>Content</span></li>
      <li><span>Content2</span></li>
      </ceri-dropdown>
"""
