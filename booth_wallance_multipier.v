///////////////////////////////////////////////////////////
// 16 x 16 bits Signed Interger Number¡¯ Wallance Multiplier Based on Booth Algorithm 
// Made by Xu Changlai in 2020/03/23
//////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module booth_wallance_multipier(a_in,b_in,result);

input [15:0] a_in,b_in;
output wire [30:0] result;

wire [15:0] a_com,b_com;
wire [16:0] booth0,booth1,booth2,booth3,booth4,booth5,booth6,booth7;
wire [44:0] Sum_1stLevel,Carry_1stLevel;
wire [33:0] Sum_2stLevel,Carry_2stLevel;
wire [26:0] Sum_3stLevel,Carry_3stLevel;
wire [25:0] Sum_4stLevel,Carry_4stLevel;
wire [23:0] P,G,Carry_5stLevel;
wire [30:0] result_p,tempt_result;

//inputs's complement
assign a_com = a_in[15]? ({1'b1,~a_in[14:0]}+1'b1): a_in; 
assign b_com = b_in[15]? ({1'b1,~b_in[14:0]}+1'b1): b_in; 
// booth encode
booth3bits u1(a_com,{b_com[1:0],1'b0},booth0);
booth3bits u2(a_com,b_com[3:1],booth1);
booth3bits u3(a_com,b_com[5:3],booth2);
booth3bits u4(a_com,b_com[7:5],booth3);
booth3bits u5(a_com,b_com[9:7],booth4);
booth3bits u6(a_com,b_com[11:9],booth5);
booth3bits u7(a_com,b_com[13:11],booth6);
booth3bits u8(a_com,b_com[15:13],booth7);

// column0 
assign result_p[0] = booth0[0];
// column1
assign result_p[1] = booth0[1];
// column2
HalfAdder column2_level1    (booth0[2], booth1[0],           Sum_1stLevel[0], Carry_1stLevel[0]);
assign result_p[2] = Sum_1stLevel[0];
// column3
HalfAdder column3_level1    (booth0[3], booth1[1],           Sum_1stLevel[1], Carry_1stLevel[1]);
HalfAdder column3_level2    (Sum_1stLevel[1], Carry_1stLevel[0],Sum_2stLevel[0], Carry_2stLevel[0]);
assign result_p[3] = Sum_2stLevel[0];
// column4
FullAdder column4_level1    (booth0[4], booth1[2],booth2[0], Sum_1stLevel[2], Carry_1stLevel[2]);
HalfAdder column4_level2    (Sum_1stLevel[2], Carry_1stLevel[1],Sum_2stLevel[1], Carry_2stLevel[1]);
HalfAdder column4_level3    (Sum_2stLevel[1], Carry_2stLevel[0],Sum_3stLevel[0], Carry_3stLevel[0]);
assign result_p[4] = Sum_3stLevel[0];
// column5
FullAdder column5_level1    (booth0[5], booth1[3],booth2[1], Sum_1stLevel[3], Carry_1stLevel[3]);
HalfAdder column5_level2    (Sum_1stLevel[3], Carry_1stLevel[2],Sum_2stLevel[2], Carry_2stLevel[2]);
HalfAdder column5_level3    (Sum_2stLevel[2], Carry_2stLevel[1],Sum_3stLevel[1], Carry_3stLevel[1]);
HalfAdder column5_level4    (Sum_3stLevel[1], Carry_3stLevel[0],Sum_4stLevel[0], Carry_4stLevel[0]);
assign result_p[5] = Sum_4stLevel[0];
// column6
FullAdder column6_level1    (booth0[6], booth1[4],booth2[2], Sum_1stLevel[4], Carry_1stLevel[4]);
FullAdder column6_level2    (booth3[0], Sum_1stLevel[4], Carry_1stLevel[3], Sum_2stLevel[3], Carry_2stLevel[3]);
HalfAdder column6_level3    (Sum_2stLevel[3], Carry_2stLevel[2],Sum_3stLevel[2], Carry_3stLevel[2]);
HalfAdder column6_level4    (Sum_3stLevel[2], Carry_3stLevel[1],Sum_4stLevel[1], Carry_4stLevel[1]);
assign G[0] = Sum_4stLevel[1] & Carry_4stLevel[0];
assign P[0] = Sum_4stLevel[1] | Carry_4stLevel[0];
assign Carry_5stLevel[0] = G[0];
assign result_p[6] = Sum_4stLevel[1] ^ Carry_4stLevel[0];
// colunm7
FullAdder column7_level1    (booth0[7], booth1[5],booth2[3], Sum_1stLevel[5], Carry_1stLevel[5]);
FullAdder column7_level2    (booth3[1], Sum_1stLevel[5], Carry_1stLevel[4], Sum_2stLevel[4], Carry_2stLevel[4]);
HalfAdder column7_level3    (Sum_2stLevel[4], Carry_2stLevel[3],Sum_3stLevel[3], Carry_3stLevel[3]);
HalfAdder column7_level4    (Sum_3stLevel[3], Carry_3stLevel[2],Sum_4stLevel[2], Carry_4stLevel[2]);
assign G[1] = Sum_4stLevel[2] & Carry_4stLevel[1];
assign P[1] = Sum_4stLevel[2] | Carry_4stLevel[1];
assign Carry_5stLevel[1] = G[1] | (G[0] & P[1]);
assign result_p[7] = Sum_4stLevel[2] ^ Carry_4stLevel[1] ^ Carry_5stLevel[0];
// column8
HalfAdder column8_level1_0  (booth3[2], booth4[0],Sum_1stLevel[6], Carry_1stLevel[6]);
FullAdder column8_level1_1  (booth0[8], booth1[6],booth2[4], Sum_1stLevel[7], Carry_1stLevel[7]);
FullAdder column8_level2    (Sum_1stLevel[6], Sum_1stLevel[7], Carry_1stLevel[5], Sum_2stLevel[5], Carry_2stLevel[5]);
HalfAdder column8_level3    (Sum_2stLevel[5], Carry_2stLevel[4],Sum_3stLevel[4], Carry_3stLevel[4]);
HalfAdder column8_level4    (Sum_3stLevel[4], Carry_3stLevel[3],Sum_4stLevel[3], Carry_4stLevel[3]);
assign G[2] = Sum_4stLevel[3] & Carry_4stLevel[2];
assign P[2] = Sum_4stLevel[3] | Carry_4stLevel[2];
assign Carry_5stLevel[2] = G[2] | (G[1] & P[2]) | (G[0] & P[2] & P[1]);
assign result_p[8] = Sum_4stLevel[3] ^ Carry_4stLevel[2] ^ Carry_5stLevel[1];
//column9
HalfAdder column9_level1_0  (booth3[3], booth4[1],Sum_1stLevel[8], Carry_1stLevel[8]);
FullAdder column9_level1_1  (booth0[9], booth1[7],booth2[5], Sum_1stLevel[9], Carry_1stLevel[9]);
FullAdder column9_level2    (Sum_1stLevel[8], Sum_1stLevel[9], Carry_1stLevel[6], Sum_2stLevel[6], Carry_2stLevel[6]);
FullAdder column9_level3    (Carry_1stLevel[7],Sum_2stLevel[6], Carry_2stLevel[5],Sum_3stLevel[5], Carry_3stLevel[5]);
HalfAdder column9_level4    (Sum_3stLevel[5], Carry_3stLevel[4],Sum_4stLevel[4], Carry_4stLevel[4]);
assign G[3] = Sum_4stLevel[4] & Carry_4stLevel[3];
assign P[3] = Sum_4stLevel[4] | Carry_4stLevel[3];
assign Carry_5stLevel[3] = G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1]);
assign result_p[9] = Sum_4stLevel[4] ^ Carry_4stLevel[3] ^ Carry_5stLevel[2];
// column10
FullAdder column10_level1_0  (booth3[4], booth4[2],booth5[0],Sum_1stLevel[10], Carry_1stLevel[10]);
FullAdder column10_level1_1  (booth0[10], booth1[8],booth2[6], Sum_1stLevel[11], Carry_1stLevel[11]);
FullAdder column10_level2    (Sum_1stLevel[10], Sum_1stLevel[11], Carry_1stLevel[8], Sum_2stLevel[7], Carry_2stLevel[7]);
FullAdder column10_level3    (Carry_1stLevel[9],Sum_2stLevel[7], Carry_2stLevel[6],Sum_3stLevel[6], Carry_3stLevel[6]);
HalfAdder column10_level4    (Sum_3stLevel[6], Carry_3stLevel[5],Sum_4stLevel[5], Carry_4stLevel[5]);
assign G[4] = Sum_4stLevel[5] & Carry_4stLevel[4];
assign P[4] = Sum_4stLevel[5] | Carry_4stLevel[4];
assign Carry_5stLevel[4] = G[4] | (G[3] & P[4]) | (G[2] & P[4] & P[3]) | (G[1] & P[4] & P[3] & P[2]) | (G[0] & P[4] & P[3] & P[2] & P[1]);
assign result_p[10] = Sum_4stLevel[5] ^ Carry_4stLevel[4] ^ Carry_5stLevel[3];
// column11
FullAdder column11_level1_0  (booth3[5], booth4[3],booth5[1],Sum_1stLevel[12], Carry_1stLevel[12]);
FullAdder column11_level1_1  (booth0[11], booth1[9],booth2[7], Sum_1stLevel[13], Carry_1stLevel[13]);
FullAdder column11_level2    (Sum_1stLevel[12], Sum_1stLevel[13], Carry_1stLevel[10], Sum_2stLevel[8], Carry_2stLevel[8]);
FullAdder column11_level3    (Carry_1stLevel[11],Sum_2stLevel[8], Carry_2stLevel[7],Sum_3stLevel[7], Carry_3stLevel[7]);
HalfAdder column11_level4    (Sum_3stLevel[7], Carry_3stLevel[6],Sum_4stLevel[6], Carry_4stLevel[6]);
assign G[5] = Sum_4stLevel[6] & Carry_4stLevel[5];
assign P[5] = Sum_4stLevel[6] | Carry_4stLevel[5];
assign Carry_5stLevel[5] = G[5] | (G[4] & P[5]) | (G[3] & P[5] & P[4]) | (G[2] & P[5] & P[4] & P[3]) | (G[1] & P[5] & P[4] & P[3] & P[2]) | (G[0] & P[5] & P[4] & P[3] & P[2] & P[1]);
assign result_p[11] = Sum_4stLevel[6] ^ Carry_4stLevel[5] ^ Carry_5stLevel[4];
// column12
FullAdder column12_level1_0  (booth3[6], booth4[4],booth5[2],Sum_1stLevel[14], Carry_1stLevel[14]);
FullAdder column12_level1_1  (booth0[12], booth1[10],booth2[8], Sum_1stLevel[15], Carry_1stLevel[15]);
FullAdder column12_level2_0  (booth6[0], Sum_1stLevel[14], Sum_1stLevel[15], Sum_2stLevel[9], Carry_2stLevel[9]);
HalfAdder column12_level2_1  (Carry_1stLevel[12], Carry_1stLevel[13],Sum_2stLevel[10], Carry_2stLevel[10]);
FullAdder column12_level3    (Sum_2stLevel[9],Sum_2stLevel[10], Carry_2stLevel[8],Sum_3stLevel[8], Carry_3stLevel[8]);
HalfAdder column12_level4    (Sum_3stLevel[8], Carry_3stLevel[7],Sum_4stLevel[7], Carry_4stLevel[7]);
assign G[6] = Sum_4stLevel[7] & Carry_4stLevel[6];
assign P[6] = Sum_4stLevel[7] | Carry_4stLevel[6];
assign Carry_5stLevel[6] = G[6] | (G[5] & P[6]) | (G[4] & P[6] & P[5]) | (G[3] & P[6] & P[5] & P[4]) | (G[2] & P[6] & P[5] & P[4] & P[3]) | (G[1] & P[6] & P[5] & P[4] & P[3] & P[2]) | (G[0] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1]);
assign result_p[12] = Sum_4stLevel[7] ^ Carry_4stLevel[6] ^ Carry_5stLevel[5];
// column13
FullAdder column13_level1_0  (booth3[7], booth4[5],booth5[3],Sum_1stLevel[16], Carry_1stLevel[16]);
FullAdder column13_level1_1  (booth0[13], booth1[11],booth2[9], Sum_1stLevel[17], Carry_1stLevel[17]);
FullAdder column13_level2_0  (booth6[1], Sum_1stLevel[16], Sum_1stLevel[17], Sum_2stLevel[11], Carry_2stLevel[11]);
HalfAdder column13_level2_1  (Carry_1stLevel[14], Carry_1stLevel[15],Sum_2stLevel[12], Carry_2stLevel[12]);
FullAdder column13_level3    (Sum_2stLevel[11],Sum_2stLevel[12], Carry_2stLevel[9],Sum_3stLevel[9], Carry_3stLevel[9]);
FullAdder column13_level4    (Carry_2stLevel[10],Sum_3stLevel[9], Carry_3stLevel[8],Sum_4stLevel[8], Carry_4stLevel[8]);
assign G[7] = Sum_4stLevel[8] & Carry_4stLevel[7];
assign P[7] = Sum_4stLevel[8] | Carry_4stLevel[7];
assign Carry_5stLevel[7] = G[7] | (G[6] & P[7]) | (G[5] & P[7] & P[6]) | (G[4] & P[7] & P[6] & P[5]) | (G[3] & P[7] & P[6] & P[5] & P[4]) | (G[2] & P[7] & P[6] & P[5] & P[4] & P[3]) | (G[1] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2]) | (G[0] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1]);
assign result_p[13] = Sum_4stLevel[8] ^ Carry_4stLevel[7] ^ Carry_5stLevel[6];
// column14
HalfAdder column14_level1_0  (booth6[2],booth7[0],Sum_1stLevel[18], Carry_1stLevel[18]);
FullAdder column14_level1_1  (booth3[8], booth4[6],booth5[4],Sum_1stLevel[19], Carry_1stLevel[19]);
FullAdder column14_level1_2  (booth0[14], booth1[12],booth2[10], Sum_1stLevel[20], Carry_1stLevel[20]);
FullAdder column14_level2_0  (Sum_1stLevel[18], Sum_1stLevel[19], Sum_1stLevel[20], Sum_2stLevel[13], Carry_2stLevel[13]);
HalfAdder column14_level2_1  (Carry_1stLevel[16], Carry_1stLevel[17],Sum_2stLevel[14], Carry_2stLevel[14]);
FullAdder column14_level3    (Sum_2stLevel[13],Sum_2stLevel[14], Carry_2stLevel[11],Sum_3stLevel[10], Carry_3stLevel[10]);
FullAdder column14_level4    (Carry_2stLevel[12],Sum_3stLevel[10], Carry_3stLevel[9],Sum_4stLevel[9], Carry_4stLevel[9]);
assign G[8] = Sum_4stLevel[9] & Carry_4stLevel[8];
assign P[8] = Sum_4stLevel[9] | Carry_4stLevel[8];
assign Carry_5stLevel[8] = G[8] | (P[8] & Carry_5stLevel[7]) ;
assign result_p[14] = Sum_4stLevel[9] ^ Carry_4stLevel[8] ^ Carry_5stLevel[7];
// column15
HalfAdder column15_level1_0  (booth6[3],booth7[1],Sum_1stLevel[21], Carry_1stLevel[21]);
FullAdder column15_level1_1  (booth3[9], booth4[7],booth5[5],Sum_1stLevel[22], Carry_1stLevel[22]);
FullAdder column15_level1_2  (booth0[15], booth1[13],booth2[11], Sum_1stLevel[23], Carry_1stLevel[23]);
FullAdder column15_level2_0  (Sum_1stLevel[21], Sum_1stLevel[22], Sum_1stLevel[23], Sum_2stLevel[15], Carry_2stLevel[15]);
FullAdder column15_level2_1  (Carry_1stLevel[18], Carry_1stLevel[19],Carry_1stLevel[20],Sum_2stLevel[16], Carry_2stLevel[16]);
FullAdder column15_level3    (Sum_2stLevel[15],Sum_2stLevel[16], Carry_2stLevel[13],Sum_3stLevel[11], Carry_3stLevel[11]);
FullAdder column15_level4    (Carry_2stLevel[14],Sum_3stLevel[11], Carry_3stLevel[10],Sum_4stLevel[10], Carry_4stLevel[10]);
assign G[9] = Sum_4stLevel[10] & Carry_4stLevel[9];
assign P[9] = Sum_4stLevel[10] | Carry_4stLevel[9];
assign Carry_5stLevel[9] = G[9] | (G[8] & P[9]) | (P[9] & P[8] & Carry_5stLevel[7]);
assign result_p[15] = Sum_4stLevel[10] ^ Carry_4stLevel[9] ^ Carry_5stLevel[8];
// column16
HalfAdder column16_level1_0  (booth6[4],booth7[2],Sum_1stLevel[24], Carry_1stLevel[24]);
FullAdder column16_level1_1  (booth3[10], booth4[8],booth5[6],Sum_1stLevel[25], Carry_1stLevel[25]);
FullAdder column16_level1_2  (~booth0[16], booth1[14],booth2[12], Sum_1stLevel[26], Carry_1stLevel[26]);
FullAdder column16_level2_0  (Sum_1stLevel[24], Sum_1stLevel[25], Sum_1stLevel[26], Sum_2stLevel[17], Carry_2stLevel[17]);
FullAdder column16_level2_1  (Carry_1stLevel[21], Carry_1stLevel[22],Carry_1stLevel[23],Sum_2stLevel[18], Carry_2stLevel[18]);
FullAdder column16_level3    (Sum_2stLevel[17],Sum_2stLevel[18], Carry_2stLevel[15],Sum_3stLevel[12], Carry_3stLevel[12]);
FullAdder column16_level4    (Carry_2stLevel[16],Sum_3stLevel[12], Carry_3stLevel[11],Sum_4stLevel[11], Carry_4stLevel[11]);
assign G[10] = Sum_4stLevel[11] & Carry_4stLevel[10];
assign P[10] = Sum_4stLevel[11] | Carry_4stLevel[10];
assign Carry_5stLevel[10] = G[10] | (G[9] & P[10]) | (G[8] & P[10] & P[9] ) | ( P[10] & P[9] & P[8] & Carry_5stLevel[7]);
assign result_p[16] = Sum_4stLevel[11] ^ Carry_4stLevel[10] ^ Carry_5stLevel[9];
// column17
FullAdder column17_level1_0  (booth4[9],booth5[7],booth6[5],Sum_1stLevel[27], Carry_1stLevel[27]);
FullAdder column17_level1_1  (booth1[15],booth2[13],booth3[11], Sum_1stLevel[28], Carry_1stLevel[28]);
FullAdder column17_level2_0  (booth7[3], Sum_1stLevel[27], Sum_1stLevel[28], Sum_2stLevel[19], Carry_2stLevel[19]);
FullAdder column17_level2_1  (Carry_1stLevel[24], Carry_1stLevel[25],Carry_1stLevel[26],Sum_2stLevel[20], Carry_2stLevel[20]);
FullAdder column17_level3    (Sum_2stLevel[19],Sum_2stLevel[20], Carry_2stLevel[17],Sum_3stLevel[13], Carry_3stLevel[13]);
FullAdder column17_level4    (Carry_2stLevel[18],Sum_3stLevel[13], Carry_3stLevel[12],Sum_4stLevel[12], Carry_4stLevel[12]);
assign G[11] = Sum_4stLevel[12] & Carry_4stLevel[11];
assign P[11] = Sum_4stLevel[12] | Carry_4stLevel[11];
assign Carry_5stLevel[11] = G[11] | (G[10] & P[11]) | (G[9] & P[11] & P[10] ) | ( G[8] & P[11] & P[10] & P[9]) |  (P[11] & P[10] & P[9] & P[8] & Carry_5stLevel[7]);
assign result_p[17] = Sum_4stLevel[12] ^ Carry_4stLevel[11] ^ Carry_5stLevel[10];
// column18
FullAdder column18_level1_0  (booth4[10],booth5[8],booth6[6],Sum_1stLevel[29], Carry_1stLevel[29]);
FullAdder column18_level1_1  (~booth1[16],booth2[14],booth3[12], Sum_1stLevel[30], Carry_1stLevel[30]);
FullAdder column18_level2_0  (booth7[4], Sum_1stLevel[29], Sum_1stLevel[30], Sum_2stLevel[21], Carry_2stLevel[21]);
HalfAdder column18_level2_1  (Carry_1stLevel[27], Carry_1stLevel[28],Sum_2stLevel[22], Carry_2stLevel[22]);
FullAdder column18_level3    (Sum_2stLevel[21],Sum_2stLevel[22], Carry_2stLevel[19],Sum_3stLevel[14], Carry_3stLevel[14]);
FullAdder column18_level4    (Carry_2stLevel[20],Sum_3stLevel[14], Carry_3stLevel[13],Sum_4stLevel[13], Carry_4stLevel[13]);
assign G[12] = Sum_4stLevel[13] & Carry_4stLevel[12];
assign P[12] = Sum_4stLevel[13] | Carry_4stLevel[12];
assign Carry_5stLevel[12] = G[12] | (G[11] & P[12]) | (G[10] & P[12] & P[11] ) | ( G[9] & P[12] & P[11] & P[10]) | ( G[8] & P[12] & P[11] & P[10] & P[9]) | (P[12] & P[11] & P[10] & P[9] & P[8] & Carry_5stLevel[7]);
assign result_p[18] = Sum_4stLevel[13] ^ Carry_4stLevel[12] ^ Carry_5stLevel[11];
//column19
FullAdder column19_level1_0  (booth5[9],booth6[7],booth7[5],Sum_1stLevel[31], Carry_1stLevel[31]);
FullAdder column19_level1_1  (booth2[15],booth3[13],booth4[11], Sum_1stLevel[32], Carry_1stLevel[32]);
FullAdder column19_level2    (Sum_1stLevel[31], Sum_1stLevel[32],Carry_1stLevel[29], Sum_2stLevel[23], Carry_2stLevel[23]);
FullAdder column19_level3    (Carry_1stLevel[30],Sum_2stLevel[23], Carry_2stLevel[21],Sum_3stLevel[15], Carry_3stLevel[15]);
FullAdder column19_level4    (Carry_2stLevel[22],Sum_3stLevel[15], Carry_3stLevel[14],Sum_4stLevel[14], Carry_4stLevel[14]);
assign G[13] = Sum_4stLevel[14] & Carry_4stLevel[13];
assign P[13] = Sum_4stLevel[14] | Carry_4stLevel[13];
assign Carry_5stLevel[13] = G[13] | (G[12] & P[13]) | (G[11] & P[13] & P[12] ) | ( G[10] & P[13] & P[12] & P[11]) | ( G[9] & P[13] & P[12] & P[11] & P[10]) | ( G[8] & P[13] & P[12] & P[11] & P[10] & P[9]) | (P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & Carry_5stLevel[7]);
assign result_p[19] = Sum_4stLevel[14] ^ Carry_4stLevel[13] ^ Carry_5stLevel[12];
//column20
FullAdder column20_level1_0  (booth5[10],booth6[8],booth7[6],Sum_1stLevel[33], Carry_1stLevel[33]);
FullAdder column20_level1_1  (~booth2[16],booth3[14],booth4[12], Sum_1stLevel[34], Carry_1stLevel[34]);
FullAdder column20_level2    (Sum_1stLevel[33], Sum_1stLevel[34],Carry_1stLevel[31], Sum_2stLevel[24], Carry_2stLevel[24]);
FullAdder column20_level3    (Carry_1stLevel[32],Sum_2stLevel[24], Carry_2stLevel[23],Sum_3stLevel[16], Carry_3stLevel[16]);
HalfAdder column20_level4    (Sum_3stLevel[16], Carry_3stLevel[15],Sum_4stLevel[15], Carry_4stLevel[15]);
assign G[14] = Sum_4stLevel[15] & Carry_4stLevel[14];
assign P[14] = Sum_4stLevel[15] | Carry_4stLevel[14];
assign Carry_5stLevel[14] = G[14] | (G[13] & P[14]) | (G[12] & P[14] & P[13] ) | ( G[11] & P[14] & P[13] & P[12]) | ( G[10] & P[14] & P[13] & P[12] & P[11]) | ( G[9] & P[14] & P[13] & P[12] & P[11] & P[10]) | ( G[8] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] ) | (P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & Carry_5stLevel[7]);
assign result_p[20] = Sum_4stLevel[15] ^ Carry_4stLevel[14] ^ Carry_5stLevel[13];
//colunm21
HalfAdder column21_level1_0  (booth6[9],booth7[7],Sum_1stLevel[35], Carry_1stLevel[35]);
FullAdder column21_level1_1  (booth3[15],booth4[13],booth5[11], Sum_1stLevel[36], Carry_1stLevel[36]);
FullAdder column21_level2    (Sum_1stLevel[35], Sum_1stLevel[36],Carry_1stLevel[33], Sum_2stLevel[25], Carry_2stLevel[25]);
FullAdder column21_level3    (Carry_1stLevel[34],Sum_2stLevel[25], Carry_2stLevel[24],Sum_3stLevel[17], Carry_3stLevel[17]);
HalfAdder column21_level4    (Sum_3stLevel[17], Carry_3stLevel[16],Sum_4stLevel[16], Carry_4stLevel[16]);
assign G[15] = Sum_4stLevel[16] & Carry_4stLevel[15];
assign P[15] = Sum_4stLevel[16] | Carry_4stLevel[15];
assign Carry_5stLevel[15] = G[15] | (G[14] & P[15]) | (G[13] & P[15] & P[14] ) | ( G[12] & P[15] & P[14] & P[13]) | ( G[11] & P[15] & P[14] & P[13] & P[12] ) | ( G[10] & P[15] & P[14] & P[13] & P[12] & P[11] ) | ( G[9] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] ) | ( G[8] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] ) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & Carry_5stLevel[7]);
assign result_p[21] = Sum_4stLevel[16] ^ Carry_4stLevel[15] ^ Carry_5stLevel[14];
//column22
HalfAdder column22_level1_0  (booth6[10],booth7[8],Sum_1stLevel[37], Carry_1stLevel[37]);
FullAdder column22_level1_1  (~booth3[16],booth4[14],booth5[12], Sum_1stLevel[38], Carry_1stLevel[38]);
FullAdder column22_level2    (Sum_1stLevel[37], Sum_1stLevel[38],Carry_1stLevel[35], Sum_2stLevel[26], Carry_2stLevel[26]);
FullAdder column22_level3    (Carry_1stLevel[36],Sum_2stLevel[26], Carry_2stLevel[25],Sum_3stLevel[18], Carry_3stLevel[18]);
HalfAdder column22_level4    (Sum_3stLevel[18], Carry_3stLevel[17],Sum_4stLevel[17], Carry_4stLevel[17]);
assign G[16] = Sum_4stLevel[17] & Carry_4stLevel[16];
assign P[16] = Sum_4stLevel[17] | Carry_4stLevel[16];
assign Carry_5stLevel[16] = G[16] | (P[16] & Carry_5stLevel[15]);
assign result_p[22] = Sum_4stLevel[17] ^ Carry_4stLevel[16] ^ Carry_5stLevel[15];
//column23
FullAdder column23_level1  (booth4[15],booth5[13],booth6[11], Sum_1stLevel[39], Carry_1stLevel[39]);
FullAdder column23_level2  (booth7[9],Sum_1stLevel[39], Carry_1stLevel[37], Sum_2stLevel[27], Carry_2stLevel[27]);
FullAdder column23_level3  (Carry_1stLevel[38],Sum_2stLevel[27], Carry_2stLevel[26],Sum_3stLevel[19], Carry_3stLevel[19]);
HalfAdder column23_level4  (Sum_3stLevel[19], Carry_3stLevel[18],Sum_4stLevel[18], Carry_4stLevel[18]);
assign G[17] = Sum_4stLevel[18] & Carry_4stLevel[17];
assign P[17] = Sum_4stLevel[18] | Carry_4stLevel[17];
assign Carry_5stLevel[17] = G[17] | (G[16] & P[17]) | (P[17] & P[16] & Carry_5stLevel[15]);
assign result_p[23] = Sum_4stLevel[18] ^ Carry_4stLevel[17] ^ Carry_5stLevel[16];
//column24
FullAdder column24_level1  (~booth4[16],booth5[14],booth6[12], Sum_1stLevel[40], Carry_1stLevel[40]);
FullAdder column24_level2  (booth7[10],Sum_1stLevel[40], Carry_1stLevel[39], Sum_2stLevel[28], Carry_2stLevel[28]);
HalfAdder column24_level3  (Sum_2stLevel[28], Carry_2stLevel[27],Sum_3stLevel[20], Carry_3stLevel[20]);
HalfAdder column24_level4  (Sum_3stLevel[20], Carry_3stLevel[19],Sum_4stLevel[19], Carry_4stLevel[19]);
assign G[18] = Sum_4stLevel[19] & Carry_4stLevel[18];
assign P[18] = Sum_4stLevel[19] | Carry_4stLevel[18];
assign Carry_5stLevel[18] = G[18] | (G[17] & P[18]) | (G[16] & P[18] & P[17]) | (P[18] & P[17] & P[16] & Carry_5stLevel[15]);
assign result_p[24] = Sum_4stLevel[19] ^ Carry_4stLevel[18] ^ Carry_5stLevel[17];
// column25
FullAdder column25_level1  (booth5[15],booth6[13],booth7[11], Sum_1stLevel[41], Carry_1stLevel[41]);
HalfAdder column25_level2  (Sum_1stLevel[41], Carry_1stLevel[40], Sum_2stLevel[29], Carry_2stLevel[29]);
HalfAdder column25_level3  (Sum_2stLevel[29], Carry_2stLevel[28],Sum_3stLevel[21], Carry_3stLevel[21]);
HalfAdder column25_level4  (Sum_3stLevel[21], Carry_3stLevel[20],Sum_4stLevel[20], Carry_4stLevel[20]);
assign G[19] = Sum_4stLevel[20] & Carry_4stLevel[19];
assign P[19] = Sum_4stLevel[20] | Carry_4stLevel[19];
assign Carry_5stLevel[19] = G[19] | (G[18] & P[19]) | (G[17] & P[19] & P[18]) | (G[16] & P[19] & P[18] & P[17]) | (P[19] & P[18] & P[17] & P[16] & Carry_5stLevel[15]);
assign result_p[25] = Sum_4stLevel[20] ^ Carry_4stLevel[19] ^ Carry_5stLevel[18];
// column26
FullAdder column26_level1  (~booth5[16],booth6[14],booth7[12], Sum_1stLevel[42], Carry_1stLevel[42]);
HalfAdder column26_level2  (Sum_1stLevel[42], Carry_1stLevel[41], Sum_2stLevel[30], Carry_2stLevel[30]);
HalfAdder column26_level3  (Sum_2stLevel[30], Carry_2stLevel[29],Sum_3stLevel[22], Carry_3stLevel[22]);
HalfAdder column26_level4  (Sum_3stLevel[22], Carry_3stLevel[21],Sum_4stLevel[21], Carry_4stLevel[21]);
assign G[20] = Sum_4stLevel[21] & Carry_4stLevel[20];
assign P[20] = Sum_4stLevel[21] | Carry_4stLevel[20];
assign Carry_5stLevel[20] = G[20] | (G[19] & P[20]) | (G[18] & P[20] & P[19]) | (G[17] & P[20] & P[19] & P[18]) | (G[16] & P[20] & P[19] & P[18] & P[17]) | (P[20] & P[19] & P[18] & P[17] & P[16] & Carry_5stLevel[15]);
assign result_p[26] = Sum_4stLevel[21] ^ Carry_4stLevel[20] ^ Carry_5stLevel[19];
// column27
HalfAdder column27_level1  (booth6[15],booth7[13], Sum_1stLevel[43], Carry_1stLevel[43]);
HalfAdder column27_level2  (Sum_1stLevel[43], Carry_1stLevel[42], Sum_2stLevel[31], Carry_2stLevel[31]);
HalfAdder column27_level3  (Sum_2stLevel[31], Carry_2stLevel[30],Sum_3stLevel[23], Carry_3stLevel[23]);
HalfAdder column27_level4  (Sum_3stLevel[23], Carry_3stLevel[22],Sum_4stLevel[22], Carry_4stLevel[22]);
assign G[21] = Sum_4stLevel[22] & Carry_4stLevel[21];
assign P[21] = Sum_4stLevel[22] | Carry_4stLevel[21];
assign Carry_5stLevel[21] = G[21] | (G[20] & P[21]) | (G[19] & P[21] & P[20]) | (G[18] & P[21] & P[20] & P[19]) | (G[17] & P[21] & P[20] & P[19] & P[18]) | (G[16] & P[21] & P[20] & P[19] & P[18] & P[17]) | (P[21] & P[20] & P[19] & P[18] & P[17] & P[16] & Carry_5stLevel[15]);
assign result_p[27] = Sum_4stLevel[22] ^ Carry_4stLevel[21] ^ Carry_5stLevel[20];
// column28
HalfAdder column28_level1  (~booth6[16],booth7[14], Sum_1stLevel[44], Carry_1stLevel[44]);
HalfAdder column28_level2  (Sum_1stLevel[44], Carry_1stLevel[43], Sum_2stLevel[32], Carry_2stLevel[32]);
HalfAdder column28_level3  (Sum_2stLevel[32], Carry_2stLevel[31],Sum_3stLevel[24], Carry_3stLevel[24]);
HalfAdder column28_level4  (Sum_3stLevel[24], Carry_3stLevel[23],Sum_4stLevel[23], Carry_4stLevel[23]);
assign G[22] = Sum_4stLevel[23] & Carry_4stLevel[22];
assign P[22] = Sum_4stLevel[23] | Carry_4stLevel[22];
assign Carry_5stLevel[22] = G[22] | (G[21] & P[22]) | (G[20] & P[22] & P[21] ) | (G[19] & P[22] & P[21] & P[20]) | (G[18] & P[22] & P[21] & P[20] & P[19]) | (G[17] & P[22] & P[21] & P[20] & P[19] & P[18] ) | (G[16] & P[22] & P[21] & P[20] & P[19] & P[18] & P[17] ) | (P[22] & P[21] & P[20] & P[19] & P[18] & P[17] & P[16] & Carry_5stLevel[15]);
assign result_p[28] = Sum_4stLevel[23] ^ Carry_4stLevel[22] ^ Carry_5stLevel[21];
// column29
HalfAdder column29_level2  (booth7[15], Carry_1stLevel[44], Sum_2stLevel[33], Carry_2stLevel[33]);
HalfAdder column29_level3  (Sum_2stLevel[33], Carry_2stLevel[32],Sum_3stLevel[25], Carry_3stLevel[25]);
HalfAdder column29_level4  (Sum_3stLevel[25], Carry_3stLevel[24],Sum_4stLevel[24], Carry_4stLevel[24]);
assign G[23] = Sum_4stLevel[24] & Carry_4stLevel[23];
assign P[23] = Sum_4stLevel[24] | Carry_4stLevel[23];
assign Carry_5stLevel[23] = G[23] | (G[22] & P[23]) | (G[21] & P[23] & P[22] ) | (G[20] & P[23] & P[22] & P[21]) | (G[19] & P[23] & P[22] & P[21] & P[20]) | (G[18] & P[23] & P[22] & P[21] & P[20] & P[19]) | (G[17] & P[23] & P[22] & P[21] & P[20] & P[19] & P[18] ) | (G[16] & P[23] & P[22] & P[21] & P[20] & P[19] & P[18] & P[17] ) | (P[23] & P[22] & P[21] & P[20] & P[19] & P[18] & P[17] & P[16] & Carry_5stLevel[15]);
assign result_p[29] = Sum_4stLevel[24] ^ Carry_4stLevel[23] ^ Carry_5stLevel[22];
// column30
HalfAdder column30_level3  (~booth7[16], Carry_2stLevel[33],Sum_3stLevel[26], Carry_3stLevel[26]);
HalfAdder column30_level4  (Sum_3stLevel[26], Carry_3stLevel[25],Sum_4stLevel[25], Carry_4stLevel[25]);
assign result_p[30] = Sum_4stLevel[25] ^ Carry_4stLevel[24] ^ Carry_5stLevel[23];
// After inversing boothi[16],it transfers the summary of  left-up triangle area to constanst 31'h2aab_0000 
assign tempt_result = result_p + 31'h2aab_0000;// A carry lookahead adder should be used here, but I am lazy
// true form result for displaying
assign result  = tempt_result[30] ? ({1'b1,~tempt_result[29:0]}+1'b1): tempt_result;

endmodule
