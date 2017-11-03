module Main where

import Prelude hiding (div)
import Control.Monad.Aff (attempt)
import Control.Monad.Aff.Console (CONSOLE, log)
import Control.Monad.Eff (Eff)
import Data.Argonaut.Decode (decodeJson, (.?))
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Either (Either(Left, Right), either)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, un)
import Network.HTTP.Affjax (AJAX, get)
import Pux (CoreEffects, EffModel, start)
import Pux.DOM.Events (onClick)
import Pux.DOM.HTML (HTML)
import Pux.Renderer.React (renderToDOM)
import Text.Smolder.HTML (button, div, img)
import Text.Smolder.HTML.Attributes (src)
import Text.Smolder.Markup (text, (#!), (!))

{- Define app effects -}
type AppEffects = ( console:: CONSOLE, ajax:: AJAX )

{- Define user actions -}
data Event = RequestGiphy | ReceiveGiphy (Either String Url)

{- Define a newtype for decoding -}
newtype Url = Url String

{- Derive a new type instance -}
derive instance newtypeUrl :: Newtype Url _

{- Derive an unwrap function -}
unwrap :: Url -> String
unwrap = un Url

{- Define state shape -}
type State = Url

instance decodeJsonUrl :: DecodeJson Url where
  decodeJson json = do
    obj <- decodeJson json
    info <- obj .? "data"
    imgUrl <- info .? "image_original_url"
    pure $ Url imgUrl

{- Define state updates based on user actions -}
foldp :: ∀ fx. Event -> State -> EffModel State Event AppEffects
foldp RequestGiphy state = { state: state, effects: [
  do
    result <- attempt $ get "https://api.giphy.com/v1/gifs/random?api_key=670526ba3bda46629f097f67890105ed&tag=&rating=G"
    let decode res = decodeJson res.response :: Either String Url
    let url = either (Left <<< show) decode result
    pure $ Just $ ReceiveGiphy url
]}
foldp (ReceiveGiphy (Left _)) state = { state: state, effects: [ log "Error" *> pure Nothing ] }
foldp (ReceiveGiphy (Right url)) state = { state: url, effects: [ log "ReceivedGiphy" *> pure Nothing ]}

{- Define what the view renders -}
view :: State -> HTML Event
view url =
  div do
    button #! onClick (const RequestGiphy) $ text "Get Random Giphy"
    img ! src (unwrap url)

{- Define the main function that runs the app -}
main :: ∀ fx. Eff (CoreEffects AppEffects) Unit
main = do
  app <- start
    { initialState: Url ""
    , view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input
