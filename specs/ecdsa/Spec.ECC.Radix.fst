module Spec.ECC.Radix

open FStar.Mul

open Lib.ByteSequence
open Lib.IntTypes
open Lib.Sequence
open Lib.RawIntTypes

open Lib.LoopCombinators 

open FStar.Math.Lemmas
open FStar.Math.Lib

open Spec.ECC.Curves

open Spec.ECC


#set-options "--fuel 0 --ifuel 0 --z3rlimit 100"

let radix = 4


val toAffine: #c: curve -> #coordSystem : coordSyst -> p: point #c #coordSystem -> point #c #Affine

let toAffine #c #coordSystem p = 
  match coordSystem with 
  |Affine -> p
  |Jacobian -> 
    if isPointAtInfinity p then 
      pointAtInfinity #c #Affine 
    else
      let pNormX, pNormY, pNormZ = _norm #c p in 
      (pNormX, pNormY)

val lemma_is_point_on_curve: #c: curve -> p: point #c #Jacobian {~ (isPointAtInfinity p) /\ pointOnCurve #c p} 
  -> Lemma (
    let pX, pY, pZ = p in 
    ~ (pX == 0 /\ pY == 0))

let lemma_is_point_on_curve #c p = 
  let pX, pY, pZ = p in 
  if (pX = 0 && pY = 0) then
    begin
      assert(pointOnCurve #c p);
      let prime = getPrime c in 
      small_mod (bCoordinate #c) prime; 
      assert(	0 == bCoordinate #c);
      assert(False)
    end


val lemma_toAffine_fromAffine: #c: curve -> p: point #c #Jacobian {isPointAtInfinity p \/ pointOnCurve #c p} -> Lemma (
  let pA = toAffine p in 
  let pAJ = toJacobianCoordinates pA in 
  pointEqual pAJ p)

let lemma_toAffine_fromAffine #c p = 
  let pAx, pAy = toAffine p in 
  let pAJ = toJacobianCoordinates #c (pAx, pAy) in 

  if isPointAtInfinity p then () else begin
    let x, y, z = p in 
    
    assert(pAx == (modp_inv2 #c (z * z) * x) % getPrime c);
    assert(pAy == (modp_inv2 #c (z * z * z) * y) % getPrime c);
    assert(z <> 0);

    lemma_is_point_on_curve #c p;
    
    assume (pAx <> 0 \/ pAy <> 0);
    
    assume (
      let pAffineX, pAffineY, pAffineZ = _norm p in 
      let qAffineX, qAffineY, qAffineZ = _norm #c (_norm p) in 

      pAffineX = qAffineX && pAffineY = qAffineY);


    assert (pointEqual (pAx, pAy, 1) p)
  end


val getPrecomputedPoint_Affine: #c: curve -> p: point #c #Jacobian -> i: nat {i < 16} -> 
  Tot (r: point #c #Affine {
    pointEqual (toJacobianCoordinates r) (point_mult #c i p) /\ (
    if i = 0 then isPointAtInfinity #c #Affine r 
    else 
      isPointAtInfinity #c #Affine r == false)})

let getPrecomputedPoint_Affine #c p i = 
  let r : point #c #Affine = 
    if i = 0 then 
      begin
      	point_mult_0 #c p i;
	pointAtInfinity #c #Affine
      end
    else begin
      let r = toAffine (point_mult #c i p) in 
      assume (isPointAtInfinity #c #Affine r == false);
      r
    end in 
  assume (pointOnCurve (point_mult #c i p));
  lemma_toAffine_fromAffine (point_mult #c i p);
  r


val getPrecomputedPoint_Jacobian: #c: curve -> p: point #c #Jacobian -> i: nat -> 
  Tot (r: point #c #Jacobian {pointEqual r (point_mult #c i p)})

let getPrecomputedPoint_Jacobian #c p i = 
  point_mult #c i p
 

val getPrecomputedPoint: #c: curve -> #t: coordSyst -> p: point #c #Jacobian -> i: nat {i < 16} -> 
  Tot (r: point #c #Jacobian {pointEqual r (point_mult #c i p)})

let getPrecomputedPoint #c #t p i = 
  match t with 
  |Affine -> toJacobianCoordinates (getPrecomputedPoint_Affine #c p i)
  |Jacobian -> getPrecomputedPoint_Jacobian #c p i


val repeatAsDoubling: #c: curve -> p: point #c #Jacobian -> i: nat -> Lemma (
  let r = repeat #(point_nat_prime #c) i (_point_double #c) p in 
  pointEqual r (point_mult #c  (pow2 i) p))

let rec repeatAsDoubling #c p i = 
  match i with 
  |0 -> 
    point_mult_1 #c p;
    eq_repeat0 (_point_double) p
  | _ -> 
    repeatAsDoubling #c p (i - 1);
    
    let r = repeat #(point_nat_prime #c) (i - 1) (_point_double #c) p in 
    unfold_repeat i _point_double p (i - 1);     
    let ri = repeat #(point_nat_prime #c) i (_point_double #c) p in 

    let l = point_mult #c (pow2 (i - 1)) p in
    let li = point_mult #c (pow2 i) p in
    
    lemmaApplPointDouble  #c  p (pow2 (i - 1)) l;
    pow2_double_mult (i - 1); 
    curve_compatibility_with_translation_lemma  #c  r l r


val getPointDoubleNTimes: #c: curve -> p: point_nat_prime #c -> i: nat -> 
  Tot (r: point_nat_prime #c {pointEqual r (point_mult #c (pow2 i) p)})

let getPointDoubleNTimes #c p i = 
  let r = repeat #(point_nat_prime #c) i (_point_double #c) p in 
  repeatAsDoubling #c p i;
  r


val radix_step: #c: curve -> #t: coordSyst -> k: scalar_bytes #c 
  -> p0: point #c #Jacobian
  -> i: nat {v (getScalarLen c) / radix - 1 > i} 
  -> p: point #c #Jacobian
  -> point #c #Jacobian

let radix_step #c #t k p0 i p =
  let scalar = scalar_as_nat k in 
  let l = v (getScalarLen c) in 
  let si = arithmetic_shift_right scalar (l - (i + 2) * radix) % pow2 radix in 
  let pRadixed = getPointDoubleNTimes #c p radix in 
  let pointPrecomputed = getPrecomputedPoint #c #t p0 si in 
  pointAdd #c pRadixed pointPrecomputed

val lemmaIsPointAtInf: #c: curve ->  q: point_nat_prime #c  ->
  Lemma (requires  (let x, y, z = q in z == 0))
  (ensures isPointAtInfinity #c #Jacobian q)

let lemmaIsPointAtInf #c q = ()


#push-options " --ifuel 1"

val pointAddDoubleWithTwoPointInfinity: #c: curve -> 
  q: point_nat_prime #c {isPointAtInfinity #c #Jacobian q} ->
  r: point_nat_prime #c {isPointAtInfinity #c #Jacobian r} -> 
  Lemma (pointEqual (_point_add #c q r) (pointAdd #c  q r))

let pointAddDoubleWithTwoPointInfinity #c q r = 
   small_mod 0 (getPrime c)

#pop-options 


val curve_distributivity: #c: curve -> p0: point_nat_prime #c 
  -> a: nat  
  -> q: point_nat_prime #c {pointEqual q (point_mult #c  a p0)}
  -> Lemma (pointEqual q (point_mult #c (a % getOrder #c) p0))

let curve_distributivity #c p0 a q = lemma_scalar_reduce #c p0 a

val pointAddNotEqual: #c: curve ->
  p0: point_nat_prime #c ->
  b: nat -> 
  r: point_nat_prime #c {pointEqual r (point_mult #c b p0)} ->
  a: nat -> 
  q: point_nat_prime #c {pointEqual q (point_mult #c a p0)} -> 
  Lemma 
  (requires ((a < b \/ isPointAtInfinity #c #Jacobian r) /\ a < getOrder #c))
  (ensures (
    if isPointAtInfinity #c #Jacobian q && isPointAtInfinity #c #Jacobian  r then 
      pointEqual (_point_add #c q r) (pointAdd #c  q r) 
    else 
      ~ (pointEqual #c q r) /\ ~ (pointEqual #c r q)) )
  

let pointAddNotEqual #c p0 b r a q = 
  admit(); 
  if isPointAtInfinity #c #Jacobian q && isPointAtInfinity #c #Jacobian r then 
    pointAddDoubleWithTwoPointInfinity q r
  else if isPointAtInfinity #c #Jacobian q then ()
  else if isPointAtInfinity #c #Jacobian r then () 
  else begin
    let order = getOrder #c in 
    let aPrime = getOrder #c - a in 
    let qPrime = point_mult #c  aPrime p0 in 
    let aQprime = pointAdd #c  q qPrime in 
    lemmaApplPointAdd #c p0 a q aPrime qPrime;
    point_mult_0 #c  p0 (a + aPrime);

  if (aPrime + b < order) then 
    begin
      curve_order_is_the_smallest #c  p0;
      assert(~ (isPointAtInfinity #c #Jacobian (point_mult #c (aPrime + b) p0)));
      assert(~ (pointEqual #c q r))
    end
  else 
    begin
      assert(aPrime + b >= order);
      assert(a < b);
      curve_distributivity p0 (aPrime + b) (point_mult #c (aPrime + b) p0);
      assert(pointEqual (point_mult #c  (aPrime + b) p0) (point_mult #c  ((aPrime + b) % order) p0));
      curve_order_is_the_smallest #c  p0
    end
  end


val curve_multiplication_distributivity: 
  #c: curve ->
  p0: point_nat_prime #c ->
  a: nat -> 
  q: point_nat_prime #c {pointEqual q (point_mult #c a p0)} ->
  b: nat -> 
  r: point_nat_prime #c {pointEqual r (point_mult #c  b q)} -> 
  Lemma (pointEqual r (point_mult #c (a * b) p0))


let rec curve_multiplication_distributivity #c p0 a q b r = 
  match b with 
  |0 -> 
    point_mult_0 #c  q 0; 
    point_mult_0 #c  p0 0
  |_ -> 
    let r1 = point_mult #c  (b - 1) q in 
    curve_multiplication_distributivity #c p0 a q (b - 1) r1;
    let a_1 = point_mult #c  (a * (b - 1)) p0 in 
    let a0 = point_mult #c  (a * b) p0 in 

    curve_compatibility_with_translation_lemma #c  q (point_mult #c  a p0) a_1;
    assert(pointEqual (pointAdd #c  q a_1) (pointAdd #c  (point_mult #c  a p0) a_1));
    lemmaApplPointAdd #c  p0 a (point_mult #c  a p0) (a * (b - 1)) a_1;

    let open FStar.Tactics in 
    let open FStar.Tactics.Canon in 
    assert_by_tactic (a + (a * (b - 1)) == a * b) canon;
    assert(pointEqual (pointAdd #c  (point_mult #c  a p0) a_1) a0);
    curve_commutativity_lemma #c  q a_1;
    point_mult_1 #c  q; 
    lemmaApplPointAdd #c  q (b - 1) r1 1 q;
    curve_compatibility_with_translation_lemma #c  r1 (point_mult #c  (a * (b - 1)) p0) q


val lemma_mixed: #c: curve -> p: point #c #Jacobian -> q: point #c #Affine 
  -> Lemma (_point_add p q == _point_add p (toJacobianCoordinates q))

let lemma_mixed #c p q = ()


val pred0: #c: curve -> #t: coordSyst -> x: point #c #Jacobian
  -> s: scalar_bytes #c {scalar_as_nat s < getOrder #c} 
  -> p0: point #c #Jacobian
  -> i: nat {v (getScalarLen c) >= (i + 2) * radix}  ->
  Lemma (
    let l = v (getScalarLen c) in 
    let f = radix_step #c #t s p0 in
    let pred (i: nat {v (getScalarLen c) >= (i + 1) * radix}) p = (
      let scalar = scalar_as_nat s in 
      let partialScalar = arithmetic_shift_right scalar (l - (i + 1) * radix) in  
      pointEqual p (point_mult #c  partialScalar p0)) in
    pred i x ==> pred (i + 1) (f i x))


let pred0 #c #t x s p0 i =
  let scalar = scalar_as_nat s in 
  let order = getOrder #c in 
  let l = v (getScalarLen c) in 
  let partialScalar = arithmetic_shift_right scalar (l - (i + 1) * radix) in 
  let b = pow2 radix * partialScalar in 

  if pointEqual x (point_mult #c partialScalar p0) then begin
    let si = arithmetic_shift_right scalar (l - (i + 2) * radix) % pow2 radix in 
    let pRadixed = getPointDoubleNTimes x radix in 
    let pointPrecomputed = getPrecomputedPoint #c #t p0 si in 
    let p = pointAdd #c pRadixed pointPrecomputed in
    curve_multiplication_distributivity #c p0 partialScalar x (pow2 radix) pRadixed;
    if si > 0 && partialScalar > 0 then
      assert(si < pow2 radix * partialScalar)
    else begin 
      assert(si = 0 || partialScalar = 0);
      if si = 0 then 
	if partialScalar = 0 then begin
	  point_mult_0 #c p0 0;
	  assert(isPointAtInfinity #c pointPrecomputed /\ isPointAtInfinity #c #Jacobian pRadixed) end
	else 
	  assert(si < b)
      else
	begin
	  assert(partialScalar = 0);
	  point_mult_0 #c p0 0;
	  assert(isPointAtInfinity #c #Jacobian pRadixed)
	end 
  end;

  begin match t with
    |Affine ->
      if si = 0 then begin
	assert(pointEqual pRadixed (point_mult (pow2 radix) x));
	assert(p == pointAdd pRadixed pointPrecomputed);
	assert(si == 0);

	assert(pointPrecomputed == getPrecomputedPoint #c #t p0 si); 
	assert(isPointAtInfinity #c pointPrecomputed);
	
	curve_point_at_infinity_property #c pRadixed;
	curve_commutativity_lemma #c pRadixed pointPrecomputed;
	assert(pointEqual p (point_mult (si + partialScalar * pow2 radix) p0))
	end
      else begin
	assert(pointEqual pRadixed (point_mult (pow2 radix) x));
	assert(p == pointAdd pRadixed pointPrecomputed);
	assert(pointPrecomputed == toJacobianCoordinates (getPrecomputedPoint #c #t p0 si));

	assert(pointEqual p (pointAdd pRadixed pointPrecomputed));
	
	pointAddNotEqual p0 b pRadixed si (toJacobianCoordinates pointPrecomputed);
	
	lemmaApplPointAdd #c p0 (pow2 radix * partialScalar) pRadixed si (toJacobianCoordinates (getPrecomputedPoint #c #t p0 si));

	(* C == A *)
      	assert(pointEqual p (pointAdd pRadixed pointPrecomputed));
	(* B == D *)
	assert(pointEqual (pointAdd pRadixed (toJacobianCoordinates pointPrecomputed)) (point_mult (pow2 radix * partialScalar + si) p0));

	assert(pointEqual p (pointAdd pRadixed (toJacobianCoordinates pointPrecomputed)));
	assert(pointEqual p (point_mult (pow2 radix * partialScalar + si) p0))
      end
    |Jacobian -> 
	pointAddNotEqual p0 b pRadixed si pointPrecomputed;
	lemmaApplPointAdd #c p0 (pow2 radix * partialScalar) pRadixed si pointPrecomputed;
	curve_commutativity_lemma #c pRadixed pointPrecomputed;
	assert(pointEqual p (point_mult (si + pow2 radix * partialScalar) p0)) end;
    lemma_div_mod (div scalar (pow2 (l - (i + 2) * radix))) (pow2 radix);
    division_multiplication_lemma scalar (pow2 (l - (i + 2) * radix)) (pow2 radix);
    pow2_plus (l - (i + 2) * radix) radix
  end


val lemma_predicate0: #c: curve -> #t: coordSyst 
  -> s: scalar_bytes #c  {scalar_as_nat s < getOrder #c} -> p0: point_nat_prime #c -> 
  Lemma (
    let l = v (getScalarLen c) in 
    let len = l / radix - 1 in 
    let f = radix_step #c #t s p0 in
    let pred (i: nat {i <= len}) p : Type0 = (
      let scalar = scalar_as_nat s in 
      let partialScalar = arithmetic_shift_right scalar (l - (i + 1) * radix) in  
      pointEqual p (point_mult #c partialScalar p0)) in 
  forall (i: nat {i < len}) (x: point_nat_prime #c). pred i x ==> pred (i + 1) (f i x))

let lemma_predicate0 #c #t s p0 = 
  let pred = pred0 #c #t in
  Classical.forall_intro_4 pred


val radix_spec: #c: curve -> #t: coordSyst 
  -> s: scalar_bytes #c {v (getScalarLen c) % radix == 0 /\ scalar_as_nat s < getOrder #c}
  -> i: point #c #Jacobian 
  -> r: point #c #Jacobian {
    pointEqual r (point_mult #c (scalar_as_nat #c s) i)}


let radix_spec #c #t s p0 = 
  let scalarNat = scalar_as_nat s in 
  let l = v (getScalarLen c) in  
    scalar_as_nat_upperbound s l;
    lemma_div_lt_nat scalarNat l radix;
  let pointToStart = toJacobianCoordinates 
    (getPrecomputedPoint #c #t p0 (arithmetic_shift_right scalarNat (l - radix))) in  

  let len = (l / radix) - 1 in 
  let pred (i: nat {i <= len}) (p : point #c #Jacobian) : Type0 = (
    let scalar = scalar_as_nat s in 
    let partialScalar = arithmetic_shift_right scalar (l - (i + 1) * radix) in  
    pointEqual p (point_mult #c partialScalar p0)) in 

  lemma_predicate0 #c #t s p0; 
  let f = radix_step #c #t s p0 in 
  let r = repeati_inductive' #(point #c #Jacobian) len pred f pointToStart in 

  assert(
    let scalar = scalar_as_nat s in 
    pointEqual r (point_mult #c scalar p0));
  r