module Update exposing (update)
import Model exposing (Model, Msg(..), Tile, Board, Row, Direction(..))
-- import Directions exposing (Direction(..))
import Random
import Array exposing (Array)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> model ! []

      -- generate 2 tiles
    Shift dir ->
      ( { model | direction = dir }
      |> shift
      |> combine
      |> shift
      |> newTile )
      ! []
      -- TODO only newTile/combine if successful shift?

    Init t1 t2 ->
      -- TODO place t1 and t2 on the board somehow....
      model ! []
            
    Start ->
      model ! []

            
generateTile : Random.Generator Tile
generateTile =
  let
    twoOrFour = Random.map (\p -> if p < 0.9 then 2 else 4) (Random.float 0 1)
  in
    Random.map Tile twoOrFour

          
-- TODO For the location, match every Nothing with its position, filter out the Justs,
-- select a random Nothing and replace.. presto!
generateLocation : Int -> Random.Generator (Int, Int)
generateLocation n =
  Random.pair (Random.int 1 n) (Random.int 1 n)


-- TODO idk about this
transpose : List (List a) -> List (List a)
transpose list =
  let 
    col i = List.foldr (\r -> List.append (List.drop i >> List.take 1 <| r)) []
    n = List.length list - 1
  in
    List.map (\i -> col i list) [0..n]


get : Int -> List a -> Maybe a
get n = List.drop n >> List.head                 


replace : Int -> a -> List a -> List a
replace i v =
  List.indexedMap (\n o -> if i == n then )
        

-- this is ugly
shift : Model -> Model
shift model =
  let
    transShift f m =
      { m | board = transpose m.board }
        |> f
        |> \m -> { m | board = transpose m.board }
    horShift isLeft model  =
      let
        shiftRow r =
          let
            tiles = List.filter ((/=) Nothing) r
            n = model.size - List.length tiles
            nothings = List.repeat n Nothing
          in
            if isLeft then tiles ++ nothings else nothings ++ tiles
      in
        { model | board = List.map (\r -> shiftRow r) model.board }
  in
    case model.direction of
      West ->
        horShift True model
      East ->
        horShift False model
      North ->
        transShift (horShift True) model
      South ->
        transShift (horShift False) model

         
combine : Model -> Model
combine model =
  case model.direction of
    West ->
      { model | board = List.map westCombineSquares model.board }
    East ->
      { model | board = List.map eastCombineSquares model.board }
    North ->
      { model | board = transpose >> List.map westCombineSquares >> transpose <| model.board }
    South ->
      { model | board = transpose >> List.map eastCombineSquares >> transpose <| model.board }

         
westCombineSquares : List Model.Square -> List Model.Square
westCombineSquares squares =
  case squares of
    [] -> []
    [t] -> squares
    t::s::ts ->
      case (t, s) of
        (Nothing, _) ->
          -- technically
          -- because we do a shift first, we
          -- don't run into this case
          t :: westCombineSquares (s::ts)
            
        (Just _, Nothing) ->
          -- TODO revisit this it's not technically right
          squares

        (Just t', Just s') ->
          if t'.val == s'.val
          then Just (Tile (t'.val + s'.val)) :: Nothing :: westCombineSquares ts
          else t :: westCombineSquares (s::ts)

               
-- TODO i don't know if this is right... it might be better to reverse & west combine?
-- eastCombineSquares : Row -> Row
eastCombineSquares squares =
  case squares of
    [] -> []
    [_] -> squares
    t::s::ts ->
      case (t, s) of
        (Just t', Just s') ->
          if t'.val == s'.val
          then
            Nothing :: (Just <| Tile <| t'.val + s'.val) :: eastCombineSquares ts
          else
            t :: eastCombineSquares (s::ts)
        (_, _) ->
          t :: eastCombineSquares (s::ts)


            

{-         
westCombine : List Tile -> List Tile
westCombine tiles =
  case tiles of
    [] -> []
    [t] -> tiles
    t::s::ts ->
       if t.val == s.val then
         Tile (t.val + s.val) :: westCombine ts
       else
         t :: westCombine (s :: ts)

           
eastCombine : List Tile -> List Tile
eastCombine tiles =
  case tiles of
    [] -> []
    [_] -> tiles
    [t, s] -> if s.val == t.val
              then [ Tile (t.val + s.val) ] else tiles
    t :: ts ->
      case eastCombine ts of
        [] -> [t]
        s :: ss ->
          if s == t
          then Tile (t.val + s.val) :: ss else t :: s :: ss
-}                   
             
newTile : Model -> Model
newTile = identity          
         

{-                 
wonGame : Board -> Bool
wonGame = Matrix.any (== 2048)          
-}

{-
lostGame : Board -> Bool
lostGame =
  let
    allSquaresOccupied board =
      board.n * board.n == List.count (filterNothings board)
    noAdjacencies =
      
    noMoreMoves = allSquaresOccupied && noAdjacencies

  in
    noAdjacencies && allSquaresOccupied
-}
