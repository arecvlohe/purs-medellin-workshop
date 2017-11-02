module Main where

import Prelude hiding (div)
import Control.Monad.Aff.Console (CONSOLE, log)
import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe(..))
import Pux (CoreEffects, EffModel, start)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (renderToDOM)
import Text.Smolder.HTML (button, div, span)
import Text.Smolder.Markup (text, (#!))

type AppEffects = ( console:: CONSOLE )

{- Define user actions -}
data Event = Increment | Decrement

{- Define state shape -}
type State = Int

{- Define state updates based on user actions -}
foldp :: ∀ fx. Event -> State -> EffModel State Event AppEffects
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

{- Define what the view renders -}
view :: State -> HTML Event
view count =
  div do
    button #! onClick (const Increment) $ text "Increment"
    span $ text (show count)
    button #! onClick (const Decrement) $ text "Decrement"

{- Define the main function that runs the app -}
main :: ∀ fx. Eff (CoreEffects AppEffects) Unit
main = do
  app <- start
    { initialState: 0
    , view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input
