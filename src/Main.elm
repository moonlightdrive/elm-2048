import Html.App as App
import Model
import View
import Update
import Json.Decode exposing ((:=))
-- needed this after moving from elm-lang/core 4.0.3 to 4.0.5... but why??


main : Program Never
main = App.program { init = Model.init 4
                   , view = View.view
                   , update = Update.update
                   , subscriptions = subscriptions 
                   }


subscriptions : Model.Model -> Sub Model.Msg
subscriptions = \_ -> Sub.none
