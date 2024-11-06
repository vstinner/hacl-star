#![allow(non_upper_case_globals)]
#![allow(dead_code)]
#![allow(const_item_mutation)]

#[test]
pub fn test_sha2() {
    let mut state = crate::hash_sha2::malloc_256();
    let state_ref = &mut state;
    // Meh. Copy.
    let input = b"BsPzn7jdiXtsl/u/InjqfivA0iPjoMFTD6QcLkZUh0dYchilWrlinINHfSZL+5or5NtNGL1aJDHfckYuWKEsMrm+8ebESvApqA+dJHSna5RYtSMbB8r8gii/nmC9hxmw85RHCtDeQTE9NQdsl+kKg21741E2bjU4MX6Glos6SEIoRfHKWEXbHz9qcdl6aD46LnhtBuhvyNIa4XRL0yTiM0o1PLQUX6sB8WMXUFCtqSy6WYRiIvtR8qFfr+5mBpGSCX7t8ihmvLn5eeme3K+1NAQAkhc/IISkqH57AmEi/vapQ/Jyi0KnPSwlb8Gs/iPK9yn/qSJsdnhHKH+8BPraP7Nw4OAlDyfbhNjG0HbTnnfwDF4m+fLhfnACSTPEN5QHpWr+/ECF9ivhalEAR0GeeZLYJ3o8UYhh8IxzpeHjD6Mi4LB39g3AUz1DDAfdfUBUmNK8rUOzEUE31gXcUY5/elg3LUfyKg8FRU0IAo3fDhcegFQpzDmLYoDEORlVLIaXe349ERRsrPpMKZ49DMK4mt4i+bbNC93gfkbCiufOo+sc1EANY4kISzVD6vvk89zGKxVLpl7dwJQZydsr8jGb8I78cLbRDHQSFlpwdUEm7bqrB7y2al8kExE/N/dh+FX+upf7nF+9TCYfW3lqAbrjMU6xstOLZB5UlMk2ZVf3tAPOkG/I1X+eUDeBrdAtpcbErXGGSkQo3WMxBB8afRbfqUDzH8AVmtdxIrzpMgaBqwGidaVqLIircfKsRUl+2XZX+EAzx4FJS4tMFQ5Jsx+fUenN/o8jD/3iH0JVH+M8XcmMeJYacPDvt283Pe6BpKp1Fshq+AsUoAjWdlj1x9m6LUYlsFnxQnlGNpH4iGmbdi44nreYdO+4xVNFV14nD583Yt+lrzBRmFQ3/TGPqlESdraPwiT1aU8f4isLv13E3xY8g96GDBuI71hhbVAHIgamKtkb9X9eQnUZ8zFSW05jdcTykG4iMEE2QA/NHlQy1H1jzsm8wquhGSzHOwWfBAMWwM0rkNz0l7jelGJpZcvlukmENIGya7yfCtMww6fYZFQ9InTlAQ2G3V2NxqIf7bVBm7wJG8YFz5JggFN3Bh6H37AvOgb59KeRGtsKmLCffA00zzJROE357kiKnyVMB9fem3cvKT2QFmGYC3F8lQ+x8GfaEA3uxaGUyvenf2ujvZsl/D15MEllX1BE7xUYo9+IbPXkr37VYj9GlMSavjiLW8KXzJdNXBPpSTNEllrLxFCw715c9lG5d+fIlApcxQ/Fp+JKf3eNNnDDKIKh7d90QH2T6/cY0CiOY15dwYaDVQX7f+A4trFPXFLKYm+0jr9xP3NrjKEslxC/NTQACQCQ+g==\n";
    let mut input_ = *input;
    crate::hash_sha2::update_256(state_ref, &mut input_, input.len() as u32);
    let mut output = [0u8; 32];
    crate::hash_sha2::digest_256(state_ref, &mut output);
    let expected = [ 0xad, 0xfd, 0xbc, 0x34, 0x8b, 0x94, 0x26, 0x7e, 0x97, 0x16, 0x02, 0xe3, 0x46, 0x4d, 0xd9, 0xdb, 0xaf, 0x94, 0x51, 0x52, 0xbf, 0xdb, 0x2d, 0xfb, 0xcd, 0x66, 0xb7, 0x3c, 0x51, 0x20, 0x03, 0xbb ];
    assert_eq!(output, expected);
}

const input1: [u8; 3] = [ 0x61, 0x62, 0x63 ];

const input2: [u8; 0] = [];

const input3: [u8; 56] = [
  0x61, 0x62, 0x63, 0x64, 0x62, 0x63, 0x64,
  0x65, 0x63, 0x64, 0x65, 0x66, 0x64, 0x65,
  0x66, 0x67, 0x65, 0x66, 0x67, 0x68, 0x66,
  0x67, 0x68, 0x69, 0x67, 0x68, 0x69, 0x6a,
  0x68, 0x69, 0x6a, 0x6b, 0x69, 0x6a, 0x6b,
  0x6c, 0x6a, 0x6b, 0x6c, 0x6d, 0x6b, 0x6c,
  0x6d, 0x6e, 0x6c, 0x6d, 0x6e, 0x6f, 0x6d,
  0x6e, 0x6f, 0x70, 0x6e, 0x6f, 0x70, 0x71
];

const input4: [u8; 112] = [
  0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x62, 0x63, 0x64,
  0x65, 0x66, 0x67, 0x68, 0x69, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
  0x69, 0x6a, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x65,
  0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x66, 0x67, 0x68, 0x69,
  0x6a, 0x6b, 0x6c, 0x6d, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d,
  0x6e, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f, 0x69, 0x6a,
  0x6b, 0x6c, 0x6d, 0x6e, 0x6f, 0x70, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e,
  0x6f, 0x70, 0x71, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f, 0x70, 0x71, 0x72,
  0x6c, 0x6d, 0x6e, 0x6f, 0x70, 0x71, 0x72, 0x73, 0x6d, 0x6e, 0x6f,
  0x70, 0x71, 0x72, 0x73, 0x74, 0x6e, 0x6f, 0x70, 0x71, 0x72, 0x73,
  0x74, 0x75
];

const tag1_224: [u8; 28] = [
  0x23, 0x09, 0x7d, 0x22, 0x34, 0x05, 0xd8,
  0x22, 0x86, 0x42, 0xa4, 0x77, 0xbd, 0xa2,
  0x55, 0xb3, 0x2a, 0xad, 0xbc, 0xe4, 0xbd,
  0xa0, 0xb3, 0xf7, 0xe3, 0x6c, 0x9d, 0xa7
];

const tag1_256: [u8; 32] = [
  0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea,
  0x41, 0x41, 0x40, 0xde, 0x5d, 0xae, 0x22, 0x23,
  0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c,
  0xb4, 0x10, 0xff, 0x61, 0xf2, 0x00, 0x15, 0xad
];

const tag1_384: [u8; 48] = [
  0xcb, 0x00, 0x75, 0x3f, 0x45, 0xa3, 0x5e, 0x8b,
  0xb5, 0xa0, 0x3d, 0x69, 0x9a, 0xc6, 0x50, 0x07,
  0x27, 0x2c, 0x32, 0xab, 0x0e, 0xde, 0xd1, 0x63,
  0x1a, 0x8b, 0x60, 0x5a, 0x43, 0xff, 0x5b, 0xed,
  0x80, 0x86, 0x07, 0x2b, 0xa1, 0xe7, 0xcc, 0x23,
  0x58, 0xba, 0xec, 0xa1, 0x34, 0xc8, 0x25, 0xa7
];

const tag1_512: [u8; 64] = [
  0xdd, 0xaf, 0x35, 0xa1, 0x93, 0x61, 0x7a, 0xba,
  0xcc, 0x41, 0x73, 0x49, 0xae, 0x20, 0x41, 0x31,
  0x12, 0xe6, 0xfa, 0x4e, 0x89, 0xa9, 0x7e, 0xa2,
  0x0a, 0x9e, 0xee, 0xe6, 0x4b, 0x55, 0xd3, 0x9a,
  0x21, 0x92, 0x99, 0x2a, 0x27, 0x4f, 0xc1, 0xa8,
  0x36, 0xba, 0x3c, 0x23, 0xa3, 0xfe, 0xeb, 0xbd,
  0x45, 0x4d, 0x44, 0x23, 0x64, 0x3c, 0xe8, 0x0e,
  0x2a, 0x9a, 0xc9, 0x4f, 0xa5, 0x4c, 0xa4, 0x9f
];

const tag2_224: [u8; 28] = [
  0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b,
  0xc9, 0x47, 0x61, 0x02, 0xbb, 0x28, 0x82,
  0x34, 0xc4, 0x15, 0xa2, 0xb0, 0x1f, 0x82,
  0x8e, 0xa6, 0x2a, 0xc5, 0xb3, 0xe4, 0x2f
];

const tag2_256: [u8; 32] = [
  0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
  0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
  0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
  0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55
];

const tag2_384: [u8; 48] = [
  0x38, 0xb0, 0x60, 0xa7, 0x51, 0xac, 0x96, 0x38,
  0x4c, 0xd9, 0x32, 0x7e, 0xb1, 0xb1, 0xe3, 0x6a,
  0x21, 0xfd, 0xb7, 0x11, 0x14, 0xbe, 0x07, 0x43,
  0x4c, 0x0c, 0xc7, 0xbf, 0x63, 0xf6, 0xe1, 0xda,
  0x27, 0x4e, 0xde, 0xbf, 0xe7, 0x6f, 0x65, 0xfb,
  0xd5, 0x1a, 0xd2, 0xf1, 0x48, 0x98, 0xb9, 0x5b
];

const tag2_512: [u8; 64] = [
  0xcf, 0x83, 0xe1, 0x35, 0x7e, 0xef, 0xb8, 0xbd,
  0xf1, 0x54, 0x28, 0x50, 0xd6, 0x6d, 0x80, 0x07,
  0xd6, 0x20, 0xe4, 0x05, 0x0b, 0x57, 0x15, 0xdc,
  0x83, 0xf4, 0xa9, 0x21, 0xd3, 0x6c, 0xe9, 0xce,
  0x47, 0xd0, 0xd1, 0x3c, 0x5d, 0x85, 0xf2, 0xb0,
  0xff, 0x83, 0x18, 0xd2, 0x87, 0x7e, 0xec, 0x2f,
  0x63, 0xb9, 0x31, 0xbd, 0x47, 0x41, 0x7a, 0x81,
  0xa5, 0x38, 0x32, 0x7a, 0xf9, 0x27, 0xda, 0x3e
];

const tag3_224: [u8; 28] = [
  0x75, 0x38, 0x8b, 0x16, 0x51, 0x27, 0x76,
  0xcc, 0x5d, 0xba, 0x5d, 0xa1, 0xfd, 0x89,
  0x01, 0x50, 0xb0, 0xc6, 0x45, 0x5c, 0xb4,
  0xf5, 0x8b, 0x19, 0x52, 0x52, 0x25, 0x25
];

const tag3_256: [u8; 32] = [
  0x24, 0x8d, 0x6a, 0x61, 0xd2, 0x06, 0x38, 0xb8,
  0xe5, 0xc0, 0x26, 0x93, 0x0c, 0x3e, 0x60, 0x39,
  0xa3, 0x3c, 0xe4, 0x59, 0x64, 0xff, 0x21, 0x67,
  0xf6, 0xec, 0xed, 0xd4, 0x19, 0xdb, 0x06, 0xc1
];

const tag3_384: [u8; 48] = [
  0x33, 0x91, 0xfd, 0xdd, 0xfc, 0x8d, 0xc7, 0x39,
  0x37, 0x07, 0xa6, 0x5b, 0x1b, 0x47, 0x09, 0x39,
  0x7c, 0xf8, 0xb1, 0xd1, 0x62, 0xaf, 0x05, 0xab,
  0xfe, 0x8f, 0x45, 0x0d, 0xe5, 0xf3, 0x6b, 0xc6,
  0xb0, 0x45, 0x5a, 0x85, 0x20, 0xbc, 0x4e, 0x6f,
  0x5f, 0xe9, 0x5b, 0x1f, 0xe3, 0xc8, 0x45, 0x2b
];

const tag3_512: [u8; 64] = [
  0x20, 0x4a, 0x8f, 0xc6, 0xdd, 0xa8, 0x2f, 0x0a,
  0x0c, 0xed, 0x7b, 0xeb, 0x8e, 0x08, 0xa4, 0x16,
  0x57, 0xc1, 0x6e, 0xf4, 0x68, 0xb2, 0x28, 0xa8,
  0x27, 0x9b, 0xe3, 0x31, 0xa7, 0x03, 0xc3, 0x35,
  0x96, 0xfd, 0x15, 0xc1, 0x3b, 0x1b, 0x07, 0xf9,
  0xaa, 0x1d, 0x3b, 0xea, 0x57, 0x78, 0x9c, 0xa0,
  0x31, 0xad, 0x85, 0xc7, 0xa7, 0x1d, 0xd7, 0x03,
  0x54, 0xec, 0x63, 0x12, 0x38, 0xca, 0x34, 0x45
];

const tag4_224: [u8; 28] = [
  0xc9, 0x7c, 0xa9, 0xa5, 0x59, 0x85, 0x0c,
  0xe9, 0x7a, 0x04, 0xa9, 0x6d, 0xef, 0x6d,
  0x99, 0xa9, 0xe0, 0xe0, 0xe2, 0xab, 0x14,
  0xe6, 0xb8, 0xdf, 0x26, 0x5f, 0xc0, 0xb3
];

const tag4_256: [u8; 32] = [
  0xcf, 0x5b, 0x16, 0xa7, 0x78, 0xaf, 0x83, 0x80,
  0x03, 0x6c, 0xe5, 0x9e, 0x7b, 0x04, 0x92, 0x37,
  0x0b, 0x24, 0x9b, 0x11, 0xe8, 0xf0, 0x7a, 0x51,
  0xaf, 0xac, 0x45, 0x03, 0x7a, 0xfe, 0xe9, 0xd1
];

const tag4_384: [u8; 48] = [
  0x09, 0x33, 0x0c, 0x33, 0xf7, 0x11, 0x47, 0xe8,
  0x3d, 0x19, 0x2f, 0xc7, 0x82, 0xcd, 0x1b, 0x47,
  0x53, 0x11, 0x1b, 0x17, 0x3b, 0x3b, 0x05, 0xd2,
  0x2f, 0xa0, 0x80, 0x86, 0xe3, 0xb0, 0xf7, 0x12,
  0xfc, 0xc7, 0xc7, 0x1a, 0x55, 0x7e, 0x2d, 0xb9,
  0x66, 0xc3, 0xe9, 0xfa, 0x91, 0x74, 0x60, 0x39
];

const tag4_512: [u8; 64] = [
  0x8e, 0x95, 0x9b, 0x75, 0xda, 0xe3, 0x13, 0xda,
  0x8c, 0xf4, 0xf7, 0x28, 0x14, 0xfc, 0x14, 0x3f,
  0x8f, 0x77, 0x79, 0xc6, 0xeb, 0x9f, 0x7f, 0xa1,
  0x72, 0x99, 0xae, 0xad, 0xb6, 0x88, 0x90, 0x18,
  0x50, 0x1d, 0x28, 0x9e, 0x49, 0x00, 0xf7, 0xe4,
  0x33, 0x1b, 0x99, 0xde, 0xc4, 0xb5, 0x43, 0x3a,
  0xc7, 0xd3, 0x29, 0xee, 0xb6, 0xdd, 0x26, 0x54,
  0x5e, 0x96, 0xe5, 0x5b, 0x87, 0x4b, 0xe9, 0x09
];

#[test]
pub fn test_shas() {

  // SHA-224
  let mut tag_224 = [0u8; 28];
  let mut state_224 = crate::hash_sha2::malloc_224();
  crate::hash_sha2::update_224(&mut state_224, &mut input1, input1.len() as u32);
  crate::hash_sha2::digest_224(&mut state_224, &mut tag_224);
  assert_eq!(tag_224, tag1_224);

  let mut tag_224 = [0u8; 28];
  let mut state_224 = crate::hash_sha2::malloc_224();
  crate::hash_sha2::update_224(&mut state_224, &mut input2, input2.len() as u32);
  crate::hash_sha2::digest_224(&mut state_224, &mut tag_224);
  assert_eq!(tag_224, tag2_224);

  let mut tag_224 = [0u8; 28];
  let mut state_224 = crate::hash_sha2::malloc_224();
  crate::hash_sha2::update_224(&mut state_224, &mut input3, input3.len() as u32);
  crate::hash_sha2::digest_224(&mut state_224, &mut tag_224);
  assert_eq!(tag_224, tag3_224);

  let mut tag_224 = [0u8; 28];
  let mut state_224 = crate::hash_sha2::malloc_224();
  crate::hash_sha2::update_224(&mut state_224, &mut input4, input4.len() as u32);
  crate::hash_sha2::digest_224(&mut state_224, &mut tag_224);
  assert_eq!(tag_224, tag4_224);

  // SHA-256
  let mut tag_256 = [0u8; 32];
  let mut state_256 = crate::hash_sha2::malloc_256();
  crate::hash_sha2::update_256(&mut state_256, &mut input1, input1.len() as u32);
  crate::hash_sha2::digest_256(&mut state_256, &mut tag_256);
  assert_eq!(tag_256, tag1_256);

  let mut tag_256 = [0u8; 32];
  let mut state_256 = crate::hash_sha2::malloc_256();
  crate::hash_sha2::update_256(&mut state_256, &mut input2, input2.len() as u32);
  crate::hash_sha2::digest_256(&mut state_256, &mut tag_256);
  assert_eq!(tag_256, tag2_256);

  let mut tag_256 = [0u8; 32];
  let mut state_256 = crate::hash_sha2::malloc_256();
  crate::hash_sha2::update_256(&mut state_256, &mut input3, input3.len() as u32);
  crate::hash_sha2::digest_256(&mut state_256, &mut tag_256);
  assert_eq!(tag_256, tag3_256);

  let mut tag_256 = [0u8; 32];
  let mut state_256 = crate::hash_sha2::malloc_256();
  crate::hash_sha2::update_256(&mut state_256, &mut input4, input4.len() as u32);
  crate::hash_sha2::digest_256(&mut state_256, &mut tag_256);
  assert_eq!(tag_256, tag4_256);

  // SHA-384
  let mut tag_384 = [0u8; 48];
  let mut state_384 = crate::hash_sha2::malloc_384();
  crate::hash_sha2::update_384(&mut state_384, &mut input1, input1.len() as u32);
  crate::hash_sha2::digest_384(&mut state_384, &mut tag_384);
  assert_eq!(tag_384, tag1_384);

  let mut tag_384 = [0u8; 48];
  let mut state_384 = crate::hash_sha2::malloc_384();
  crate::hash_sha2::update_384(&mut state_384, &mut input2, input2.len() as u32);
  crate::hash_sha2::digest_384(&mut state_384, &mut tag_384);
  assert_eq!(tag_384, tag2_384);

  let mut tag_384 = [0u8; 48];
  let mut state_384 = crate::hash_sha2::malloc_384();
  crate::hash_sha2::update_384(&mut state_384, &mut input3, input3.len() as u32);
  crate::hash_sha2::digest_384(&mut state_384, &mut tag_384);
  assert_eq!(tag_384, tag3_384);

  let mut tag_384 = [0u8; 48];
  let mut state_384 = crate::hash_sha2::malloc_384();
  crate::hash_sha2::update_384(&mut state_384, &mut input4, input4.len() as u32);
  crate::hash_sha2::digest_384(&mut state_384, &mut tag_384);
  assert_eq!(tag_384, tag4_384);

  // SHA-512
  let mut tag_512 = [0u8; 64];
  let mut state_512 = crate::hash_sha2::malloc_512();
  crate::hash_sha2::update_512(&mut state_512, &mut input1, input1.len() as u32);
  crate::hash_sha2::digest_512(&mut state_512, &mut tag_512);
  assert_eq!(tag_512, tag1_512);

  let mut tag_512 = [0u8; 64];
  let mut state_512 = crate::hash_sha2::malloc_512();
  crate::hash_sha2::update_512(&mut state_512, &mut input2, input2.len() as u32);
  crate::hash_sha2::digest_512(&mut state_512, &mut tag_512);
  assert_eq!(tag_512, tag2_512);

  let mut tag_512 = [0u8; 64];
  let mut state_512 = crate::hash_sha2::malloc_512();
  crate::hash_sha2::update_512(&mut state_512, &mut input3, input3.len() as u32);
  crate::hash_sha2::digest_512(&mut state_512, &mut tag_512);
  assert_eq!(tag_512, tag3_512);

  let mut tag_512 = [0u8; 64];
  let mut state_512 = crate::hash_sha2::malloc_512();
  crate::hash_sha2::update_512(&mut state_512, &mut input4, input4.len() as u32);
  crate::hash_sha2::digest_512(&mut state_512, &mut tag_512);
  assert_eq!(tag_512, tag4_512);

}