module Lib.IntTypes.Intrinsics

open FStar.HyperStack
open FStar.HyperStack.All

open Lib.IntTypes
open Lib.Buffer

open FStar.Mul

noextract
val add_carry_u64: cin:uint64 -> x:uint64 -> y:uint64 -> r:lbuffer uint64 (size 1) -> 
  Stack uint64 
    (requires fun h -> live h r /\ v cin <= 1)
    (ensures  fun h0 c h1 -> 
      modifies1 r h0 h1 /\ v c <= 1 /\
      (let r = Seq.index (as_seq h1 r) 0 in 
       v r + v c * pow2 64 == v x + v y + v cin))


(*The precondition  v x + v y + v cin <= pow2 64 - 1 comes from the fact that we except the carry value to be equal to 0 *)
noextract
val add_carry_u64_void: cin:uint64 -> x:uint64 -> y:uint64 -> r:lbuffer uint64 (size 1) -> 
  Stack unit 
  (requires fun h -> live h r /\ v cin <= 1)
  (ensures  fun h0 _ h1 -> modifies1 r h0 h1 /\ (
    let r = Seq.index (as_seq h1 r) 0 in 
    v r == (v x + v y + v cin) % pow2 64
  )
)

noextract
val sub_borrow_u64: cin:uint64 -> x:uint64 -> y:uint64 -> r:lbuffer uint64 (size 1) -> 
  Stack uint64
    (requires fun h -> live h r /\ v cin <= 1)
    (ensures  fun h0 c h1 -> 
      modifies1 r h0 h1 /\ 
      (let r = Seq.index (as_seq h1 r) 0 in 
       v r - v c * pow2 64 == v x - v y - v cin))

(* The precondition v x >= v y + v cin comes from the fact that we expect the return value to be equal to 0  *)
noextract
val sub_borrow_u64_void: cin: uint64 -> x:uint64 -> y:uint64 -> r:lbuffer uint64 (size 1) -> 
  Stack unit
    (requires fun h -> live h r /\ v cin <= 1 /\ v x >= v y + v cin)
    (ensures  fun h0 _ h1 -> 
      modifies1 r h0 h1 /\ 
      (let r = Seq.index (as_seq h1 r) 0 in 
       v r == v x - v y - v cin))
