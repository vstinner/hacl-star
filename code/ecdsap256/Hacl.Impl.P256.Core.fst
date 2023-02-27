module Hacl.Impl.P256.Core

open FStar.Mul
open FStar.HyperStack.All
open FStar.HyperStack
module ST = FStar.HyperStack.ST

open Lib.IntTypes
open Lib.Buffer

open Hacl.Spec.P256.Felem
open Hacl.Spec.P256.MontgomeryMultiplication

open Hacl.Impl.P256.SolinasReduction
open Hacl.Impl.P256.Bignum
open Hacl.Impl.P256.Field

module S = Spec.P256

#set-options "--z3rlimit 50 --fuel 0 --ifuel 0"

// TODO: mv to Hacl.Impl.P256.Field
inline_for_extraction noextract
val toDomain: f:felem -> res:felem -> Stack unit
  (requires fun h ->
    live h f /\live h res /\ eq_or_disjoint f res /\
    as_nat h f < S.prime)
  (ensures fun h0 _ h1 -> modifies (loc res) h0 h1 /\
    as_nat h1 res = toDomain_ (as_nat h0 f))

let toDomain f res =
  push_frame ();
  let multBuffer = create (size 8) (u64 0) in
  bn_lshift256 f multBuffer;
  solinas_reduction_impl multBuffer res;
  pop_frame()



// TODO: mv to Hacl.Impl.P256.Field
inline_for_extraction noextract
val fromDomain: f:felem -> res:felem -> Stack unit
  (requires fun h -> live h f /\ live h res /\ as_nat h f < S.prime)
  (ensures fun h0 _ h1 -> modifies (loc res) h0 h1 /\
    as_nat h1 res = (as_nat h0 f * mont_R_inv) % S.prime /\
    as_nat h1 res = fromDomain_ (as_nat h0 f))

let fromDomain f res =
  montgomery_multiplication_buffer_by_one f res
