module Model exposing (Model, Msg(..), Tile, Square, Row, Board, Direction(..), init)
import Random
-- import Matrix exposing (Matrix, empty)
--import Directions exposing (Direction(..))



type Direction
  = North | East | South | West

               
type Msg
  = NoOp
  | Start
  | Init (Tile, (Int, Int)) (Tile, (Int, Int))
  | Shift Direction

    
type GameState
  = Uninitialized | Playing | Won | Lost


type alias Model
  = { gameState : GameState
    , board : Board
    , direction : Direction
    , score : Int
    , size : Int -- size x size matrix
    , startTileCount : Int
    }


{- gameboard is a 4x4 grid. each cell can contain a tile. a tile has a number & color -}


init : Int -> (Model, Cmd Msg)
init size =
  { gameState = Playing -- TODO
  , direction = North -- dummy val.. is this a good idea TODO
  , board = emptyBoard size
  , score = 0
  , size = size
  , startTileCount = 2
  }
  ! []


emptyBoard : Int -> Board
emptyBoard n =
  let
    row = List.repeat n (Just (Tile 2) )
  in
    List.repeat n row
  {-
  List.repeat n Nothing |> List.repeat n -}
    

-- does a tile have a value, color, and position?
-- or only a value & color, with the gameboard maintainnig their positions


type alias Tile =
  { val : Int }


type alias Square = Maybe Tile
type alias Row = List Square
type alias Board = List Row
                  
