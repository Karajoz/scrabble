(* [player] contains the player's identification information, tiles, score,
 * order in the game, and a flag indicating whether this player is an AI *)
type player = {
  player_id : int;
  player_name : string;
  tiles : char list;
  score : int;
  order : int;
  ai : bool
}

(* [state] contains the game's identification information, board, players, 
 * remaining tiles (i.e. bag), and turn. *)
type state = {
  id : int;
  name : string;
  grid: Grid.board;
  players : player list;
  remaining_tiles : char list;
  turn: int
}

(* [move] is a representation of a game move containing an association list of
 * characters to be placed in specific coordinates as well as the player id of
 * the player who performs the move *)
type move = {
  tiles_placed : (char * (int * int)) list;
  player : int
}

(* [diff] is a representation of the difference between two game states. There
 * is no field for the difference in the grids because it will always either
 * be no difference (in the case of adding/removing players or a failed move) or
 * the move given to a state *)
type diff = {
  score_diff : int;
  added_tiles : char list;
  removed_tiles : char list;
  turn_diff : int;
  added_players : player list;
  removed_players : player list;
}

(* [add_player state player_id player_name] adds the player with id [player_id]
 * and name [player_name] to the current game [state], and returns the new state
 * The player replaces the computer with the lowest order, and inherits its 
 * tiles, score, and turn. 
 * raise Failure if the game is full of players (non computer) already *)
let add_player s p_id p_n = 
  let rec get_new_players players acc ai_found =
    match players with
    | h::t -> 
      if h.ai && not ai_found then 
        let new_player = {h with player_id=p_id; player_name=p_n; ai=false} in
        get_new_players t (acc @ [new_player]) true
      else 
        get_new_players t (acc @ [h]) ai_found
    | [] -> 
      if not ai_found then failwith "Game full"
      else acc
  in
  let new_players = get_new_players s.players [] false in
  {s with players=new_players}

(* [remove_player state player_id] removes the player with id [player_id] from
 * current game [state], and returns the new state. It replaces the old player
 * with a computer that inherits the removed player's tiles, score, turn, and id
 * raises Failure if there is no player in the game with [player_id] *)
let remove_player s p_id = 
  let rec get_new_players players acc pl_found =
    match players with
    | h::t ->
      if h.player_id = p_id then 
        let new_ai = 
          {h with player_name="Computer "^(string_of_int h.order); ai=true} in
        get_new_players t (acc @ [new_ai]) true
      else
        get_new_players t (acc @ [h]) pl_found
    | [] -> 
      if not pl_found then failwith "Player not found"
      else acc
  in
  let new_players = get_new_players s.players [] false in
  {s with players=new_players}

(* [get_diff state state] returns the difference [diff] between two game states.
 * requires: The state id and names are equal *)
let get_diff s1 s2 = 
  failwith "unimplemented"

(* [execute state move] executes a [move] to produce a new game state from the 
 * previous game state [state] *)
let execute s m =
  failwith "unimplemented"