# PureScript Workshop for JSConf Medellín

## Lesson 1: Getting Started

1. Install psc-package and pulp

```bash
npm i -g psc-package pulp
```

2. Initialize the project

```bash
pulp --psc-package init
```

3. Build the project

```bash
pulp --psc-package run
```

4. Do your happy dance!

```bash
My first PureScript project 🕺
```

## Part 2: Resources and Creating a Bundle

### Resources

1. [PureScript by Example](https://leanpub.com/purescript/read) (Free eBook)
2. [Let's Build a Simon Game in PureScript](https://medium.com/@arecvlohe/lets-build-a-simon-game-in-purescript-pt-1-b9fa587a11dd)
3. [PureScript Cheatsheet](https://github.com/joshburgess/purescript-cheat-sheet)
### Bundle

1. Creat an `index.html` at the root of your directory

```bash
touch index.html
```

2. Add basic `html` markup

```html
<!DOCTYPE html>
<html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
  </head>

  <body>
    <script src='./output/app.js'></script>
  </body>

</html>
```

3. Run the server

```bash
pulp server
```

4. Do your happy dance!

```bash
My first PureScript app 💃
```

## Part 3: Hello Pux!

1. Install Pux

```bash
psc-package install pux
```

2. Imports

```haskell
import Prelude hiding (div)
import Control.Monad.Eff (Eff)
import Pux (CoreEffects, EffModel, start)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (renderToDOM)
import Text.Smolder.HTML (button, div, span)
import Text.Smolder.Markup (text, (#!))
```

3. User Actions

```haskell
data Event = Increment | Decrement
```

3. State

```haskell
type State = Int
```

4. Update

```haskell
foldp :: ∀ fx. Event -> State -> EffModel State Event fx
foldp Increment n = { state: n + 1, effects: [] }
foldp Decrement n = { state: n - 1, effects: [] }
```

5. View

```haskell
view :: State -> HTML Event
view count =
  div do
    button #! onClick (const Increment) $ text "Increment"
    span $ text (show count)
    button #! onClick (const Decrement) $ text "Decrement"
```

6. Main

```haskell
main :: ∀ fx. Eff (CoreEffects fx) Unit
main = do
  app <- start
    { initialState: 0
    , view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input
```

7. Mount App and Add React

```html
 <body>
    <div id="app"></div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.6.1/react.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.6.1/react-dom.min.js"></script>
    <script src='./output/app.js'></script>
  </body>
```

8. Bundle and Serve

```bash
pulp server
```

9. Do your happy dance!

```bash
My first PureScript app that does something 🕺 💃
```

## Part 4: Add Effects

1. Install the aff module

```bash
psc-package install aff
```

2. Import modules

```haskell
import Control.Monad.Aff.Console (CONSOLE, log)
import Data.Maybe (Maybe(..)) -- Part of Prelude
```

3. Define App Effects

```haskell
type AppEffects = ( console:: CONSOLE )
```

4. Log state to console

```haskell
foldp :: ∀ fx. Event -> State -> EffModel State Event AppEffects -- 👈
foldp Increment n = { state: n + 1, effects: [
  do
    log $ "Current State: " <> (show $ n + 1)
    pure Nothing
]}
foldp Decrement n = { state: n - 1, effects: [
  do
    log $ "Current State: " <> (show $ n - 1)
    pure Nothing
]}
```

5. Update Main

```haskell
main :: ∀ fx. Eff (CoreEffects AppEffects) Unit -- 👈
main = do
  app <- start
    { initialState: 0
    , view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input
```
