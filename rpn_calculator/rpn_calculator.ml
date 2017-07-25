(**
   Copyright (c) 2016 André Roque Matheus - All Rights Reserved
   Licensed under MIT License, see LICENSE.md
*)
open Core

module type RpnValue = sig
  type t
  val of_string: string -> t
  val print: t -> unit
end

module type RPN_CALCULATOR = sig
  type t
  val evaluate: string -> t list -> t list
  val evaluate_stdin: t list -> unit
  val operation: string -> int -> (t list -> t) -> unit
  val binop: (t -> t -> t) -> t list -> t
end

module RpnCalculator(V: RpnValue) : RPN_CALCULATOR with type t = V.t = struct
  type t = V.t

  type operation = {
    arity: int;
    fn: t list -> t
  }

  let operations = String.Table.create ()

  let operation name arity fn =
    Hashtbl.set operations ~key:name ~data:{ arity=arity; fn=fn }

  let binop f ops =
    match ops with
    | x::y::rest -> f y x
    | _ -> raise (Failure "Expected two operands")

  let do_operation {arity; fn} s =
    let h, t = List.split_n s arity in
    let result = fn h in
    result::t

  let evaluate expr s =
    let eval_token token stack =
      match Hashtbl.find operations token with
      | Some o -> do_operation o stack
      | None -> try (V.of_string token)::stack
        with _ -> raise (Failure (Printf.sprintf "Invalid token: %s" token)) in
    let rec eval_rec tokens stack =
      match tokens with
      | [] -> stack
      | token::rest -> eval_rec rest (eval_token token stack) in
    eval_rec (String.split expr ~on:' ') s

  let rec evaluate_stdin s =
    match In_channel.input_line In_channel.stdin with
    | Some l -> let result = evaluate l s in
      V.print (List.hd_exn result);
      Out_channel.flush Out_channel.stdout;
      print_endline "";
      evaluate_stdin result
    | None -> Out_channel.flush Out_channel.stdout
end

module FloatCalculator = RpnCalculator(struct
    type t = float
    let of_string = Float.of_string
    let print = Printf.printf "%.4f"
  end)

let () =
  FloatCalculator.(
    operation "+" 2 (binop (+.));
    operation "-" 2 (binop (-.));
    operation "*" 2 (binop ( *.));
    operation "/" 2 (binop (/.))
  );
  FloatCalculator.evaluate_stdin []
