module Hacl.Spec.P256.Montgomery

open FStar.Mul

module S = Spec.P256

#set-options "--z3rlimit 50 --fuel 0 --ifuel 0"

///  Montgomery arithmetic for a base field

let fmont_R = pow2 256
let fmont_R_inv = S.modp_inv2_prime (pow2 256) S.prime

let from_mont (a:int) : S.felem = a * fmont_R_inv % S.prime
let to_mont   (a:int) : S.felem = a * fmont_R % S.prime

// used in Hacl.Impl.P256.Field
val lemma_mod_mul_pow256_prime: a:int -> b:int -> Lemma
  (requires a * pow2 256 % S.prime = b * pow2 256 % S.prime)
  (ensures  a % S.prime == b % S.prime)

// used in Hacl.Impl.P256.Point
val lemma_multiplication_not_mod_prime: a:S.felem ->
  Lemma (a * fmont_R_inv % S.prime == 0 <==> a == 0)

val lemma_to_from_mont_id: a:S.felem -> Lemma (from_mont (to_mont a) == a)
val lemma_from_to_mont_id: a:S.felem -> Lemma (to_mont (from_mont a) == a)

val fmont_mul_lemma: a:S.felem -> b:S.felem ->
  Lemma (S.fmul (from_mont a) (from_mont b) = from_mont ((a * b * fmont_R_inv) % S.prime))

val fmont_add_lemma: a:S.felem -> b:S.felem ->
  Lemma (S.fadd (from_mont a) (from_mont b) = from_mont ((a + b) % S.prime))

val fmont_sub_lemma: a:S.felem -> b:S.felem ->
  Lemma (S.fsub (from_mont a) (from_mont b) = from_mont ((a - b) % S.prime))


///  Montgomery arithmetic for a scalar field

// used in Hacl.Impl.P256.Scalar
val lemma_mod_mul_pow256_order: a:int -> b:int -> Lemma
  (requires a * pow2 256 % S.order = b * pow2 256 % S.order)
  (ensures  a % S.order == b % S.order)
