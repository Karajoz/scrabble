open OUnit2
open Ai

(* Functions that need to be thoroughly tested:
 * -------------------------------------------
 * find_slots (DONE)
 * get_surroundings (DONE)
 * valid_chars (DONE)
 * makes_move (DONE)
 * makes_prefix (DONE)
 * out_of_bounds (DONE)
 * reverse_str (DONE)
 * find_anchors (DONE)
 * invalid_pos (DONE)
 * get_next (DONE)
 * search_next (DONE)
 * rem (DONE)
 * no_dups_append (DONE)
 * other_dirs_move (DONE)
 * place_char
 * valid_move
 * valid_prefix
 * lowercasing functions (basic tests)
 * build (basic tests)
 * best_move (basic tests)
 *)

let empty_board = Grid.empty

let apple_board = [[None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;Some 'a';Some 'p'; Some 'p'; Some 'l'; Some 'e';None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None]]

let anti_board = [[None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;Some 'a'; Some 'n'; Some 't'; Some 'i';None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None]]

let app_board = [[None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;Some 'a';Some 'p'; Some 'p';None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                   [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None]]

let po_board = [[Some 'p';Some 'o';None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None]]

let all_board = [[None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;Some 'd';None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;Some 'e';None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;Some 'f';None;None;None;None;None;None;None];
                 [None;None;None;None;Some 'g';Some 'e';Some 'a';Some 'p'; Some 'p'; Some 'd';Some 'a';None;None;None;None];
                 [None;None;None;None;None;None;None;Some 'a';None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;Some 's';None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;Some 'e';None;None;None;None;None;None;None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;Some 'b';Some 'a';None];
                 [None;None;None;None;None;None;None;None;None;None;None;None;None;None;Some 'c'];
                 [None;Some 'a';Some 'p';None;None;None;None;None;None;None;None;None;None;None;Some 'd'];
                 [Some 'a';None;None;None;None;None;None;None;None;None;None;None;None;None;None]]


let full_board = [[Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'p';Some 'o';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a'];
                  [Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a';Some 'a']]

let sort_slots a b =
  let (r, c) = a in
  let (r', c') = b in
  if (r - r') = 0 then c - c' else r - r'


let app_slots = [(7,5); (7,9); (8,6); (8,7); (8,8); (6,6); (6,7); (6,8)]

let find_slots_test = [
  "No slots" >:: (fun _ -> assert_equal [] (find_slots empty_board));
  "Basic slots length" >:: (fun _ -> assert_equal (List.length app_slots)
                               (find_slots app_board |> List.length));
  "Basic slots direct" >:: (fun _ -> assert_equal
                               (List.sort sort_slots app_slots)
                               (find_slots app_board |> List.sort sort_slots));
]

let blank_surr = {
  left = "";
  right = "";
  above = "";
  below = "";
}

let apple_surr = {blank_surr with left = "pa"; right = "le"}

let string_of_surr surr =
  let li =
    [
      "\nLEFT: " ^ surr.left;
      "RIGHT: " ^ surr.right;
      "ABOVE: " ^ surr.above;
      "BELOW: " ^ surr.below ^ "\n"
    ]
  in
  String.concat "\n" li

let all_surr = {
  left = "aeg";
  right = "pda";
  above = "fed";
  below = "ase"
}

let empty_surr = {
  left = "";
  right = "";
  above = "";
  below = ""
}

let partial_empty_surr = {
  left = "ab";
  below = "cd";
  right = "";
  above = "";
}

let one_surr = {empty_surr with Ai.above = "esapfed"}

let diag_surr = {empty_surr with Ai.right = "d"}

let get_surroundings_test = [
  "No surroundings" >:: (fun _ -> assert_equal blank_surr
                            (get_surroundings empty_board (7,7)));
  "Left right" >:: (fun _ -> assert_equal ~printer:Ai.string_of_surr apple_surr
                       (get_surroundings apple_board (7,8)));
  "All sides" >:: (fun _ -> assert_equal ~printer:Ai.string_of_surr all_surr
                      (get_surroundings all_board (7,7)));
  "Empty surroundings" >:: (fun _ -> assert_equal ~printer:Ai.string_of_surr
                    empty_surr (get_surroundings all_board (0, 0)));
  "Partial empty surr" >:: (fun _ -> assert_equal ~printer:Ai.string_of_surr
                               partial_empty_surr
                               (get_surroundings all_board (11, 14)));
  "One surr" >:: (fun _ -> assert_equal ~printer:Ai.string_of_surr
                    one_surr (get_surroundings all_board (11, 7)));
  "Diag surr" >:: (fun _ -> assert_equal ~printer:Ai.string_of_surr
                      diag_surr (get_surroundings all_board (4, 6)));
]

let a_surr = get_surroundings apple_board (7, 11)
let a_tiles = ['s'; 'g'; 'f']
let b_tiles = ['s'; 't'; 'a'; 'g']

let c_tiles = ['a';'b';'c';'i';'g']
let c_surr = get_surroundings anti_board (7, 11)

let d_tiles = Ai.alphabet
let d_surr = get_surroundings all_board (7, 11)

let string_of_charlist ch = List.map (to_str) ch |> String.concat ""
let sort_chars a b = Char.code a - Char.code b

let valid_chars_test = [
  "apple + s" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                      (['s']) (valid_chars a_surr a_tiles));
  "apple + s/t" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                        (List.sort sort_chars ['t';'s'])
                        (valid_chars a_surr b_tiles |> List.sort sort_chars));
  "anti-everything" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                        (List.sort sort_chars ['a';'b';'c';'g'])
                        (valid_chars c_surr c_tiles |> List.sort sort_chars));
  "no valid chars" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                           []
                           (valid_chars d_surr d_tiles |> List.sort sort_chars));
  "Empty board" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                        Ai.alphabet (valid_chars empty_surr Ai.alphabet));
  "Edge of board 1" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                            [] (valid_chars partial_empty_surr Ai.alphabet));
  "Edge of board 2" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                            ['z'; 'a'; 'e'] (valid_chars
                                     (get_surroundings all_board (13, 0))
                                     ['z'; 'a'; 'e']));
]

let z_surr = get_surroundings all_board (13, 0)

let makes_move_test = [
  "apples" >:: (fun _ -> assert_equal true (makes_move Right a_surr 's'));
  "applet" >:: (fun _ -> assert_equal true (makes_move Right a_surr 't'));
  "applea" >:: (fun _ -> assert_equal false (makes_move Right a_surr 'a'));
  "Edge case 1" >:: (fun _ -> assert_equal true (makes_move Left z_surr 'z'));
  "Edge case 2" >:: (fun _ -> assert_equal true (makes_move Up z_surr 'z'));
  "Edge case 3" >:: (fun _ -> assert_equal false (makes_move Right z_surr 'z'));
]


let makes_prefix_test = [
  "Edge z 1" >:: (fun _ -> assert_equal false (makes_prefix Left z_surr 'z'));
  "Edge z 2" >:: (fun _ -> assert_equal true (makes_prefix Up z_surr 'z'));
  "Main 1 apple+s" >:: (fun _ -> assert_equal true
                           (makes_prefix Right
                              (get_surroundings apple_board (7, 11)) 's'));
  "Main 2 e+apple" >:: (fun _ -> assert_equal
                           true
                           (makes_prefix Left
                              (get_surroundings apple_board (7, 5)) 'e'));
  "No surrs" >:: (fun _ -> assert_equal true (makes_prefix Up empty_surr 'a'));
]


let reverse_str_test = [
  "Empty string" >:: (fun _ -> assert_equal "" (Ai.reverse_str ""));
  "One char string" >:: (fun _ -> assert_equal "a" (Ai.reverse_str "a"));
  "Multi-char 1" >:: (fun _ -> assert_equal "apples" (Ai.reverse_str "selppa"));
  "Multi-char 2" >:: (fun _ -> assert_equal "happy" (Ai.reverse_str "yppah"));
  "Multi-char 3" >:: (fun _ -> assert_equal "ha ha" (Ai.reverse_str "ah ah"));
]

let a_state =
  {
    Game.name = "asdf";
    grid = empty_board;
    players = [];
    remaining_tiles = [];
    turn = 1;
  }

let out_of_bounds_test = [
  "inside" >:: (fun _ -> assert_equal false
                   (out_of_bounds a_state (1,1)));
  "outside 1" >:: (fun _ -> assert_equal true
                      (out_of_bounds a_state (-1,10)));
  "outside 2" >:: (fun _ -> assert_equal true
                      (out_of_bounds a_state (100,1)));
  "both outside 1" >:: (fun _ -> assert_equal true
                           (out_of_bounds a_state (10000, 10000)));
  "both outside 2" >:: (fun _ -> assert_equal true
                           (out_of_bounds a_state (-1, -1)));
]

let sort_anchors = (fun a b -> (fst (fst a)) - (fst (fst b)))
let po_board_anchors = List.sort sort_anchors
    [((0, 2),['d']); ((1,0), []); ((1, 1), ['d'])]
let string_of_anchor a =
  let ((r, c), al) = a in
  string_of_pair (r,c) ^ string_of_charlist al

let string_of_anchor_list al =
  List.fold_left
    (fun acc s -> (string_of_anchor s) ^ "\n" ^ acc)
    ""
    al

let find_anchors_tests = [
  "Empty board" >:: (fun _ -> assert_equal []
                        (find_anchors Grid.empty Ai.alphabet
                           (find_slots Grid.empty)));
  "Full board" >:: (fun _ -> assert_equal []
                       (find_anchors full_board Ai.alphabet
                          (find_slots full_board)));
  "Normal board" >:: (fun _ -> assert_equal ~printer:string_of_anchor_list
                         po_board_anchors
                         (List.sort sort_anchors
                            (find_anchors po_board ['d']
                               (find_slots po_board))));
]

let invalid_pos_tests = [
  "Has char 1" >:: (fun _ -> assert_equal true
                       (invalid_pos {a_state with Game.grid = po_board}
                          (0, 0)));
  "Has char 2" >:: (fun _ -> assert_equal true
                       (invalid_pos {a_state with Game.grid = full_board}
                          (10, 10)));
  "Out of bounds 1" >:: (fun _ -> assert_equal true
                            (invalid_pos a_state (100, 100)));
  "Out of bounds 2" >:: (fun _ -> assert_equal true
                            (invalid_pos a_state (-1, 5)));
  "Good one" >:: (fun _ -> assert_equal
                     false
                     (invalid_pos
                        {a_state with Game.grid = Grid.empty} (3, 3)))
]

let get_next_tests = [
  "Up" >:: (fun _ -> assert_equal ~printer:string_of_pair
               (2,6) (get_next Up (3,6)));
  "Down" >:: (fun _ -> assert_equal ~printer:string_of_pair
                 (12,101) (get_next Down (11, 101)));
  "Left" >:: (fun _ -> assert_equal ~printer:string_of_pair
                 (10, 12) (get_next Left (10, 13)));
  "Right" >:: (fun _ -> assert_equal ~printer:string_of_pair
                  (15, 100) (get_next Right (15, 99)));
]

let next_state = {a_state with Game.grid = all_board}

let search_next_tests = [
  "No new pos 1" >:: (fun _ -> assert_equal None
                         (search_next next_state Down (13, 0)));
  "No new pos 2" >:: (fun _ -> assert_equal None
                         (search_next next_state Right (0, 14)));
  "No new pos 3" >:: (fun _ -> assert_equal None
                         (search_next
                            {a_state with Game.grid = po_board} Left (0, 2)));
  "Some pos 1" >:: (fun _ -> assert_equal (Some (13,3))
                       (search_next next_state Right (13, 0)));
  "Some pos 2" >:: (fun _ -> assert_equal (Some (7,11))
                       (search_next next_state Right (7,3)));
  "Full board" >:: (fun _ -> assert_equal None
                       (search_next
                          {a_state with Game.grid = full_board} Left (7, 7)));
]

let three = ['a'; 'b'; 'c']
let rando = ['f'; 'g'; 'h'; 'i'; 'q']
let mult = ['a'; 'a'; 'a'; 'b']

let rem_tests = [
  "Empty list" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                       [] (rem [] 'a'));
  "One element, remove" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                                [] (rem ['b'] 'b'));
  "One element, stay" >:: (fun _ -> assert_equal  ~printer:string_of_charlist
                              ['c'] (rem ['c'] 'a'));
  "Not in list" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                        three (rem three 'z'));
  "Regular, in list" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                             ['f'; 'g'; 'h'; 'i'] (rem rando 'q'));
  "Mulitple occurrences" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                                 ['a'; 'a'; 'b'] (rem mult 'a'));
]

let sort_chars a b = Char.code a - Char.code b
let cmp_chars a b = (List.sort sort_chars a) = (List.sort sort_chars b)

let no_dups_append_tests = [
  "Both empty" >:: (fun _ -> assert_equal
                       ~printer:string_of_charlist [] (no_dups_append [] []));
  "First empty only" >:: (fun _ -> assert_equal ~printer:string_of_charlist
                             ['b'; 'a']
                             (no_dups_append [] ['a'; 'b']));
  "Second empty only" >:: (fun _ -> assert_equal
                              ~printer:string_of_charlist
                              ['a'] (no_dups_append ['a'] []));
  "First empty, second dups" >:: (fun _ -> assert_equal
                                     ~printer:string_of_charlist
                                     (List.sort sort_chars ['a'; 'b'; 'c'])
                                     (List.sort sort_chars
                                        (no_dups_append
                                           []
                                           ['a'; 'b'; 'a'; 'c'])));
  "Regular dups 1" >:: (fun _ -> assert_equal
                           ~printer:string_of_charlist
                           ~cmp:cmp_chars
                           ['a'; 'x'; 'g'; 'm'; 'n']
                           (no_dups_append
                              ['a'; 'm'; 'n']
                              ['g';'g';'x';'g';'x']));
  "Regular dups 2" >:: (fun _ -> assert_equal
                           ~printer:string_of_charlist
                           ~cmp:cmp_chars
                           ['a'; 'b'; 'c'; 'd']
                           (no_dups_append ['a'; 'b'] ['c'; 'd'; 'c']));
  "Normal append" >:: (fun _ -> assert_equal
                          ~printer:string_of_charlist
                          ~cmp:cmp_chars
                          ['a'; 'b'; 'c'; 'd']
                          (no_dups_append ['a'; 'd'] ['c'; 'b']));
]

let po_surr = get_surroundings po_board (0, 2)

let other_dirs_move_tests = [
  "Empty board" >:: (fun _ -> assert_equal ~printer:string_of_bool
                        true
                        (other_dirs_move Left
                           (get_surroundings Grid.empty (7, 7)) 'a'));
  "Full board" >:: (fun _ -> assert_equal
                       false
                       (other_dirs_move Right
                          (get_surroundings full_board (5, 7)) 'a'));
  "Corner 1" >:: (fun _ -> assert_equal
                     true
                     (other_dirs_move Up z_surr 'z'));
  "Corner 1b" >:: (fun _ -> assert_equal
                      true
                      (other_dirs_move Left z_surr 'z'));
  "Corner 2" >:: (fun _ -> assert_equal
                     true
                     (other_dirs_move Right po_surr 'd'));
  "Corner 2b" >:: (fun _ -> assert_equal
                      false
                      (other_dirs_move Right
                         (get_surroundings all_board (8,6)) 'k'));
  "Middle 1" >:: (fun _ -> assert_equal
                     true
                     (other_dirs_move Right
                        (get_surroundings anti_board (7, 11)) 'f'));
  "Middle 2" >:: (fun _ -> assert_equal false
                     (other_dirs_move Right
                        (get_surroundings anti_board (6, 7)) 'q'));
]

let suite = "A.I. test suite"
            >:::
            find_slots_test @ get_surroundings_test @ valid_chars_test
            @ makes_move_test @ makes_prefix_test @ out_of_bounds_test
            @ reverse_str_test @ find_anchors_tests @ invalid_pos_tests
            @ get_next_tests @ search_next_tests @ rem_tests
            @ no_dups_append_tests @ other_dirs_move_tests

let _ = run_test_tt_main suite
