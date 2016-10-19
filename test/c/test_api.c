#include "testlib.h"
#include "Hacl_Box.h"
#include <sodium.h>
#include <time.h>

#define MESSAGE_LEN 44
#define secretbox_MACBYTES   16
#define CIPHERTEXT_LEN (secretbox_MACBYTES + MESSAGE_LEN)
#define secretbox_NONCEBYTES 24
#define secretbox_KEYBYTES   32
#define box_MACBYTES         16
#define box_PUBLICKEYBYTES   32
#define box_SECRETKEYBYTES   32
#define box_NONCEBYTES       24

uint8_t *msg = (uint8_t*) "testtesttesttesttesttesttesttesttesttesttest";

uint8_t nonce[secretbox_NONCEBYTES] = {
  0x00, 0x01, 0x02, 0x03,
  0x04, 0x05, 0x06, 0x07,
  0x08, 0x09, 0x10, 0x11,
  0x12, 0x13, 0x14, 0x15,
  0x16, 0x17, 0x18, 0x19,
  0x20, 0x21, 0x22, 0x23,
};

uint8_t key[secretbox_KEYBYTES] = {
  0x85, 0xd6, 0xbe, 0x78,
  0x57, 0x55, 0x6d, 0x33,
  0x7f, 0x44, 0x52, 0xfe,
  0x42, 0xd5, 0x06, 0xa8,
  0x01, 0x03, 0x80, 0x8a,
  0xfb, 0x0d, 0xb2, 0xfd,
  0x4a, 0xbf, 0xf6, 0xaf,
  0x41, 0x49, 0xf5, 0x1b
};

uint8_t sk[secretbox_KEYBYTES] = {
  0x85, 0xd6, 0xbe, 0x78,
  0x57, 0x55, 0x6d, 0x33,
  0x7f, 0x44, 0x52, 0xfe,
  0x42, 0xd5, 0x06, 0xa8,
  0x01, 0x03, 0x80, 0x8a,
  0xfb, 0x0d, 0xb2, 0xfd,
  0x4a, 0xbf, 0xf6, 0xaf,
  0x41, 0x49, 0xf5, 0x1c
};

void test_correctness() {
  if (sodium_init() == -1) {
    exit(EXIT_FAILURE);
  }
  uint8_t ciphertext[CIPHERTEXT_LEN], ciphertext2[CIPHERTEXT_LEN],
    mac[16],mac2[16],
    decrypted[MESSAGE_LEN], decrypted2[MESSAGE_LEN],
    pk[box_PUBLICKEYBYTES], pk2[box_PUBLICKEYBYTES],
    test[32], test2[32],
    basepoint[box_SECRETKEYBYTES] = {9};
  uint32_t res;
  int i;
  /* Testing the secret box primitives */  
  Hacl_SecretBox_crypto_secretbox_detached(ciphertext, mac, msg, MESSAGE_LEN, nonce, key);
  res = crypto_secretbox_open_detached(decrypted, ciphertext, mac, MESSAGE_LEN, nonce, key);

  printf("SecretBox decryption with libsodium was a %s.\n", res == 0 ? "success" : "failure");
  TestLib_compare_and_print("Secret box", msg, decrypted, MESSAGE_LEN);

  for(i = 0; i < MESSAGE_LEN; i++) decrypted[i] = 0;
  for(i = 0; i < CIPHERTEXT_LEN; i++) ciphertext[i] = 0;

  // Creating public/private key couples
  Hacl_EC_Curve25519_exp(pk , basepoint, key);
  Hacl_EC_Curve25519_exp(pk2, basepoint, sk);
  /* Testing the box primitives */
  i = crypto_box_detached(ciphertext, mac, msg, MESSAGE_LEN, nonce, pk, sk);  
  res = Hacl_Box_crypto_box_open_detached(decrypted, ciphertext, mac, MESSAGE_LEN, nonce, pk2, key);
  printf("Box decryption with libsodium was a %s.\n", res == 0 ? "success" : "failure");
  
  TestLib_compare_and_print("Box", msg, decrypted, MESSAGE_LEN);
}

#define SIZE (512*1024*1024)

void test_perf1() {
  void *plain = malloc(SIZE), *cipher = malloc(SIZE);
  uint8_t mac[16];
  clock_t c1, c2;
  double t1, t2;

  c1 = clock();
  Hacl_SecretBox_crypto_secretbox_detached(cipher, mac, plain, SIZE, nonce, key);
  c2 = clock();
  t1 = ((double)c2 - c1)/CLOCKS_PER_SEC;
  printf("User time for HACL: %f\n", t1);

  c1 = clock();
  crypto_secretbox_detached(cipher, mac, plain, SIZE, nonce, key);
  c2 = clock();
  t2 = ((double)c2 - c1)/CLOCKS_PER_SEC;
  printf("User time for Sodium: %f\n", t2);

  printf("Slowdown (AEAD): %f\n", t1/t2);
}

void test_perf2() {
  void *plain = malloc(SIZE);
  uint8_t mac[16];
  clock_t c1, c2;
  double t1, t2;

  c1 = clock();
  Hacl_Symmetric_Poly1305_poly1305_mac(mac, plain, SIZE, key);
  c2 = clock();
  t1 = ((double)c2 - c1)/CLOCKS_PER_SEC;
  printf("User time for HACL: %f\n", t1);

  c1 = clock();
  crypto_onetimeauth(mac, plain, SIZE, key);
  c2 = clock();
  t2 = ((double)c2 - c1)/CLOCKS_PER_SEC;
  printf("User time for Sodium: %f\n", t2);

  printf("Slowdown (Poly1305): %f\n", t1/t2);
}

void test_perf3() {
  void *plain = malloc(SIZE), *cipher = malloc(SIZE);
  uint8_t mac[16];
  clock_t c1, c2;
  double t1, t2;

  c1 = clock();
  Hacl_Symmetric_HSalsa20_crypto_stream_xsalsa20_xor(cipher, plain, SIZE, nonce, key);
  c2 = clock();
  t1 = ((double)c2 - c1)/CLOCKS_PER_SEC;
  printf("User time for HACL: %f\n", t1);

  c1 = clock();
  crypto_stream_xsalsa20_xor(cipher, plain, SIZE, nonce, key);
  c2 = clock();
  t2 = ((double)c2 - c1)/CLOCKS_PER_SEC;
  printf("User time for Sodium: %f\n", t2);

  printf("Slowdown (XSalsa20): %f\n", t1/t2);
}

int main(int argc, char *argv[]){
  if (argc == 2 && strcmp(argv[1], "perf1") == 0) {
    test_perf1();
  } else if (argc == 2 && strcmp(argv[1], "perf2") == 0) {
    test_perf2();
  } else if (argc == 2 && strcmp(argv[1], "perf3") == 0) {
    test_perf3();
  } else {
    test_correctness();
  }

  return EXIT_SUCCESS;
}
