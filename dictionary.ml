module CharMap = Map.Make(Char)

  (*Empty exists so that empty nodes can be used in
    add to pass the lack of information to the child.
    The node variant wrapper is required for self reference*)
  type t = Empty | Node of (char option)*children*bool
  and children = t CharMap.t

  (*The root of my trie is logically an empty character, from
    which any word can be extended*)
  let empty = Node (None,CharMap.empty,false)

  let is_empty n = n=empty

  let rec print_ugly_helper c d = match d with
  |(Node ((Some b), m,_)) ->
  if m = CharMap.empty then print_char c
    else print_char c; CharMap.iter print_ugly_helper m
  |_ -> ()

  (*Lists the letters that are children of a node*)
  let print_ugly n = match n with
  |Node (c,m,_) -> CharMap.iter print_ugly_helper m
  |_ -> ()

  let rec add_helper s on =  if (String.length s) < 2 then
  Node (Some (String.get s 0),CharMap.empty,true) else
  let child_string = String.sub s 1 (String.length s - 1) in
  match on with
  |Node (_,m,word) ->
    if CharMap.mem (String.get child_string 0) m then let old_node =
      CharMap.find (String.get child_string 0) m in
      Node ((Some (String.get s 0)), CharMap.add
        (String.get child_string 0) (add_helper child_string old_node) m,word)
    else  Node ((Some (String.get s 0)), CharMap.add
        (String.get child_string 0) (add_helper child_string Empty) m,word)
  |Empty -> Node ((Some (String.get s 0)), CharMap.add
        (String.get child_string 0) (add_helper child_string Empty) CharMap.empty,false)

  (**)
  let add s n = match n with
  |Node (c,m,word) -> if CharMap.mem (String.get s 0) m then
    let old_node = CharMap.find (String.get s 0) m in
    Node (c, CharMap.add (String.get s 0) (add_helper s old_node) m,word)
  else Node (c, CharMap.add (String.get s 0) (add_helper s Empty) m,word)
  |Empty -> failwith"please add to \"empty\" "

  (* //////////////// THIS WHOLE SECTION HAS A TON OF REPEATED CODE
    ///////////////// I WILL REMEDY THIS SOON*)
  (*Theres probably a cleaner way to do this but this was the safest
    way I thought of doing it*)
  let rec mem s n = if s = "" then true else match n with
  |Empty -> false
  |Node(c,m,_) -> match c with
    |None -> (try(mem s
        (CharMap.find (String.get s 0) m)) with _ -> false)
    |Some d when (d = String.get s 0) -> if String.length s = 1 then true else
      try (mem (String.sub s 1 (String.length s - 1))
        (CharMap.find (String.get s 1) m)) with _ -> false

  (*If we ever need this I'll implement it*)
  let remove s t = t

  (*Slightly modified version of mem*)
  let rec is_leaf s t = match t with
  |Empty -> false
  |Node(c,m,_) -> match c with
    |None -> (try(is_leaf s
        (CharMap.find (String.get s 0) m)) with _ -> false)
    |Some d when (d = String.get s 0) -> if String.length s = 1 then
      CharMap.is_empty m else
      try (is_leaf (String.sub s 1 (String.length s - 1))
        (CharMap.find (String.get s 1) m)) with _ -> false

  (*Once again copied code, not sure of better way to do it*)
  let rec is_valid_word s t = match t with
  |Empty -> false
  |Node(c,m,word) -> match c with
    |None -> (try(is_valid_word s
        (CharMap.find (String.get s 0) m)) with _ -> false)
    |Some d when (d = String.get s 0) -> if String.length s = 1 then
      word else
      try (is_valid_word (String.sub s 1 (String.length s - 1))
        (CharMap.find (String.get s 1) m)) with _ -> false
    |_ -> false


  let rec add_words t accum str = match t with
  |Empty -> []
  |Node(_,m,_) -> if CharMap.is_empty m then accum else List.flatten (List.map
    (fun h -> (let new_str = (str ^ String.make 1 h) in
      let new_node = (CharMap.find h m) in match new_node with Node (a,b,c) ->
        if c then add_words new_node (new_str::accum) new_str
      else add_words new_node accum new_str)) (List.map (fun (a,b) -> a) (CharMap.bindings m)))


  let rec extend s t words str = match t with
  |Empty -> []
  |Node(c,m,word) -> match c with
    |None ->(try(extend s
        (CharMap.find (String.get s 0) m) words str) with _ -> words)
    |Some d when (d = String.get s 0) -> if String.length s = 1 then
      add_words t [] str else
      try (extend (String.sub s 1 (String.length s - 1))
        (CharMap.find (String.get s 1) m) words str) with _ -> words

  let rec extensions s t = extend s t [] s

  let make s = add s empty;;