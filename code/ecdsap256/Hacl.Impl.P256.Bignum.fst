module Hacl.Impl.P256.Bignum

open FStar.Mul
open FStar.HyperStack.All
open FStar.HyperStack
module ST = FStar.HyperStack.ST

open Lib.IntTypes
open Lib.Buffer

open Hacl.Spec.P256.Bignum
module BN = Hacl.Bignum
module SN = Hacl.Spec.Bignum

#set-options "--z3rlimit 50 --fuel 0 --ifuel 0"

///  Create a bignum

let create_felem () =
  create 4ul (u64 0)


let create_widefelem () =
  create 8ul (u64 0)


let bn_make_u64_4 res a0 a1 a2 a3 =
  assert_norm (pow2 64 * pow2 64 = pow2 128);
  assert_norm (pow2 64 * pow2 64 * pow2 64 = pow2 192);
  upd res 0ul a0;
  upd res 1ul a1;
  upd res 2ul a2;
  upd res 3ul a3


///  Create zero and one

let bn_set_zero4 f =
  bn_make_u64_4 f (u64 0) (u64 0) (u64 0) (u64 0)


let bn_set_one4 f =
  bn_make_u64_4 f (u64 1) (u64 0) (u64 0) (u64 0)


///  Comparison

[@CInline]
let bn_is_zero_vartime4 f =
  let open Lib.RawIntTypes in
  let (f0, f1, f2, f3) = (f.(0ul), f.(1ul), f.(2ul), f.(3ul)) in
  u64_to_UInt64 f0 =. 0uL &&
  u64_to_UInt64 f1 =. 0uL &&
  u64_to_UInt64 f2 =. 0uL &&
  u64_to_UInt64 f3 =. 0uL


[@CInline]
let bn_is_zero_mask4 f =
  let h0 = ST.get () in
  SN.bn_is_zero_mask_lemma (as_seq h0 f);
  bn_v_is_as_nat (as_seq h0 f);
  BN.bn_is_zero_mask #U64 4ul f


[@CInline]
let bn_is_eq_vartime4 a b =
  let open Lib.RawIntTypes in
  let (a0, a1, a2, a3) = (a.(0ul), a.(1ul), a.(2ul), a.(3ul)) in
  let (b0, b1, b2, b3) = (b.(0ul), b.(1ul), b.(2ul), b.(3ul)) in
  u64_to_UInt64 a0 =. u64_to_UInt64 b0 &&
  u64_to_UInt64 a1 =. u64_to_UInt64 b1 &&
  u64_to_UInt64 a2 =. u64_to_UInt64 b2 &&
  u64_to_UInt64 a3 =. u64_to_UInt64 b3


[@CInline]
let bn_is_eq_mask4 a b =
  let h0 = ST.get () in
  SN.bn_eq_mask_lemma (as_seq h0 a) (as_seq h0 b);
  bn_v_is_as_nat (as_seq h0 a);
  bn_v_is_as_nat (as_seq h0 b);
  BN.bn_eq_mask #U64 4ul a b


let bn_is_odd4 f =
  let h0 = ST.get () in
  bn_v_is_as_nat (as_seq h0 f);
  SN.bn_is_odd_lemma (as_seq h0 f);
  BN.bn_is_odd 4ul f


///  Conditional copy

[@CInline]
let bn_copy_conditional4 res mask x y =
  Lib.ByteBuffer.buf_mask_select y x mask res


[@CInline]
let bn_cmovznz4 res cin x y =
  let mask = neq_mask cin (u64 0) in
  Lib.ByteBuffer.buf_mask_select y x mask res


///  Addition and subtraction

[@CInline]
let bn_add_mod4 res n x y =
  let h0 = ST.get () in
  BN.bn_add_mod_n 4ul n x y res;
  let h1 = ST.get () in
  bn_v_is_as_nat (as_seq h0 n);
  bn_v_is_as_nat (as_seq h0 x);
  bn_v_is_as_nat (as_seq h0 y);
  SN.bn_add_mod_n_lemma (as_seq h0 n) (as_seq h0 x) (as_seq h0 y);
  bn_v_is_as_nat (as_seq h1 res)


[@CInline]
let bn_sub4 res x y =
  assert_norm (pow2 64 * pow2 64 * pow2 64 * pow2 64 = pow2 256);
  let h0 = ST.get () in
  let c = BN.bn_sub_eq_len 4ul x y res in
  let h1 = ST.get () in
  SN.bn_sub_lemma (as_seq h0 x) (as_seq h0 y);
  bn_v_is_as_nat (as_seq h0 x);
  bn_v_is_as_nat (as_seq h0 y);
  bn_v_is_as_nat (as_seq h1 res);
  c


[@CInline]
let bn_sub_mod4 res n x y =
  let h0 = ST.get () in
  BN.bn_sub_mod_n 4ul n x y res;
  let h1 = ST.get () in
  bn_v_is_as_nat (as_seq h0 n);
  bn_v_is_as_nat (as_seq h0 x);
  bn_v_is_as_nat (as_seq h0 y);
  SN.bn_sub_mod_n_lemma (as_seq h0 n) (as_seq h0 x) (as_seq h0 y);
  bn_v_is_as_nat (as_seq h1 res)


///  Multiplication

[@CInline]
let bn_mul4 res x y =
  let h0 = ST.get () in
  BN.bn_mul #U64 4ul 4ul x y res;
  let h1 = ST.get () in
  SN.bn_mul_lemma (as_seq h0 x) (as_seq h0 y);
  bn_v_is_as_nat (as_seq h0 x);
  bn_v_is_as_nat (as_seq h0 y);
  bn_v_is_wide_as_nat (as_seq h1 res)


[@CInline]
let bn_sqr4 res x =
  let h0 = ST.get () in
  BN.bn_sqr #U64 4ul x res;
  let h1 = ST.get () in
  SN.bn_sqr_lemma (as_seq h0 x);
  bn_v_is_as_nat (as_seq h0 x);
  bn_v_is_wide_as_nat (as_seq h1 res)


///  pow2-operations

val lemma_shift_256: a: int -> b: int -> c: int -> d: int -> Lemma (
    a * pow2 64 * pow2 64 * pow2 64 * pow2 64 +
    b * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 +
    c * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64  +
    d * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 * pow2 64 ==
    (a + b * pow2 64 + c * pow2 64 * pow2 64 + d * pow2 64 * pow2 64 * pow2 64) * pow2 64 * pow2 64 * pow2 64 * pow2 64)

let lemma_shift_256 a b c d = ()


[@CInline]
let bn_lshift256 res x =
  assert_norm (pow2 64 * pow2 64 * pow2 64 * pow2 64 = pow2 256);

  let h0 = ST.get () in
  upd res 0ul (u64 0);
  upd res 1ul (u64 0);
  upd res 2ul (u64 0);
  upd res 3ul (u64 0);
  upd res 4ul x.(0ul);
  upd res 5ul x.(1ul);
  upd res 6ul x.(2ul);
  upd res 7ul x.(3ul);

  lemma_shift_256
    (v (Lib.Sequence.index (as_seq h0 x) 0))
    (v (Lib.Sequence.index (as_seq h0 x) 1))
    (v (Lib.Sequence.index (as_seq h0 x) 2))
    (v (Lib.Sequence.index (as_seq h0 x) 3))


///  Conversion between bignum and bytes representation

[@CInline]
let bn_to_bytes_be4 res f =
  let h0 = ST.get () in
  bn_v_is_as_nat (as_seq h0 f);
  Hacl.Spec.Bignum.Convert.bn_to_bytes_be_lemma #U64 32 (as_seq h0 f);
  Hacl.Bignum.Convert.mk_bn_to_bytes_be true 32ul f res


[@CInline]
let bn_from_bytes_be4 res b =
  let h0 = ST.get () in
  Hacl.Spec.Bignum.Convert.bn_from_bytes_be_lemma #U64 32 (as_seq h0 b);
  Hacl.Bignum.Convert.mk_bn_from_bytes_be true 32ul b res;
  let h1 = ST.get () in
  bn_v_is_as_nat (as_seq h1 res)
