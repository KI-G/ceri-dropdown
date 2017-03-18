# ceri-dropdown

a advanced dropdown/up/left/right menu.

### [Demo](https://ceri-comps.github.io/ceri-dropdown)

# Install

```sh
npm install --save-dev ceri-dropdown
```

## Usage
- [general ceri component usage instructions](https://github.com/cerijs/ceri#i-want-to-use-a-component-built-with-ceri)
- in your project
```coffee
window.customElements.define("ceri-dropdown", require("ceri-dropdown"))
```
```html
<!-- as sibling (preferred) -->
<button>Click to open dropdown</button>
<ceri-dropdown>
  <li><span>Line 1</span></li>
</ceri-dropdown>
<!-- as child -->
<button>Click to open dropdown
  <ceri-dropdown>
    <li><span>Line 1</span></li>
  </ceri-dropdown>
</button>
```

For examples see [`dev/`](dev/).

#### Props
Name | type | default | description
---:| --- | ---| ---
gutter | Number | 0 | horizontal offset
anchor | String | overlay ? "nw" : "sw" | point of the parent where it will be attached
keep-open | Boolean | false | will be not close on click outside of dropdown
constrain-width | Boolean | false | fix width to parent width
overlay | Boolean | false | will overlay parent
hover | Boolean | false | open on hover instead click
open | Boolean | false | set to open / close
on-body | Boolean | false | will be positioned on body instead of sibling/parent element. [Detailed description](#positioning)

#### Events
Name |  description
---:| ---
toggled(open:Boolean) | emitted before open and after close

#### Positioning
There are two ways of positioning. The default is in-place, the other possibility is on `body`.
- The in-place positioning can be problematic when you have an `overflow:hidden` combined with a `position:absolute|relative|fixed` element in the parent chain and the dropdown is overflowing.
- the `body` positioning can be problematic when the parent is moving relative to `body` or when you depend on inheritance of styles.

#### Themes
- [ceri-materialize](https://github.com/ceri-comps/ceri-materialize)
```html
<button class=btn>Click me!</button>
<ceri-dropdown class=materialize constrain-width overlay>
  <li><span>Content</span></li>
  <li><span>Content2</span></li>
</ceri-dropdown>
```

#### Custom animation
- read the documentation of the [animate mixin](https://github.com/cerijs/ceri#animate).
- read and understand the default animation in [src/dropdown.coffee](src/dropdown.coffee)
- you can provide a custom animation like this:
```coffee
# application wide
CEDD = require("ceri-dropdown")
CEDD.prototype.enter = (o) -> # your new enter animation
CEDD.prototype.leave = (o) -> # your new leave animation
window.customElements.define("ceri-dropdown", CEDD)
# single instance
# get a ref to your instance of ceri-dropdown somehow
# then overwrite the animations directly
ceDD.enter = (o) -> # your new enter animation
ceDD.leave = (o) -> # your new leave animation
```

# Development
Clone repository.
```sh
npm install
npm run dev
```
Browse to `http://localhost:8080/`.

## License
Copyright (c) 2017 Paul Pflugradt
Licensed under the MIT license.
