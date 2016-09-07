module Matrix exposing (Matrix, empty)
import Array exposing (Array, repeat)
import Directions exposing (Direction)


{-
TODO 

maybe instead of a matrix being a list of lists,
a matrix a is a list of pair of a with a location

type alias loc = (Int, Int)
Matrix a = [a, loc]


-}

type alias Grid a = Array (Array (Maybe a))

type alias Loc = (Int, Int)
type alias Matrix a =
  { m : Int
  , n : Int
  , matrix : Grid a
  }

-- m rows n cols  
empty : Int -> Int -> Matrix a
empty m n =
  let
    matrix = Array.repeat m <| Array.repeat n Nothing
  in
    { m = m
    , n = n
    , matrix = matrix
    }


transpose : Matrix a -> Matrix a
transpose = identity


-- TODO is this really the type you want?            
shift : Direction -> {a | matrix : Grid t} -> Grid t
shift dir {matrix} =
  case dir of
    West ->
      let
        -- move everything to the west
        move = todo
      in
      Array.map (move) matrix
    _ ->
      identity matrix
                           
      
     
             
    
{-
empty : Int -> Int -> Matrix a
empty m n =        
  -}



-- Matrix as List of List
{-

type alias Matrix a = Col (Row a)

type alias Row a = List a

type alias Col a = List a
                 
{-
(!!) : List a -> Int -> a
(!!) list n =
  List.take 1 list
        -- <| List.drop (n - 1) list


infixl 9 !!
-}



-- TODO check for n < 1?
col : Int -> Matrix a -> Maybe (Col a)
col n matrix =
  case matrix of
    [[]] -> Nothing
    cols ->
      L.drop (n - 1) >> L.take 1 >> L.head <| cols
    
       
{-
col : Int -> Matrix a -> Col a
col n =
  List.drop (n - 1) << List.take 1 
-}
{-
map : (a -> b) -> Matrix a -> Matrix b
map =


all : (a -> Bool) -> Matrix a -> Bool

  
any : (a -> Bool) -> Matrix a -> Bool
any =


-}
-}
