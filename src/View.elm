module View exposing (view)
import Model exposing (Model, Msg(..), Direction(..))
import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Svg
import Svg.Attributes exposing (..)


view : Model -> Html Msg
view model =
  Html.div
    []
    (   
     viewBoard model.board
       ++
       [ Html.br [] []
       , Html.button [onClick <| Shift West] [text "Combine West"]
       , Html.button [onClick <| Shift East] [text "Combine East"]
       , Html.button [onClick <| Shift North] [text "North"]
       , Html.button [onClick <| Shift South] [text "South"]
       ]
    )

{-
viewBoard : Model.Board -> List (Html Msg)
viewBoard board =
  let
    viewSquare tile =
      case tile of
        Nothing -> text "[ ]"
        Just {val} ->
          text <| "[" ++ toString val ++ "]"
    viewRow =
      List.map viewSquare
  in
     board
      |> List.map viewRow
      |> List.intersperse ([Html.br [] []]) |>
         List.concat
-}

viewBoard : Model.Board -> List (Html Msg)             
viewBoard =
  let
    viewRow = List.map viewSquare
  in
    List.map viewRow >> List.intersperse ([Html.br [] []]) >> List.concat

      
viewSquare : Model.Square -> Html Msg
viewSquare square =
  case square of
    Nothing ->
      Svg.svg
           [ width "100px", height "100px"]
           [ Svg.rect
               [ width "100px"
               , height "100px"
               , x "0"
               , y "0"
               , fill "#d3d7cf"
               ]
               []
           ]
               
    Just {val} ->
      Svg.svg
           [ width "100px", height "100px"]
           [ Svg.rect
               [ width "100px"
               , height "100px"
               , x "0"
               , y "0"
               , fill "#a388ee"
               ]
               []
           , Svg.text'
               [ textAnchor "middle", alignmentBaseline "middle"
               , x "50%", y "50%"
               ]
               [Svg.text <| toString val ]
           ]
