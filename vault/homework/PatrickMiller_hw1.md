Patrick Miller

1.a.
$$
(4000 - 200) / 4000 = 38/40 = 95%
$$
1.b.
$$
EAT = 0.95*30ns + 0.05*(200ns + 30ns) = 40ns
$$
2.a.
- address = 20 bytes long
- block = 4 bytes long (16 blocks = 2^4)
- offset = 5 bytes long (32byte size = 2^5)
- tag = 20 - 4 - 5 = 11
[tag:11|block:4|offset:5]
2.b
- 4-way means 4 columns
- 16 blocks / 4 columns = 4 rows
- address = 20 bytes long
- set = 2 bytes long (4 rows = 2^2)
- tag = 20 - 2 - 5 = 13
[tag:13|set:2|offset:5]

3) [2|4|2]
address|hit/miss
---|---
0x04|miss
0x07|
0x08|
0x44|
0x05|
0x30|
0x88|
0x09|
0x06|
