
// Generated by Cadence Genus(TM) Synthesis Solution 17.10-p007_1
// Generated on: Dec  9 2018 18:55:39 EST (Dec  9 2018 23:55:39 UTC)

// Verification Directory fv/rv_adder 

module rv_adder(in_a, in_b, in_sign, in_sub, out_sum);
  input [31:0] in_a, in_b;
  input in_sign, in_sub;
  output [32:0] out_sum;
  wire [31:0] in_a, in_b;
  wire in_sign, in_sub;
  wire [32:0] out_sum;
  wire n_0, n_1, n_2, n_3, n_4, n_5, n_6, n_7;
  wire n_8, n_9, n_10, n_11, n_12, n_13, n_14, n_15;
  wire n_16, n_17, n_18, n_19, n_20, n_21, n_22, n_23;
  wire n_24, n_25, n_26, n_27, n_28, n_29, n_30, n_31;
  wire n_32, n_33, n_34, n_35, n_36, n_37, n_38, n_39;
  wire n_40, n_41, n_42, n_43, n_44, n_45, n_46, n_47;
  wire n_48, n_49, n_50, n_51, n_52, n_53, n_54, n_55;
  wire n_56, n_57, n_58, n_59, n_60, n_61, n_62, n_63;
  wire n_64, n_65, n_66, n_67, n_68, n_69, n_70, n_71;
  wire n_72, n_73, n_74, n_75, n_76, n_77, n_78, n_79;
  wire n_80, n_81, n_82, n_83, n_84, n_85, n_86, n_87;
  wire n_88, n_89, n_90, n_91, n_92, n_93, n_94, n_95;
  wire n_96, n_97, n_98, n_100, n_101, n_103, n_104, n_106;
  wire n_107, n_109, n_110, n_112, n_113, n_115, n_116, n_118;
  wire n_119, n_121, n_122, n_124, n_125, n_127, n_128, n_130;
  wire n_131, n_133, n_134, n_136, n_137, n_139, n_140, n_142;
  wire n_143, n_145, n_146, n_148, n_149, n_151, n_152, n_154;
  wire n_155, n_157, n_158, n_160, n_161, n_163, n_164, n_166;
  wire n_167, n_169, n_170, n_172, n_173, n_175, n_176, n_178;
  wire n_179, n_181, n_182, n_184, n_185, n_187, n_188, n_190;
  wire n_200, n_202;
  XNOR2X1 g2561__7837(.A (n_34), .B (n_202), .Y (out_sum[32]));
  OR2X1 g2565__1377(.A (n_70), .B (n_188), .Y (n_190));
  ADDHX1 g2566__3717(.A (n_71), .B (n_187), .CO (n_188), .S
       (out_sum[30]));
  OR2X1 g2567__4599(.A (n_86), .B (n_185), .Y (n_187));
  ADDHX1 g2568__3779(.A (n_87), .B (n_184), .CO (n_185), .S
       (out_sum[29]));
  OR2X1 g2569__2007(.A (n_72), .B (n_182), .Y (n_184));
  ADDHX1 g2570__1237(.A (n_73), .B (n_181), .CO (n_182), .S
       (out_sum[28]));
  OR2X1 g2571__1297(.A (n_52), .B (n_179), .Y (n_181));
  ADDHX1 g2572__2006(.A (n_53), .B (n_178), .CO (n_179), .S
       (out_sum[27]));
  OR2X1 g2573__2833(.A (n_36), .B (n_176), .Y (n_178));
  ADDHX1 g2574__7547(.A (n_37), .B (n_175), .CO (n_176), .S
       (out_sum[26]));
  OR2X1 g2575__7765(.A (n_60), .B (n_173), .Y (n_175));
  ADDHX1 g2576__9867(.A (n_61), .B (n_172), .CO (n_173), .S
       (out_sum[25]));
  OR2X1 g2577__3377(.A (n_38), .B (n_170), .Y (n_172));
  ADDHX1 g2578__9719(.A (n_39), .B (n_169), .CO (n_170), .S
       (out_sum[24]));
  OR2X1 g2579__1591(.A (n_50), .B (n_167), .Y (n_169));
  ADDHX1 g2580__6789(.A (n_51), .B (n_166), .CO (n_167), .S
       (out_sum[23]));
  OR2X1 g2581__5927(.A (n_74), .B (n_164), .Y (n_166));
  ADDHX1 g2582__2001(.A (n_75), .B (n_163), .CO (n_164), .S
       (out_sum[22]));
  OR2X1 g2583__1122(.A (n_54), .B (n_161), .Y (n_163));
  ADDHX1 g2584__2005(.A (n_55), .B (n_160), .CO (n_161), .S
       (out_sum[21]));
  OR2X1 g2585__9771(.A (n_88), .B (n_158), .Y (n_160));
  ADDHX1 g2586__3457(.A (n_89), .B (n_157), .CO (n_158), .S
       (out_sum[20]));
  OR2X1 g2587__1279(.A (n_58), .B (n_155), .Y (n_157));
  ADDHX1 g2588__6179(.A (n_59), .B (n_154), .CO (n_155), .S
       (out_sum[19]));
  OR2X1 g2589__7837(.A (n_90), .B (n_152), .Y (n_154));
  ADDHX1 g2590__7557(.A (n_91), .B (n_151), .CO (n_152), .S
       (out_sum[18]));
  OR2X1 g2591__7654(.A (n_62), .B (n_149), .Y (n_151));
  ADDHX1 g2592__8867(.A (n_63), .B (n_148), .CO (n_149), .S
       (out_sum[17]));
  OR2X1 g2593__1377(.A (n_96), .B (n_146), .Y (n_148));
  ADDHX1 g2594__3717(.A (n_97), .B (n_145), .CO (n_146), .S
       (out_sum[16]));
  OR2X1 g2595__4599(.A (n_64), .B (n_143), .Y (n_145));
  ADDHX1 g2596__3779(.A (n_65), .B (n_142), .CO (n_143), .S
       (out_sum[15]));
  OR2X1 g2597__2007(.A (n_76), .B (n_140), .Y (n_142));
  ADDHX1 g2598__1237(.A (n_77), .B (n_139), .CO (n_140), .S
       (out_sum[14]));
  OR2X1 g2599__1297(.A (n_40), .B (n_137), .Y (n_139));
  ADDHX1 g2600__2006(.A (n_41), .B (n_136), .CO (n_137), .S
       (out_sum[13]));
  OR2X1 g2601__2833(.A (n_68), .B (n_134), .Y (n_136));
  ADDHX1 g2602__7547(.A (n_69), .B (n_133), .CO (n_134), .S
       (out_sum[12]));
  OR2X1 g2603__7765(.A (n_78), .B (n_131), .Y (n_133));
  ADDHX1 g2604__9867(.A (n_79), .B (n_130), .CO (n_131), .S
       (out_sum[11]));
  OR2X1 g2605__3377(.A (n_48), .B (n_128), .Y (n_130));
  ADDHX1 g2606__9719(.A (n_49), .B (n_127), .CO (n_128), .S
       (out_sum[10]));
  OR2X1 g2607__1591(.A (n_42), .B (n_125), .Y (n_127));
  ADDHX1 g2608__6789(.A (n_43), .B (n_124), .CO (n_125), .S
       (out_sum[9]));
  OR2X1 g2609__5927(.A (n_80), .B (n_122), .Y (n_124));
  ADDHX1 g2610__2001(.A (n_81), .B (n_121), .CO (n_122), .S
       (out_sum[8]));
  OR2X1 g2611__1122(.A (n_82), .B (n_119), .Y (n_121));
  ADDHX1 g2612__2005(.A (n_83), .B (n_118), .CO (n_119), .S
       (out_sum[7]));
  OR2X1 g2613__9771(.A (n_92), .B (n_116), .Y (n_118));
  ADDHX1 g2614__3457(.A (n_93), .B (n_115), .CO (n_116), .S
       (out_sum[6]));
  OR2X1 g2615__1279(.A (n_44), .B (n_113), .Y (n_115));
  ADDHX1 g2616__6179(.A (n_45), .B (n_112), .CO (n_113), .S
       (out_sum[5]));
  OR2X1 g2617__7837(.A (n_84), .B (n_110), .Y (n_112));
  ADDHX1 g2618__7557(.A (n_85), .B (n_109), .CO (n_110), .S
       (out_sum[4]));
  OR2X1 g2619__7654(.A (n_94), .B (n_107), .Y (n_109));
  ADDHX1 g2620__8867(.A (n_95), .B (n_106), .CO (n_107), .S
       (out_sum[3]));
  OR2X1 g2621__1377(.A (n_56), .B (n_104), .Y (n_106));
  ADDHX1 g2622__3717(.A (n_57), .B (n_103), .CO (n_104), .S
       (out_sum[2]));
  OR2X1 g2623__4599(.A (n_46), .B (n_101), .Y (n_103));
  ADDHX1 g2624__3779(.A (n_47), .B (n_100), .CO (n_101), .S
       (out_sum[1]));
  OR2X1 g2625__2007(.A (n_66), .B (n_98), .Y (n_100));
  ADDHX1 g2626__1237(.A (in_sub), .B (n_67), .CO (n_98), .S
       (out_sum[0]));
  ADDHX1 g2627__1297(.A (in_a[16]), .B (n_17), .CO (n_96), .S (n_97));
  ADDHX1 g2631__2006(.A (in_a[3]), .B (n_6), .CO (n_94), .S (n_95));
  ADDHX1 g2646__2833(.A (in_a[6]), .B (n_11), .CO (n_92), .S (n_93));
  ADDHX1 g2645__7547(.A (in_a[18]), .B (n_30), .CO (n_90), .S (n_91));
  ADDHX1 g2653__7765(.A (in_a[20]), .B (n_24), .CO (n_88), .S (n_89));
  ADDHX1 g2635__9867(.A (in_a[29]), .B (n_8), .CO (n_86), .S (n_87));
  ADDHX1 g2652__3377(.A (in_a[4]), .B (n_12), .CO (n_84), .S (n_85));
  ADDHX1 g2647__9719(.A (in_a[7]), .B (n_15), .CO (n_82), .S (n_83));
  ADDHX1 g2656__1591(.A (in_a[8]), .B (n_18), .CO (n_80), .S (n_81));
  ADDHX1 g2639__6789(.A (in_a[11]), .B (n_29), .CO (n_78), .S (n_79));
  ADDHX1 g2650__5927(.A (in_a[14]), .B (n_33), .CO (n_76), .S (n_77));
  ADDHX1 g2649__2001(.A (in_a[22]), .B (n_16), .CO (n_74), .S (n_75));
  ADDHX1 g2655__1122(.A (in_a[28]), .B (n_3), .CO (n_72), .S (n_73));
  ADDHX1 g2643__2005(.A (in_a[30]), .B (n_25), .CO (n_70), .S (n_71));
  ADDHX1 g2654__9771(.A (in_a[12]), .B (n_14), .CO (n_68), .S (n_69));
  ADDHX1 g2651__3457(.A (in_a[0]), .B (n_26), .CO (n_66), .S (n_67));
  ADDHX1 g2657__1279(.A (in_a[15]), .B (n_4), .CO (n_64), .S (n_65));
  ADDHX1 g2630__6179(.A (in_a[17]), .B (n_32), .CO (n_62), .S (n_63));
  ADDHX1 g2632__7837(.A (in_a[25]), .B (n_21), .CO (n_60), .S (n_61));
  ADDHX1 g2634__7557(.A (in_a[19]), .B (n_19), .CO (n_58), .S (n_59));
  ADDHX1 g2644__7654(.A (in_a[2]), .B (n_10), .CO (n_56), .S (n_57));
  ADDHX1 g2638__8867(.A (in_a[21]), .B (n_5), .CO (n_54), .S (n_55));
  ADDHX1 g2640__1377(.A (in_a[27]), .B (n_28), .CO (n_52), .S (n_53));
  ADDHX1 g2642__3717(.A (in_a[23]), .B (n_27), .CO (n_50), .S (n_51));
  ADDHX1 g2648__4599(.A (in_a[10]), .B (n_7), .CO (n_48), .S (n_49));
  ADDHX1 g2629__3779(.A (in_a[1]), .B (n_23), .CO (n_46), .S (n_47));
  ADDHX1 g2633__2007(.A (in_a[5]), .B (n_9), .CO (n_44), .S (n_45));
  ADDHX1 g2637__1237(.A (in_a[9]), .B (n_22), .CO (n_42), .S (n_43));
  ADDHX1 g2641__1297(.A (in_a[13]), .B (n_20), .CO (n_40), .S (n_41));
  ADDHX1 g2628__2006(.A (in_a[24]), .B (n_2), .CO (n_38), .S (n_39));
  ADDHX1 g2636__2833(.A (in_a[26]), .B (n_13), .CO (n_36), .S (n_37));
  XNOR2X1 g2659__7765(.A (n_0), .B (in_sub), .Y (n_34));
  XNOR2X1 g2661__9867(.A (in_b[14]), .B (n_31), .Y (n_33));
  XNOR2X1 g2685__3377(.A (in_b[17]), .B (n_31), .Y (n_32));
  XNOR2X1 g2686__9719(.A (in_b[18]), .B (n_31), .Y (n_30));
  XNOR2X1 g2688__1591(.A (in_b[11]), .B (n_31), .Y (n_29));
  XNOR2X1 g2689__6789(.A (in_b[27]), .B (n_31), .Y (n_28));
  XNOR2X1 g2690__5927(.A (in_b[23]), .B (n_31), .Y (n_27));
  XNOR2X1 g2680__2001(.A (in_b[0]), .B (n_31), .Y (n_26));
  XNOR2X1 g2684__1122(.A (in_b[30]), .B (n_31), .Y (n_25));
  XNOR2X1 g2679__2005(.A (in_b[20]), .B (n_31), .Y (n_24));
  XNOR2X1 g2691__9771(.A (in_b[1]), .B (n_31), .Y (n_23));
  XNOR2X1 g2675__3457(.A (in_b[9]), .B (n_31), .Y (n_22));
  XNOR2X1 g2687__1279(.A (in_b[25]), .B (n_31), .Y (n_21));
  XNOR2X1 g2674__6179(.A (in_b[13]), .B (n_31), .Y (n_20));
  XNOR2X1 g2668__7837(.A (in_b[19]), .B (n_31), .Y (n_19));
  XNOR2X1 g2660__7557(.A (in_b[8]), .B (n_31), .Y (n_18));
  XNOR2X1 g2683__7654(.A (in_b[16]), .B (n_31), .Y (n_17));
  XNOR2X1 g2682__8867(.A (in_b[22]), .B (n_31), .Y (n_16));
  XNOR2X1 g2664__1377(.A (in_b[7]), .B (n_31), .Y (n_15));
  XNOR2X1 g2662__3717(.A (in_b[12]), .B (n_31), .Y (n_14));
  XNOR2X1 g2665__4599(.A (in_b[26]), .B (n_31), .Y (n_13));
  XNOR2X1 g2672__3779(.A (in_b[4]), .B (n_31), .Y (n_12));
  XNOR2X1 g2666__2007(.A (in_b[6]), .B (n_31), .Y (n_11));
  XNOR2X1 g2667__1237(.A (in_b[2]), .B (n_31), .Y (n_10));
  XNOR2X1 g2669__1297(.A (in_b[5]), .B (n_31), .Y (n_9));
  XNOR2X1 g2670__2006(.A (in_b[29]), .B (n_31), .Y (n_8));
  XNOR2X1 g2671__2833(.A (in_b[10]), .B (n_31), .Y (n_7));
  XNOR2X1 g2673__7547(.A (in_b[3]), .B (n_31), .Y (n_6));
  XNOR2X1 g2676__7765(.A (in_b[21]), .B (n_31), .Y (n_5));
  XNOR2X1 g2677__9867(.A (in_b[15]), .B (n_31), .Y (n_4));
  XNOR2X1 g2678__3377(.A (in_b[28]), .B (n_31), .Y (n_3));
  XNOR2X1 g2681__9719(.A (in_b[24]), .B (n_31), .Y (n_2));
  XNOR2X1 g2663__1591(.A (in_b[31]), .B (n_31), .Y (n_35));
  NAND2XL g2693__6789(.A (in_sign), .B (in_a[31]), .Y (n_1));
  NAND2XL g2692__5927(.A (in_sign), .B (in_b[31]), .Y (n_0));
  INVX2 g2694(.A (in_sub), .Y (n_31));
  ADDFX1 g2(.A (n_35), .B (in_a[31]), .CI (n_190), .CO (n_200), .S
       (out_sum[31]));
  CLKXOR2X1 g2695(.A (n_200), .B (n_1), .Y (n_202));
endmodule

