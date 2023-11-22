/* MIT License
 *
 * Copyright (c) 2016-2022 INRIA, CMU and Microsoft Corporation
 * Copyright (c) 2022-2023 HACL* Contributors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


#ifndef __internal_Test_H
#define __internal_Test_H

#include "krml/internal/compat.h"

#include "../Test.h"
#include "internal/Hacl_Hash_SHA2.h"
#include "krmllib.h"
#include "libintvector.h"
#include "clients/krmlrenamings.h"

#define Spec_Hash_Definitions_SHA2_224 0
#define Spec_Hash_Definitions_SHA2_256 1
#define Spec_Hash_Definitions_SHA2_384 2
#define Spec_Hash_Definitions_SHA2_512 3
#define Spec_Hash_Definitions_SHA1 4
#define Spec_Hash_Definitions_MD5 5
#define Spec_Hash_Definitions_Blake2S 6
#define Spec_Hash_Definitions_Blake2B 7
#define Spec_Hash_Definitions_SHA3_256 8
#define Spec_Hash_Definitions_SHA3_224 9
#define Spec_Hash_Definitions_SHA3_384 10
#define Spec_Hash_Definitions_SHA3_512 11
#define Spec_Hash_Definitions_Shake128 12
#define Spec_Hash_Definitions_Shake256 13

typedef uint8_t Spec_Hash_Definitions_hash_alg;

typedef struct Test_Lowstarize_lbuffer__uint8_t_s
{
  uint32_t len;
  uint8_t *b;
}
Test_Lowstarize_lbuffer__uint8_t;

typedef struct K___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_s
{
  Test_Lowstarize_lbuffer__uint8_t fst;
  Test_Lowstarize_lbuffer__uint8_t snd;
}
K___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t;

typedef struct
K___Spec_Hash_Definitions_hash_alg_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_s
{
  Spec_Hash_Definitions_hash_alg fst;
  Test_Lowstarize_lbuffer__uint8_t snd;
  Test_Lowstarize_lbuffer__uint8_t thd;
  Test_Lowstarize_lbuffer__uint8_t f3;
  Test_Lowstarize_lbuffer__uint8_t f4;
  Test_Lowstarize_lbuffer__uint8_t f5;
  K___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t f6;
  Test_Lowstarize_lbuffer__uint8_t f7;
}
K___Spec_Hash_Definitions_hash_alg_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t;

typedef struct
Test_Lowstarize_lbuffer__K___Spec_Hash_Definitions_hash_alg_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_s
{
  uint32_t len;
  K___Spec_Hash_Definitions_hash_alg_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t
  *b;
}
Test_Lowstarize_lbuffer__K___Spec_Hash_Definitions_hash_alg_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t;

#define Test_Vectors_AES_128_GCM 0
#define Test_Vectors_AES_256_GCM 1
#define Test_Vectors_CHACHA20_POLY1305 2

typedef uint8_t Test_Vectors_cipher;

typedef struct
K___Test_Vectors_cipher_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_s
{
  Test_Vectors_cipher fst;
  Test_Lowstarize_lbuffer__uint8_t snd;
  Test_Lowstarize_lbuffer__uint8_t thd;
  Test_Lowstarize_lbuffer__uint8_t f3;
  Test_Lowstarize_lbuffer__uint8_t f4;
  Test_Lowstarize_lbuffer__uint8_t f5;
  Test_Lowstarize_lbuffer__uint8_t f6;
}
K___Test_Vectors_cipher_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t;

typedef struct
Test_Lowstarize_lbuffer__K___Test_Vectors_cipher_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_s
{
  uint32_t len;
  K___Test_Vectors_cipher_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t
  *b;
}
Test_Lowstarize_lbuffer__K___Test_Vectors_cipher_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t;

void
test_aead_loop(
  Test_Vectors_cipher alg0,
  Test_Lowstarize_lbuffer__K___Test_Vectors_cipher_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t
  uu___
);

void test_aes128_gcm_loop(uint32_t i);

void
test_many_st_loop__Spec_Hash_Definitions_hash_alg___Test_Lowstarize_lbuffer_uint8_t___Test_Lowstarize_lbuffer_uint8_t___Test_Lowstarize_lbuffer_uint8_t___Test_Lowstarize_lbuffer_uint8_t___Test_Lowstarize_lbuffer_uint8_t___Test_Lowstarize_lbuffer_uint8_t___Test_Lowstarize_lbuffer_uint8_t___Test_Lowstarize_lbuffer_uint8_t(
  uint32_t i,
  void
  (*f)(
    K___Spec_Hash_Definitions_hash_alg_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t
    x0
  ),
  Test_Lowstarize_lbuffer__K___Spec_Hash_Definitions_hash_alg_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t___Test_Lowstarize_lbuffer__uint8_t_Test_Lowstarize_lbuffer__uint8_t
  vec
);


#define __internal_Test_H_DEFINED
#endif
