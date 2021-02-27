; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.hdr_cursor = type { i8* }
%struct.collect_vlans = type { [2 x i16] }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.vlan_hdr = type { i16, i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.ipv6hdr = type { i8, [3 x i8], i16, i8, i8, %struct.in6_addr, %struct.in6_addr }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.icmphdr_common = type { i8, i8, i16 }
%struct.bpf_fib_lookup = type { i8, i8, i16, i16, i16, i32, %union.anon.0, %union.anon.1, %union.anon.2, i16, i16, [6 x i8], [6 x i8] }
%union.anon.0 = type { i32 }
%union.anon.1 = type { [4 x i32] }
%union.anon.2 = type { [4 x i32] }
%struct.newiphdr = type { i8, i8, i8, i8, i32, i32 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0 }, section "maps", align 4, !dbg !0
@tx_port = dso_local global %struct.bpf_map_def { i32 14, i32 4, i32 4, i32 256, i32 0 }, section "maps", align 4, !dbg !76
@redirect_params = dso_local global %struct.bpf_map_def { i32 1, i32 6, i32 6, i32 1, i32 0 }, section "maps", align 4, !dbg !86
@__const.xdp_router_func.____fmt = private unnamed_addr constant [16 x i8] c"total size: %d\0A\00", align 1
@__const.xdp_router_func.____fmt.1 = private unnamed_addr constant [14 x i8] c"eth size: %d\0A\00", align 1
@__const.xdp_router_func.____fmt.2 = private unnamed_addr constant [16 x i8] c"newip size: %d\0A\00", align 1
@__const.xdp_router_func.____fmt.3 = private unnamed_addr constant [15 x i8] c"addr cast: %d\0A\00", align 1
@__const.xdp_router_func.____fmt.4 = private unnamed_addr constant [33 x i8] c"src addr type: %d, src addr :%d\0A\00", align 1
@__const.xdp_router_func.____fmt.5 = private unnamed_addr constant [33 x i8] c"dst addr type: %d, dst addr :%d\0A\00", align 1
@__const.xdp_router_func.____fmt.6 = private unnamed_addr constant [11 x i8] c"dummy: %d\0A\00", align 1
@__const.xdp_router_func.____fmt.9 = private unnamed_addr constant [20 x i8] c"lookup successfull\0A\00", align 1
@__const.xdp_router_func.____fmt.10 = private unnamed_addr constant [12 x i8] c"action: %d\0A\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !88
@llvm.used = appending global [9 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @redirect_params to i8*), i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_icmp_echo_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_map_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_router_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_icmp_echo_func(%struct.xdp_md* nocapture readonly %0) #0 section "xdp_icmp_echo" !dbg !235 {
  %2 = alloca [4 x i32], align 4
  call void @llvm.dbg.declare(metadata [4 x i32]* %2, metadata !312, metadata !DIExpression()), !dbg !319
  %3 = alloca [6 x i8], align 1
  call void @llvm.dbg.declare(metadata [6 x i8]* %3, metadata !324, metadata !DIExpression()), !dbg !330
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !247, metadata !DIExpression()), !dbg !332
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !333
  %7 = load i32, i32* %6, align 4, !dbg !333, !tbaa !334
  %8 = zext i32 %7 to i64, !dbg !339
  %9 = inttoptr i64 %8 to i8*, !dbg !340
  call void @llvm.dbg.value(metadata i8* %9, metadata !248, metadata !DIExpression()), !dbg !332
  %10 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !341
  %11 = load i32, i32* %10, align 4, !dbg !341, !tbaa !342
  %12 = zext i32 %11 to i64, !dbg !343
  %13 = inttoptr i64 %12 to i8*, !dbg !344
  call void @llvm.dbg.value(metadata i8* %13, metadata !249, metadata !DIExpression()), !dbg !332
  %14 = bitcast i32* %5 to i8*, !dbg !345
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %14) #4, !dbg !345
  call void @llvm.dbg.value(metadata i32 2, metadata !310, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata i8* %13, metadata !250, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !346, metadata !DIExpression()), !dbg !355
  call void @llvm.dbg.value(metadata i8* %9, metadata !353, metadata !DIExpression()), !dbg !355
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !357, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata i8* %9, metadata !369, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !371, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata i8* %13, metadata !372, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata i32 14, metadata !373, metadata !DIExpression()), !dbg !382
  %15 = getelementptr i8, i8* %13, i64 14, !dbg !384
  %16 = icmp ugt i8* %15, %9, !dbg !386
  br i1 %16, label %119, label %17, !dbg !387

17:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %13, metadata !372, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata i8* %15, metadata !250, metadata !DIExpression()), !dbg !332
  %18 = inttoptr i64 %12 to %struct.ethhdr*, !dbg !388
  call void @llvm.dbg.value(metadata i8* %15, metadata !374, metadata !DIExpression()), !dbg !382
  %19 = getelementptr inbounds i8, i8* %13, i64 12, !dbg !389
  %20 = bitcast i8* %19 to i16*, !dbg !389
  call void @llvm.dbg.value(metadata i16 undef, metadata !380, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata i32 0, metadata !381, metadata !DIExpression()), !dbg !382
  %21 = load i16, i16* %20, align 1, !dbg !382, !tbaa !390
  call void @llvm.dbg.value(metadata i16 %21, metadata !380, metadata !DIExpression()), !dbg !382
  %22 = inttoptr i64 %8 to %struct.vlan_hdr*, !dbg !392
  %23 = getelementptr i8, i8* %13, i64 22, !dbg !397
  %24 = bitcast i8* %23 to %struct.vlan_hdr*, !dbg !397
  switch i16 %21, label %39 [
    i16 -22392, label %25
    i16 129, label %25
  ], !dbg !398

25:                                               ; preds = %17, %17
  %26 = getelementptr i8, i8* %13, i64 18, !dbg !399
  %27 = bitcast i8* %26 to %struct.vlan_hdr*, !dbg !399
  %28 = icmp ugt %struct.vlan_hdr* %27, %22, !dbg !400
  br i1 %28, label %39, label %29, !dbg !401

29:                                               ; preds = %25
  call void @llvm.dbg.value(metadata i16 undef, metadata !380, metadata !DIExpression()), !dbg !382
  %30 = getelementptr i8, i8* %13, i64 16, !dbg !402
  %31 = bitcast i8* %30 to i16*, !dbg !402
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %27, metadata !374, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata i32 1, metadata !381, metadata !DIExpression()), !dbg !382
  %32 = load i16, i16* %31, align 1, !dbg !382, !tbaa !390
  call void @llvm.dbg.value(metadata i16 %32, metadata !380, metadata !DIExpression()), !dbg !382
  switch i16 %32, label %39 [
    i16 -22392, label %33
    i16 129, label %33
  ], !dbg !398

33:                                               ; preds = %29, %29
  %34 = icmp ugt %struct.vlan_hdr* %24, %22, !dbg !400
  br i1 %34, label %39, label %35, !dbg !401

35:                                               ; preds = %33
  call void @llvm.dbg.value(metadata i16 undef, metadata !380, metadata !DIExpression()), !dbg !382
  %36 = getelementptr i8, i8* %13, i64 20, !dbg !402
  %37 = bitcast i8* %36 to i16*, !dbg !402
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %24, metadata !374, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata i32 2, metadata !381, metadata !DIExpression()), !dbg !382
  %38 = load i16, i16* %37, align 1, !dbg !382, !tbaa !390
  call void @llvm.dbg.value(metadata i16 %38, metadata !380, metadata !DIExpression()), !dbg !382
  br label %39

39:                                               ; preds = %17, %25, %29, %33, %35
  %40 = phi i8* [ %15, %17 ], [ %15, %25 ], [ %26, %29 ], [ %26, %33 ], [ %23, %35 ], !dbg !382
  %41 = phi i16 [ %21, %17 ], [ %21, %25 ], [ %32, %29 ], [ %32, %33 ], [ %38, %35 ], !dbg !382
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !374, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !374, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !374, metadata !DIExpression()), !dbg !382
  call void @llvm.dbg.value(metadata i8* %40, metadata !250, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata i8* %40, metadata !250, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata i16 %41, metadata !264, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !332
  switch i16 %41, label %119 [
    i16 8, label %42
    i16 -8826, label %59
  ], !dbg !403

42:                                               ; preds = %39
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !404, metadata !DIExpression()), !dbg !414
  call void @llvm.dbg.value(metadata i8* %9, metadata !410, metadata !DIExpression()), !dbg !414
  call void @llvm.dbg.value(metadata i8* %40, metadata !412, metadata !DIExpression()), !dbg !414
  %43 = getelementptr inbounds i8, i8* %40, i64 20, !dbg !418
  %44 = icmp ugt i8* %43, %9, !dbg !420
  br i1 %44, label %119, label %45, !dbg !421

45:                                               ; preds = %42
  %46 = load i8, i8* %40, align 4, !dbg !422
  %47 = shl i8 %46, 2, !dbg !423
  %48 = and i8 %47, 60, !dbg !423
  call void @llvm.dbg.value(metadata i8 %48, metadata !413, metadata !DIExpression()), !dbg !414
  %49 = icmp ult i8 %48, 8, !dbg !424
  br i1 %49, label %119, label %50, !dbg !426

50:                                               ; preds = %45
  %51 = zext i8 %48 to i64, !dbg !427
  call void @llvm.dbg.value(metadata i64 %51, metadata !413, metadata !DIExpression()), !dbg !414
  %52 = getelementptr i8, i8* %40, i64 %51, !dbg !428
  %53 = icmp ugt i8* %52, %9, !dbg !430
  br i1 %53, label %119, label %54, !dbg !431

54:                                               ; preds = %50
  call void @llvm.dbg.value(metadata i8* %52, metadata !250, metadata !DIExpression()), !dbg !332
  %55 = bitcast i8* %40 to %struct.iphdr*, !dbg !432
  %56 = getelementptr inbounds i8, i8* %40, i64 9, !dbg !433
  %57 = load i8, i8* %56, align 1, !dbg !433, !tbaa !434
  call void @llvm.dbg.value(metadata i8* %52, metadata !250, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata i8 %57, metadata !265, metadata !DIExpression()), !dbg !332
  %58 = icmp eq i8 %57, 1, !dbg !436
  br i1 %58, label %69, label %119, !dbg !438

59:                                               ; preds = %39
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !439, metadata !DIExpression()), !dbg !448
  call void @llvm.dbg.value(metadata i8* %9, metadata !445, metadata !DIExpression()), !dbg !448
  call void @llvm.dbg.value(metadata i8* %40, metadata !447, metadata !DIExpression()), !dbg !448
  %60 = getelementptr inbounds i8, i8* %40, i64 40, !dbg !452
  %61 = bitcast i8* %60 to %struct.ipv6hdr*, !dbg !452
  %62 = inttoptr i64 %8 to %struct.ipv6hdr*, !dbg !454
  %63 = icmp ugt %struct.ipv6hdr* %61, %62, !dbg !455
  br i1 %63, label %119, label %64, !dbg !456

64:                                               ; preds = %59
  %65 = bitcast i8* %40 to %struct.ipv6hdr*, !dbg !457
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %65, metadata !447, metadata !DIExpression()), !dbg !448
  call void @llvm.dbg.value(metadata i8* %60, metadata !250, metadata !DIExpression()), !dbg !332
  %66 = getelementptr inbounds i8, i8* %40, i64 6, !dbg !458
  %67 = load i8, i8* %66, align 2, !dbg !458, !tbaa !459
  call void @llvm.dbg.value(metadata i8* %60, metadata !250, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata i8 %67, metadata !265, metadata !DIExpression()), !dbg !332
  %68 = icmp eq i8 %67, 58, !dbg !462
  br i1 %68, label %69, label %119, !dbg !464

69:                                               ; preds = %54, %64
  %70 = phi i1 [ true, %54 ], [ false, %64 ]
  %71 = phi i32 [ 8, %54 ], [ 56710, %64 ]
  %72 = phi i8* [ %52, %54 ], [ %60, %64 ], !dbg !465
  %73 = phi %struct.iphdr* [ %55, %54 ], [ undef, %64 ]
  %74 = phi %struct.ipv6hdr* [ undef, %54 ], [ %65, %64 ]
  call void @llvm.dbg.value(metadata i8* %72, metadata !250, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !466, metadata !DIExpression()), !dbg !475
  call void @llvm.dbg.value(metadata i8* %9, metadata !472, metadata !DIExpression()), !dbg !475
  call void @llvm.dbg.value(metadata i8* %72, metadata !474, metadata !DIExpression()), !dbg !475
  %75 = getelementptr inbounds i8, i8* %72, i64 4, !dbg !477
  %76 = bitcast i8* %75 to %struct.icmphdr_common*, !dbg !477
  %77 = inttoptr i64 %8 to %struct.icmphdr_common*, !dbg !479
  %78 = icmp ugt %struct.icmphdr_common* %76, %77, !dbg !480
  br i1 %78, label %119, label %79, !dbg !481

79:                                               ; preds = %69
  call void @llvm.dbg.value(metadata %struct.icmphdr_common* %76, metadata !250, metadata !DIExpression()), !dbg !332
  %80 = load i8, i8* %72, align 2, !dbg !482, !tbaa !483
  call void @llvm.dbg.value(metadata i8 %80, metadata !266, metadata !DIExpression()), !dbg !332
  %81 = icmp eq i8 %80, 8, !dbg !485
  %82 = and i1 %70, %81, !dbg !486
  br i1 %82, label %83, label %88, !dbg !486

83:                                               ; preds = %79
  call void @llvm.dbg.value(metadata %struct.iphdr* %73, metadata !267, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata %struct.iphdr* %73, metadata !487, metadata !DIExpression()), !dbg !493
  %84 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %73, i64 0, i32 8, !dbg !496
  %85 = load i32, i32* %84, align 4, !dbg !496, !tbaa !497
  call void @llvm.dbg.value(metadata i32 %85, metadata !492, metadata !DIExpression()), !dbg !493
  %86 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %73, i64 0, i32 9, !dbg !498
  %87 = load i32, i32* %86, align 4, !dbg !498, !tbaa !499
  store i32 %87, i32* %84, align 4, !dbg !500, !tbaa !497
  store i32 %85, i32* %86, align 4, !dbg !501, !tbaa !499
  call void @llvm.dbg.value(metadata i16 0, metadata !300, metadata !DIExpression()), !dbg !332
  br label %98, !dbg !502

88:                                               ; preds = %79
  call void @llvm.dbg.value(metadata i8 %80, metadata !266, metadata !DIExpression()), !dbg !332
  %89 = icmp eq i32 %71, 56710, !dbg !503
  %90 = icmp eq i8 %80, -128, !dbg !504
  %91 = and i1 %89, %90, !dbg !505
  br i1 %91, label %92, label %119, !dbg !505

92:                                               ; preds = %88
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %74, metadata !284, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %74, metadata !318, metadata !DIExpression()) #4, !dbg !506
  %93 = bitcast [4 x i32]* %2 to i8*, !dbg !507
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %93), !dbg !507
  %94 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %74, i64 0, i32 5, !dbg !508
  %95 = bitcast %struct.in6_addr* %94 to i8*, !dbg !508
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %93, i8* nonnull align 4 dereferenceable(16) %95, i64 16, i1 false) #4, !dbg !508, !tbaa.struct !509
  %96 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %74, i64 0, i32 6, !dbg !511
  %97 = bitcast %struct.in6_addr* %96 to i8*, !dbg !511
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %95, i8* nonnull align 4 dereferenceable(16) %97, i64 16, i1 false) #4, !dbg !511, !tbaa.struct !509
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %97, i8* nonnull align 4 dereferenceable(16) %93, i64 16, i1 false) #4, !dbg !512, !tbaa.struct !509
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %93), !dbg !513
  call void @llvm.dbg.value(metadata i16 129, metadata !300, metadata !DIExpression()), !dbg !332
  br label %98

98:                                               ; preds = %92, %83
  %99 = phi i8 [ 0, %83 ], [ -127, %92 ]
  call void @llvm.dbg.value(metadata i16 undef, metadata !300, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata %struct.ethhdr* %18, metadata !255, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata %struct.ethhdr* %18, metadata !329, metadata !DIExpression()) #4, !dbg !514
  %100 = getelementptr inbounds [6 x i8], [6 x i8]* %3, i64 0, i64 0, !dbg !515
  call void @llvm.lifetime.start.p0i8(i64 6, i8* nonnull %100), !dbg !515
  %101 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %18, i64 0, i32 1, i64 0, !dbg !516
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %100, i8* nonnull align 1 dereferenceable(6) %101, i64 6, i1 false) #4, !dbg !516
  %102 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %18, i64 0, i32 0, i64 0, !dbg !517
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %101, i8* nonnull align 1 dereferenceable(6) %102, i64 6, i1 false) #4, !dbg !517
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %102, i8* nonnull align 1 dereferenceable(6) %100, i64 6, i1 false) #4, !dbg !518
  call void @llvm.lifetime.end.p0i8(i64 6, i8* nonnull %100), !dbg !519
  call void @llvm.dbg.value(metadata i8* %72, metadata !302, metadata !DIExpression()), !dbg !332
  %103 = getelementptr inbounds i8, i8* %72, i64 2, !dbg !520
  %104 = bitcast i8* %103 to i16*, !dbg !520
  %105 = load i16, i16* %104, align 2, !dbg !520, !tbaa !521
  call void @llvm.dbg.value(metadata i16 %105, metadata !301, metadata !DIExpression()), !dbg !332
  store i16 0, i16* %104, align 2, !dbg !522, !tbaa !521
  %106 = bitcast i8* %72 to i32*, !dbg !523
  call void @llvm.dbg.value(metadata %struct.icmphdr_common* undef, metadata !302, metadata !DIExpression()), !dbg !332
  %107 = load i32, i32* %106, align 2, !dbg !524
  call void @llvm.dbg.value(metadata i32 %107, metadata !309, metadata !DIExpression()), !dbg !332
  store i32 %107, i32* %5, align 4, !dbg !524
  call void @llvm.dbg.value(metadata i32* %106, metadata !302, metadata !DIExpression()), !dbg !332
  store i8 %99, i8* %72, align 2, !dbg !525, !tbaa !483
  %108 = xor i16 %105, -1, !dbg !526
  call void @llvm.dbg.value(metadata i32* %106, metadata !302, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.value(metadata i16 %108, metadata !527, metadata !DIExpression()) #4, !dbg !536
  call void @llvm.dbg.value(metadata i32* %106, metadata !532, metadata !DIExpression()) #4, !dbg !536
  call void @llvm.dbg.value(metadata i32* %5, metadata !533, metadata !DIExpression()) #4, !dbg !536
  call void @llvm.dbg.value(metadata i32 4, metadata !535, metadata !DIExpression()) #4, !dbg !536
  %109 = zext i16 %108 to i32, !dbg !538
  call void @llvm.dbg.value(metadata i32* %5, metadata !309, metadata !DIExpression(DW_OP_deref)), !dbg !332
  %110 = call i64 inttoptr (i64 28 to i64 (i32*, i32, i32*, i32, i32)*)(i32* nonnull %5, i32 4, i32* nonnull %106, i32 4, i32 %109) #4, !dbg !539
  %111 = trunc i64 %110 to i32, !dbg !539
  call void @llvm.dbg.value(metadata i32 %111, metadata !534, metadata !DIExpression()) #4, !dbg !536
  call void @llvm.dbg.value(metadata i32 %111, metadata !540, metadata !DIExpression()) #4, !dbg !546
  %112 = lshr i32 %111, 16, !dbg !548
  %113 = and i32 %111, 65535, !dbg !549
  %114 = add nuw nsw i32 %112, %113, !dbg !550
  call void @llvm.dbg.value(metadata i32 %114, metadata !545, metadata !DIExpression()) #4, !dbg !546
  %115 = lshr i32 %114, 16, !dbg !551
  %116 = add nuw nsw i32 %115, %114, !dbg !552
  call void @llvm.dbg.value(metadata i32 %116, metadata !545, metadata !DIExpression()) #4, !dbg !546
  %117 = trunc i32 %116 to i16, !dbg !553
  %118 = xor i16 %117, -1, !dbg !553
  call void @llvm.dbg.value(metadata i32* %106, metadata !302, metadata !DIExpression()), !dbg !332
  store i16 %118, i16* %104, align 2, !dbg !554, !tbaa !521
  call void @llvm.dbg.value(metadata i32 3, metadata !310, metadata !DIExpression()), !dbg !332
  br label %119, !dbg !555

119:                                              ; preds = %39, %69, %59, %50, %45, %42, %1, %54, %64, %88, %98
  %120 = phi i32 [ 2, %54 ], [ 3, %98 ], [ 2, %88 ], [ 2, %64 ], [ 2, %1 ], [ 2, %42 ], [ 2, %45 ], [ 2, %50 ], [ 2, %59 ], [ 2, %69 ], [ 2, %39 ], !dbg !332
  call void @llvm.dbg.value(metadata i32 %120, metadata !310, metadata !DIExpression()), !dbg !332
  call void @llvm.dbg.label(metadata !311), !dbg !556
  %121 = bitcast i32* %4 to i8*, !dbg !557
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %121), !dbg !557
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !562, metadata !DIExpression()) #4, !dbg !557
  call void @llvm.dbg.value(metadata i32 %120, metadata !563, metadata !DIExpression()) #4, !dbg !557
  store i32 %120, i32* %4, align 4, !tbaa !572
  call void @llvm.dbg.value(metadata i32* %4, metadata !563, metadata !DIExpression(DW_OP_deref)) #4, !dbg !557
  %122 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %121) #4, !dbg !573
  call void @llvm.dbg.value(metadata i8* %122, metadata !564, metadata !DIExpression()) #4, !dbg !557
  %123 = icmp eq i8* %122, null, !dbg !574
  br i1 %123, label %137, label %124, !dbg !576

124:                                              ; preds = %119
  call void @llvm.dbg.value(metadata i8* %122, metadata !564, metadata !DIExpression()) #4, !dbg !557
  %125 = bitcast i8* %122 to i64*, !dbg !577
  %126 = load i64, i64* %125, align 8, !dbg !578, !tbaa !579
  %127 = add i64 %126, 1, !dbg !578
  store i64 %127, i64* %125, align 8, !dbg !578, !tbaa !579
  %128 = load i32, i32* %6, align 4, !dbg !582, !tbaa !334
  %129 = load i32, i32* %10, align 4, !dbg !583, !tbaa !342
  %130 = sub i32 %128, %129, !dbg !584
  %131 = zext i32 %130 to i64, !dbg !585
  %132 = getelementptr inbounds i8, i8* %122, i64 8, !dbg !586
  %133 = bitcast i8* %132 to i64*, !dbg !586
  %134 = load i64, i64* %133, align 8, !dbg !587, !tbaa !588
  %135 = add i64 %134, %131, !dbg !587
  store i64 %135, i64* %133, align 8, !dbg !587, !tbaa !588
  %136 = load i32, i32* %4, align 4, !dbg !589, !tbaa !572
  call void @llvm.dbg.value(metadata i32 %136, metadata !563, metadata !DIExpression()) #4, !dbg !557
  br label %137, !dbg !590

137:                                              ; preds = %119, %124
  %138 = phi i32 [ %136, %124 ], [ 0, %119 ], !dbg !557
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %121), !dbg !591
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %14) #4, !dbg !592
  ret i32 %138, !dbg !593
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind
define dso_local i32 @xdp_redirect_func(%struct.xdp_md* nocapture readonly %0) #0 section "xdp_redirect" !dbg !594 {
  %2 = alloca i32, align 4
  %3 = alloca [6 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !596, metadata !DIExpression()), !dbg !606
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !607
  %5 = load i32, i32* %4, align 4, !dbg !607, !tbaa !334
  %6 = zext i32 %5 to i64, !dbg !608
  %7 = inttoptr i64 %6 to i8*, !dbg !609
  call void @llvm.dbg.value(metadata i8* %7, metadata !597, metadata !DIExpression()), !dbg !606
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !610
  %9 = load i32, i32* %8, align 4, !dbg !610, !tbaa !342
  %10 = zext i32 %9 to i64, !dbg !611
  %11 = inttoptr i64 %10 to i8*, !dbg !612
  call void @llvm.dbg.value(metadata i8* %11, metadata !598, metadata !DIExpression()), !dbg !606
  call void @llvm.dbg.value(metadata i32 2, metadata !602, metadata !DIExpression()), !dbg !606
  %12 = getelementptr inbounds [6 x i8], [6 x i8]* %3, i64 0, i64 0, !dbg !613
  call void @llvm.lifetime.start.p0i8(i64 6, i8* nonnull %12), !dbg !613
  call void @llvm.dbg.declare(metadata [6 x i8]* %3, metadata !603, metadata !DIExpression()), !dbg !614
  call void @llvm.memset.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %12, i8 0, i64 6, i1 false), !dbg !614
  call void @llvm.dbg.value(metadata i32 0, metadata !604, metadata !DIExpression()), !dbg !606
  call void @llvm.dbg.value(metadata i8* %11, metadata !599, metadata !DIExpression()), !dbg !606
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !346, metadata !DIExpression()), !dbg !615
  call void @llvm.dbg.value(metadata i8* %7, metadata !353, metadata !DIExpression()), !dbg !615
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !357, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata i8* %7, metadata !369, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !371, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata i8* %11, metadata !372, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata i32 14, metadata !373, metadata !DIExpression()), !dbg !617
  %13 = getelementptr i8, i8* %11, i64 14, !dbg !619
  %14 = icmp ugt i8* %13, %7, !dbg !620
  br i1 %14, label %22, label %15, !dbg !621

15:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %11, metadata !372, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata i8* %13, metadata !599, metadata !DIExpression()), !dbg !606
  %16 = inttoptr i64 %10 to %struct.ethhdr*, !dbg !622
  call void @llvm.dbg.value(metadata i8* %13, metadata !374, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata i16 undef, metadata !380, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata i32 0, metadata !381, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata i16 undef, metadata !380, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !374, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !599, metadata !DIExpression()), !dbg !606
  call void @llvm.dbg.value(metadata i16 undef, metadata !601, metadata !DIExpression()), !dbg !606
  call void @llvm.dbg.value(metadata %struct.ethhdr* %16, metadata !600, metadata !DIExpression()), !dbg !606
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 0, i64 0, !dbg !623
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %17, i8* nonnull align 1 dereferenceable(6) %12, i64 6, i1 false), !dbg !623
  %18 = tail call i64 inttoptr (i64 23 to i64 (i32, i64)*)(i32 0, i64 0) #4, !dbg !624
  %19 = trunc i64 %18 to i32, !dbg !624
  call void @llvm.dbg.value(metadata i32 %19, metadata !602, metadata !DIExpression()), !dbg !606
  call void @llvm.dbg.label(metadata !605), !dbg !625
  %20 = bitcast i32* %2 to i8*, !dbg !626
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %20), !dbg !626
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !562, metadata !DIExpression()) #4, !dbg !626
  call void @llvm.dbg.value(metadata i32 %19, metadata !563, metadata !DIExpression()) #4, !dbg !626
  store i32 %19, i32* %2, align 4, !tbaa !572
  %21 = icmp ugt i32 %19, 4, !dbg !628
  br i1 %21, label %41, label %24, !dbg !630

22:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i32 %19, metadata !602, metadata !DIExpression()), !dbg !606
  call void @llvm.dbg.label(metadata !605), !dbg !625
  %23 = bitcast i32* %2 to i8*, !dbg !626
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %23), !dbg !626
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !562, metadata !DIExpression()) #4, !dbg !626
  call void @llvm.dbg.value(metadata i32 %19, metadata !563, metadata !DIExpression()) #4, !dbg !626
  store i32 2, i32* %2, align 4, !tbaa !572
  br label %24, !dbg !630

24:                                               ; preds = %22, %15
  %25 = phi i8* [ %23, %22 ], [ %20, %15 ]
  call void @llvm.dbg.value(metadata i32* %2, metadata !563, metadata !DIExpression(DW_OP_deref)) #4, !dbg !626
  %26 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %25) #4, !dbg !631
  call void @llvm.dbg.value(metadata i8* %26, metadata !564, metadata !DIExpression()) #4, !dbg !626
  %27 = icmp eq i8* %26, null, !dbg !632
  br i1 %27, label %41, label %28, !dbg !633

28:                                               ; preds = %24
  call void @llvm.dbg.value(metadata i8* %26, metadata !564, metadata !DIExpression()) #4, !dbg !626
  %29 = bitcast i8* %26 to i64*, !dbg !634
  %30 = load i64, i64* %29, align 8, !dbg !635, !tbaa !579
  %31 = add i64 %30, 1, !dbg !635
  store i64 %31, i64* %29, align 8, !dbg !635, !tbaa !579
  %32 = load i32, i32* %4, align 4, !dbg !636, !tbaa !334
  %33 = load i32, i32* %8, align 4, !dbg !637, !tbaa !342
  %34 = sub i32 %32, %33, !dbg !638
  %35 = zext i32 %34 to i64, !dbg !639
  %36 = getelementptr inbounds i8, i8* %26, i64 8, !dbg !640
  %37 = bitcast i8* %36 to i64*, !dbg !640
  %38 = load i64, i64* %37, align 8, !dbg !641, !tbaa !588
  %39 = add i64 %38, %35, !dbg !641
  store i64 %39, i64* %37, align 8, !dbg !641, !tbaa !588
  %40 = load i32, i32* %2, align 4, !dbg !642, !tbaa !572
  call void @llvm.dbg.value(metadata i32 %40, metadata !563, metadata !DIExpression()) #4, !dbg !626
  br label %41, !dbg !643

41:                                               ; preds = %15, %24, %28
  %42 = phi i8* [ %20, %15 ], [ %25, %28 ], [ %25, %24 ]
  %43 = phi i32 [ 0, %15 ], [ %40, %28 ], [ 0, %24 ], !dbg !626
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %42), !dbg !644
  call void @llvm.lifetime.end.p0i8(i64 6, i8* nonnull %12), !dbg !645
  ret i32 %43, !dbg !646
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: nounwind
define dso_local i32 @xdp_redirect_map_func(%struct.xdp_md* nocapture readonly %0) #0 section "xdp_redirect_map" !dbg !647 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !649, metadata !DIExpression()), !dbg !659
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !660
  %4 = load i32, i32* %3, align 4, !dbg !660, !tbaa !334
  %5 = zext i32 %4 to i64, !dbg !661
  %6 = inttoptr i64 %5 to i8*, !dbg !662
  call void @llvm.dbg.value(metadata i8* %6, metadata !650, metadata !DIExpression()), !dbg !659
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !663
  %8 = load i32, i32* %7, align 4, !dbg !663, !tbaa !342
  %9 = zext i32 %8 to i64, !dbg !664
  %10 = inttoptr i64 %9 to i8*, !dbg !665
  call void @llvm.dbg.value(metadata i8* %10, metadata !651, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.value(metadata i32 2, metadata !655, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.value(metadata i8* %10, metadata !652, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !346, metadata !DIExpression()), !dbg !666
  call void @llvm.dbg.value(metadata i8* %6, metadata !353, metadata !DIExpression()), !dbg !666
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !357, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata i8* %6, metadata !369, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !371, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata i8* %10, metadata !372, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata i32 14, metadata !373, metadata !DIExpression()), !dbg !668
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !670
  %12 = icmp ugt i8* %11, %6, !dbg !671
  br i1 %12, label %18, label %13, !dbg !672

13:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !372, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata i8* %11, metadata !652, metadata !DIExpression()), !dbg !659
  %14 = inttoptr i64 %9 to %struct.ethhdr*, !dbg !673
  call void @llvm.dbg.value(metadata i8* %11, metadata !374, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata i16 undef, metadata !380, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata i32 0, metadata !381, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata i16 undef, metadata !380, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !374, metadata !DIExpression()), !dbg !668
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !652, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.value(metadata i16 undef, metadata !654, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !653, metadata !DIExpression()), !dbg !659
  %15 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 1, i64 0, !dbg !674
  %16 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_params to i8*), i8* nonnull %15) #4, !dbg !675
  call void @llvm.dbg.value(metadata i8* %16, metadata !656, metadata !DIExpression()), !dbg !659
  %17 = icmp eq i8* %16, null, !dbg !676
  br i1 %17, label %18, label %20, !dbg !678

18:                                               ; preds = %13, %1
  call void @llvm.dbg.value(metadata i32 %23, metadata !655, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.label(metadata !658), !dbg !679
  %19 = bitcast i32* %2 to i8*, !dbg !680
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %19), !dbg !680
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !562, metadata !DIExpression()) #4, !dbg !680
  call void @llvm.dbg.value(metadata i32 %23, metadata !563, metadata !DIExpression()) #4, !dbg !680
  store i32 2, i32* %2, align 4, !tbaa !572
  br label %26, !dbg !682

20:                                               ; preds = %13
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !653, metadata !DIExpression()), !dbg !659
  %21 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 0, !dbg !683
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %21, i8* nonnull align 1 dereferenceable(6) %16, i64 6, i1 false), !dbg !683
  %22 = tail call i64 inttoptr (i64 51 to i64 (i8*, i32, i64)*)(i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i32 0, i64 0) #4, !dbg !684
  %23 = trunc i64 %22 to i32, !dbg !684
  call void @llvm.dbg.value(metadata i32 %23, metadata !655, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.value(metadata i32 %23, metadata !655, metadata !DIExpression()), !dbg !659
  call void @llvm.dbg.label(metadata !658), !dbg !679
  %24 = bitcast i32* %2 to i8*, !dbg !680
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %24), !dbg !680
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !562, metadata !DIExpression()) #4, !dbg !680
  call void @llvm.dbg.value(metadata i32 %23, metadata !563, metadata !DIExpression()) #4, !dbg !680
  store i32 %23, i32* %2, align 4, !tbaa !572
  %25 = icmp ugt i32 %23, 4, !dbg !685
  br i1 %25, label %43, label %26, !dbg !682

26:                                               ; preds = %18, %20
  %27 = phi i8* [ %19, %18 ], [ %24, %20 ]
  call void @llvm.dbg.value(metadata i32* %2, metadata !563, metadata !DIExpression(DW_OP_deref)) #4, !dbg !680
  %28 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %27) #4, !dbg !686
  call void @llvm.dbg.value(metadata i8* %28, metadata !564, metadata !DIExpression()) #4, !dbg !680
  %29 = icmp eq i8* %28, null, !dbg !687
  br i1 %29, label %43, label %30, !dbg !688

30:                                               ; preds = %26
  call void @llvm.dbg.value(metadata i8* %28, metadata !564, metadata !DIExpression()) #4, !dbg !680
  %31 = bitcast i8* %28 to i64*, !dbg !689
  %32 = load i64, i64* %31, align 8, !dbg !690, !tbaa !579
  %33 = add i64 %32, 1, !dbg !690
  store i64 %33, i64* %31, align 8, !dbg !690, !tbaa !579
  %34 = load i32, i32* %3, align 4, !dbg !691, !tbaa !334
  %35 = load i32, i32* %7, align 4, !dbg !692, !tbaa !342
  %36 = sub i32 %34, %35, !dbg !693
  %37 = zext i32 %36 to i64, !dbg !694
  %38 = getelementptr inbounds i8, i8* %28, i64 8, !dbg !695
  %39 = bitcast i8* %38 to i64*, !dbg !695
  %40 = load i64, i64* %39, align 8, !dbg !696, !tbaa !588
  %41 = add i64 %40, %37, !dbg !696
  store i64 %41, i64* %39, align 8, !dbg !696, !tbaa !588
  %42 = load i32, i32* %2, align 4, !dbg !697, !tbaa !572
  call void @llvm.dbg.value(metadata i32 %42, metadata !563, metadata !DIExpression()) #4, !dbg !680
  br label %43, !dbg !698

43:                                               ; preds = %20, %26, %30
  %44 = phi i8* [ %24, %20 ], [ %27, %30 ], [ %27, %26 ]
  %45 = phi i32 [ 0, %20 ], [ %42, %30 ], [ 0, %26 ], !dbg !680
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %44), !dbg !699
  ret i32 %45, !dbg !700
}

; Function Attrs: nounwind
define dso_local i32 @xdp_router_func(%struct.xdp_md* %0) #0 section "xdp_router" !dbg !701 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.bpf_fib_lookup, align 4
  %4 = alloca [16 x i8], align 1
  %5 = alloca [14 x i8], align 1
  %6 = alloca [16 x i8], align 1
  %7 = alloca [15 x i8], align 1
  %8 = alloca [33 x i8], align 1
  %9 = alloca [33 x i8], align 1
  %10 = alloca [11 x i8], align 1
  %11 = alloca i16, align 2
  %12 = alloca i64, align 8
  %13 = alloca [20 x i8], align 1
  %14 = alloca [12 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !703, metadata !DIExpression()), !dbg !774
  %15 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !775
  %16 = load i32, i32* %15, align 4, !dbg !775, !tbaa !334
  %17 = zext i32 %16 to i64, !dbg !776
  %18 = inttoptr i64 %17 to i8*, !dbg !777
  call void @llvm.dbg.value(metadata i8* %18, metadata !704, metadata !DIExpression()), !dbg !774
  %19 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !778
  %20 = load i32, i32* %19, align 4, !dbg !778, !tbaa !342
  %21 = zext i32 %20 to i64, !dbg !779
  %22 = inttoptr i64 %21 to i8*, !dbg !780
  call void @llvm.dbg.value(metadata i8* %22, metadata !705, metadata !DIExpression()), !dbg !774
  %23 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 0, !dbg !781
  call void @llvm.lifetime.start.p0i8(i64 64, i8* nonnull %23) #4, !dbg !781
  call void @llvm.dbg.declare(metadata %struct.bpf_fib_lookup* %3, metadata !706, metadata !DIExpression()), !dbg !782
  call void @llvm.memset.p0i8.i64(i8* nonnull align 4 dereferenceable(64) %23, i8 0, i64 64, i1 false), !dbg !782
  %24 = inttoptr i64 %21 to %struct.ethhdr*, !dbg !783
  call void @llvm.dbg.value(metadata %struct.ethhdr* %24, metadata !707, metadata !DIExpression()), !dbg !774
  call void @llvm.dbg.value(metadata i32 2, metadata !724, metadata !DIExpression()), !dbg !774
  call void @llvm.dbg.value(metadata i64 14, metadata !722, metadata !DIExpression()), !dbg !774
  %25 = getelementptr i8, i8* %22, i64 14, !dbg !784
  %26 = icmp ugt i8* %25, %18, !dbg !786
  br i1 %26, label %182, label %27, !dbg !787

27:                                               ; preds = %1
  %28 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %24, i64 0, i32 2, !dbg !788
  %29 = load i16, i16* %28, align 1, !dbg !788, !tbaa !789
  call void @llvm.dbg.value(metadata i16 %29, metadata !721, metadata !DIExpression()), !dbg !774
  %30 = icmp eq i16 %29, 8, !dbg !791
  br i1 %30, label %31, label %64, !dbg !792

31:                                               ; preds = %27
  %32 = bitcast i8* %25 to %struct.iphdr*, !dbg !793
  call void @llvm.dbg.value(metadata %struct.iphdr* %32, metadata !709, metadata !DIExpression()), !dbg !774
  %33 = getelementptr i8, i8* %22, i64 34, !dbg !795
  %34 = bitcast i8* %33 to %struct.iphdr*, !dbg !795
  %35 = inttoptr i64 %17 to %struct.iphdr*, !dbg !797
  %36 = icmp ugt %struct.iphdr* %34, %35, !dbg !798
  br i1 %36, label %182, label %37, !dbg !799

37:                                               ; preds = %31
  %38 = getelementptr i8, i8* %22, i64 22, !dbg !800
  %39 = load i8, i8* %38, align 4, !dbg !800, !tbaa !802
  %40 = icmp ult i8 %39, 2, !dbg !803
  br i1 %40, label %182, label %41, !dbg !804

41:                                               ; preds = %37
  store i8 2, i8* %23, align 4, !dbg !805, !tbaa !806
  %42 = getelementptr i8, i8* %22, i64 15, !dbg !808
  %43 = load i8, i8* %42, align 1, !dbg !808, !tbaa !809
  %44 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 6, !dbg !810
  %45 = bitcast %union.anon.0* %44 to i8*, !dbg !810
  store i8 %43, i8* %45, align 4, !dbg !811, !tbaa !510
  %46 = getelementptr i8, i8* %22, i64 23, !dbg !812
  %47 = load i8, i8* %46, align 1, !dbg !812, !tbaa !434
  %48 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 1, !dbg !813
  store i8 %47, i8* %48, align 1, !dbg !814, !tbaa !815
  %49 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 2, !dbg !816
  store i16 0, i16* %49, align 2, !dbg !817, !tbaa !818
  %50 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 3, !dbg !819
  store i16 0, i16* %50, align 4, !dbg !820, !tbaa !821
  %51 = getelementptr i8, i8* %22, i64 16, !dbg !822
  %52 = bitcast i8* %51 to i16*, !dbg !822
  %53 = load i16, i16* %52, align 2, !dbg !822, !tbaa !823
  %54 = tail call i16 @llvm.bswap.i16(i16 %53)
  %55 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 4, !dbg !824
  store i16 %54, i16* %55, align 2, !dbg !825, !tbaa !826
  %56 = getelementptr i8, i8* %22, i64 26, !dbg !827
  %57 = bitcast i8* %56 to i32*, !dbg !827
  %58 = load i32, i32* %57, align 4, !dbg !827, !tbaa !497
  %59 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 7, i32 0, i64 0, !dbg !828
  store i32 %58, i32* %59, align 4, !dbg !829, !tbaa !510
  %60 = getelementptr i8, i8* %22, i64 30, !dbg !830
  %61 = bitcast i8* %60 to i32*, !dbg !830
  %62 = load i32, i32* %61, align 4, !dbg !830, !tbaa !499
  %63 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 8, i32 0, i64 0, !dbg !831
  store i32 %62, i32* %63, align 4, !dbg !832, !tbaa !510
  br label %143, !dbg !833

64:                                               ; preds = %27
  switch i16 %29, label %182 [
    i16 -8826, label %65
    i16 -18808, label %96
  ], !dbg !834

65:                                               ; preds = %64
  %66 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 7, i32 0, i64 0, !dbg !835
  call void @llvm.dbg.value(metadata i32* %66, metadata !725, metadata !DIExpression()), !dbg !836
  %67 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 8, i32 0, i64 0, !dbg !837
  call void @llvm.dbg.value(metadata i32* %67, metadata !729, metadata !DIExpression()), !dbg !836
  %68 = bitcast i8* %25 to %struct.ipv6hdr*, !dbg !838
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %68, metadata !708, metadata !DIExpression()), !dbg !774
  %69 = getelementptr i8, i8* %22, i64 54, !dbg !839
  %70 = bitcast i8* %69 to %struct.ipv6hdr*, !dbg !839
  %71 = inttoptr i64 %17 to %struct.ipv6hdr*, !dbg !841
  %72 = icmp ugt %struct.ipv6hdr* %70, %71, !dbg !842
  br i1 %72, label %182, label %73, !dbg !843

73:                                               ; preds = %65
  %74 = getelementptr i8, i8* %22, i64 21, !dbg !844
  %75 = load i8, i8* %74, align 1, !dbg !844, !tbaa !846
  %76 = icmp ult i8 %75, 2, !dbg !847
  br i1 %76, label %182, label %77, !dbg !848

77:                                               ; preds = %73
  store i8 10, i8* %23, align 4, !dbg !849, !tbaa !806
  %78 = bitcast i8* %25 to i32*, !dbg !850
  %79 = load i32, i32* %78, align 4, !dbg !850, !tbaa !572
  %80 = and i32 %79, -241, !dbg !851
  %81 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 6, i32 0, !dbg !852
  store i32 %80, i32* %81, align 4, !dbg !853, !tbaa !510
  %82 = getelementptr i8, i8* %22, i64 20, !dbg !854
  %83 = load i8, i8* %82, align 2, !dbg !854, !tbaa !459
  %84 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 1, !dbg !855
  store i8 %83, i8* %84, align 1, !dbg !856, !tbaa !815
  %85 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 2, !dbg !857
  store i16 0, i16* %85, align 2, !dbg !858, !tbaa !818
  %86 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 3, !dbg !859
  store i16 0, i16* %86, align 4, !dbg !860, !tbaa !821
  %87 = getelementptr i8, i8* %22, i64 18, !dbg !861
  %88 = bitcast i8* %87 to i16*, !dbg !861
  %89 = load i16, i16* %88, align 4, !dbg !861, !tbaa !862
  %90 = tail call i16 @llvm.bswap.i16(i16 %89)
  %91 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 4, !dbg !863
  store i16 %90, i16* %91, align 2, !dbg !864, !tbaa !826
  %92 = getelementptr i8, i8* %22, i64 22, !dbg !865
  %93 = bitcast i32* %66 to i8*, !dbg !865
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %93, i8* nonnull align 4 dereferenceable(16) %92, i64 16, i1 false), !dbg !865, !tbaa.struct !509
  %94 = getelementptr i8, i8* %22, i64 38, !dbg !866
  %95 = bitcast i32* %67 to i8*, !dbg !866
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %95, i8* nonnull align 4 dereferenceable(16) %94, i64 16, i1 false), !dbg !866, !tbaa.struct !509
  call void @llvm.dbg.value(metadata i32 2, metadata !724, metadata !DIExpression()), !dbg !774
  br label %143

96:                                               ; preds = %64
  call void @llvm.dbg.value(metadata i8* %25, metadata !710, metadata !DIExpression()), !dbg !774
  %97 = getelementptr i8, i8* %22, i64 26, !dbg !867
  %98 = bitcast i8* %97 to %struct.newiphdr*, !dbg !867
  %99 = inttoptr i64 %17 to %struct.newiphdr*, !dbg !869
  %100 = icmp ugt %struct.newiphdr* %98, %99, !dbg !870
  br i1 %100, label %182, label %101, !dbg !871

101:                                              ; preds = %96
  %102 = getelementptr inbounds [16 x i8], [16 x i8]* %4, i64 0, i64 0, !dbg !872
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %102) #4, !dbg !872
  call void @llvm.dbg.declare(metadata [16 x i8]* %4, metadata !730, metadata !DIExpression()), !dbg !872
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(16) %102, i8* nonnull align 1 dereferenceable(16) getelementptr inbounds ([16 x i8], [16 x i8]* @__const.xdp_router_func.____fmt, i64 0, i64 0), i64 16, i1 false), !dbg !872
  %103 = sub nsw i64 %17, %21, !dbg !872
  %104 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %102, i32 16, i64 %103) #4, !dbg !872
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %102) #4, !dbg !873
  %105 = getelementptr inbounds [14 x i8], [14 x i8]* %5, i64 0, i64 0, !dbg !874
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %105) #4, !dbg !874
  call void @llvm.dbg.declare(metadata [14 x i8]* %5, metadata !735, metadata !DIExpression()), !dbg !874
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(14) %105, i8* nonnull align 1 dereferenceable(14) getelementptr inbounds ([14 x i8], [14 x i8]* @__const.xdp_router_func.____fmt.1, i64 0, i64 0), i64 14, i1 false), !dbg !874
  %106 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %105, i32 14, i64 14) #4, !dbg !874
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %105) #4, !dbg !875
  %107 = getelementptr inbounds [16 x i8], [16 x i8]* %6, i64 0, i64 0, !dbg !876
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %107) #4, !dbg !876
  call void @llvm.dbg.declare(metadata [16 x i8]* %6, metadata !740, metadata !DIExpression()), !dbg !876
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(16) %107, i8* nonnull align 1 dereferenceable(16) getelementptr inbounds ([16 x i8], [16 x i8]* @__const.xdp_router_func.____fmt.2, i64 0, i64 0), i64 16, i1 false), !dbg !876
  %108 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %107, i32 16, i64 12) #4, !dbg !876
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %107) #4, !dbg !877
  %109 = getelementptr inbounds [15 x i8], [15 x i8]* %7, i64 0, i64 0, !dbg !878
  call void @llvm.lifetime.start.p0i8(i64 15, i8* nonnull %109) #4, !dbg !878
  call void @llvm.dbg.declare(metadata [15 x i8]* %7, metadata !742, metadata !DIExpression()), !dbg !878
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(15) %109, i8* nonnull align 1 dereferenceable(15) getelementptr inbounds ([15 x i8], [15 x i8]* @__const.xdp_router_func.____fmt.3, i64 0, i64 0), i64 15, i1 false), !dbg !878
  %110 = getelementptr i8, i8* %22, i64 16, !dbg !878
  %111 = load i8, i8* %110, align 2, !dbg !878, !tbaa !879
  %112 = zext i8 %111 to i32, !dbg !878
  %113 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %109, i32 15, i32 %112) #4, !dbg !878
  call void @llvm.lifetime.end.p0i8(i64 15, i8* nonnull %109) #4, !dbg !881
  %114 = getelementptr inbounds [33 x i8], [33 x i8]* %8, i64 0, i64 0, !dbg !882
  call void @llvm.lifetime.start.p0i8(i64 33, i8* nonnull %114) #4, !dbg !882
  call void @llvm.dbg.declare(metadata [33 x i8]* %8, metadata !747, metadata !DIExpression()), !dbg !882
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(33) %114, i8* nonnull align 1 dereferenceable(33) getelementptr inbounds ([33 x i8], [33 x i8]* @__const.xdp_router_func.____fmt.4, i64 0, i64 0), i64 33, i1 false), !dbg !882
  %115 = load i8, i8* %25, align 4, !dbg !882, !tbaa !883
  %116 = zext i8 %115 to i32, !dbg !882
  %117 = getelementptr i8, i8* %22, i64 18, !dbg !882
  %118 = bitcast i8* %117 to i32*, !dbg !882
  %119 = load i32, i32* %118, align 4, !dbg !882, !tbaa !884
  %120 = call i32 @llvm.bswap.i32(i32 %119), !dbg !882
  %121 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %114, i32 33, i32 %116, i32 %120) #4, !dbg !882
  call void @llvm.lifetime.end.p0i8(i64 33, i8* nonnull %114) #4, !dbg !885
  %122 = getelementptr inbounds [33 x i8], [33 x i8]* %9, i64 0, i64 0, !dbg !886
  call void @llvm.lifetime.start.p0i8(i64 33, i8* nonnull %122) #4, !dbg !886
  call void @llvm.dbg.declare(metadata [33 x i8]* %9, metadata !752, metadata !DIExpression()), !dbg !886
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(33) %122, i8* nonnull align 1 dereferenceable(33) getelementptr inbounds ([33 x i8], [33 x i8]* @__const.xdp_router_func.____fmt.5, i64 0, i64 0), i64 33, i1 false), !dbg !886
  %123 = getelementptr i8, i8* %22, i64 15, !dbg !886
  %124 = load i8, i8* %123, align 1, !dbg !886, !tbaa !887
  %125 = zext i8 %124 to i32, !dbg !886
  %126 = getelementptr i8, i8* %22, i64 22, !dbg !886
  %127 = bitcast i8* %126 to i32*, !dbg !886
  %128 = load i32, i32* %127, align 4, !dbg !886, !tbaa !888
  %129 = call i32 @llvm.bswap.i32(i32 %128), !dbg !886
  %130 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %122, i32 33, i32 %125, i32 %129) #4, !dbg !886
  call void @llvm.lifetime.end.p0i8(i64 33, i8* nonnull %122) #4, !dbg !889
  %131 = getelementptr inbounds [11 x i8], [11 x i8]* %10, i64 0, i64 0, !dbg !890
  call void @llvm.lifetime.start.p0i8(i64 11, i8* nonnull %131) #4, !dbg !890
  call void @llvm.dbg.declare(metadata [11 x i8]* %10, metadata !754, metadata !DIExpression()), !dbg !890
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(11) %131, i8* nonnull align 1 dereferenceable(11) getelementptr inbounds ([11 x i8], [11 x i8]* @__const.xdp_router_func.____fmt.6, i64 0, i64 0), i64 11, i1 false), !dbg !890
  %132 = getelementptr i8, i8* %22, i64 17, !dbg !890
  %133 = load i8, i8* %132, align 1, !dbg !890, !tbaa !891
  %134 = zext i8 %133 to i32, !dbg !890
  %135 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %131, i32 11, i32 %134) #4, !dbg !890
  call void @llvm.lifetime.end.p0i8(i64 11, i8* nonnull %131) #4, !dbg !892
  %136 = bitcast i16* %11 to i8*, !dbg !893
  call void @llvm.lifetime.start.p0i8(i64 2, i8* nonnull %136) #4, !dbg !893
  call void @llvm.dbg.value(metadata i16 10, metadata !759, metadata !DIExpression()), !dbg !894
  store i16 10, i16* %11, align 2, !dbg !893
  call void @llvm.dbg.value(metadata i16* %11, metadata !759, metadata !DIExpression(DW_OP_deref)), !dbg !894
  %137 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %136, i32 2) #4, !dbg !893
  call void @llvm.lifetime.end.p0i8(i64 2, i8* nonnull %136) #4, !dbg !895
  store i8 2, i8* %23, align 4, !dbg !896, !tbaa !806
  %138 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 4, !dbg !897
  store i16 12, i16* %138, align 2, !dbg !898, !tbaa !826
  %139 = load i32, i32* %118, align 4, !dbg !899, !tbaa !884
  %140 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 7, i32 0, i64 0, !dbg !900
  store i32 %139, i32* %140, align 4, !dbg !901, !tbaa !510
  %141 = load i32, i32* %127, align 4, !dbg !902, !tbaa !888
  %142 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 8, i32 0, i64 0, !dbg !903
  store i32 %141, i32* %142, align 4, !dbg !904, !tbaa !510
  br label %143

143:                                              ; preds = %77, %101, %41
  %144 = phi %struct.iphdr* [ %32, %41 ], [ undef, %77 ], [ undef, %101 ]
  %145 = phi %struct.ipv6hdr* [ undef, %41 ], [ %68, %77 ], [ undef, %101 ]
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %145, metadata !708, metadata !DIExpression()), !dbg !774
  call void @llvm.dbg.value(metadata %struct.iphdr* %144, metadata !709, metadata !DIExpression()), !dbg !774
  call void @llvm.dbg.value(metadata i32 2, metadata !724, metadata !DIExpression()), !dbg !774
  %146 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 3, !dbg !905
  %147 = load i32, i32* %146, align 4, !dbg !905, !tbaa !906
  %148 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 5, !dbg !907
  store i32 %147, i32* %148, align 4, !dbg !908, !tbaa !909
  %149 = bitcast %struct.xdp_md* %0 to i8*, !dbg !910
  %150 = call i64 inttoptr (i64 69 to i64 (i8*, %struct.bpf_fib_lookup*, i32, i32)*)(i8* %149, %struct.bpf_fib_lookup* nonnull %3, i32 64, i32 0) #4, !dbg !911
  %151 = trunc i64 %150 to i32, !dbg !911
  call void @llvm.dbg.value(metadata i32 %151, metadata !723, metadata !DIExpression()), !dbg !774
  %152 = bitcast i64* %12 to i8*, !dbg !912
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %152) #4, !dbg !912
  call void @llvm.dbg.value(metadata i64 2924860384371570, metadata !762, metadata !DIExpression()), !dbg !913
  store i64 2924860384371570, i64* %12, align 8, !dbg !912
  call void @llvm.dbg.value(metadata i64* %12, metadata !762, metadata !DIExpression(DW_OP_deref)), !dbg !913
  %153 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %152, i32 8, i32 %151) #4, !dbg !912
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %152) #4, !dbg !914
  switch i32 %151, label %182 [
    i32 0, label %154
    i32 1, label %181
    i32 2, label %181
    i32 3, label %181
  ], !dbg !915

154:                                              ; preds = %143
  %155 = getelementptr inbounds [20 x i8], [20 x i8]* %13, i64 0, i64 0, !dbg !916
  call void @llvm.lifetime.start.p0i8(i64 20, i8* nonnull %155) #4, !dbg !916
  call void @llvm.dbg.declare(metadata [20 x i8]* %13, metadata !765, metadata !DIExpression()), !dbg !916
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(20) %155, i8* nonnull align 1 dereferenceable(20) getelementptr inbounds ([20 x i8], [20 x i8]* @__const.xdp_router_func.____fmt.9, i64 0, i64 0), i64 20, i1 false), !dbg !916
  %156 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %155, i32 20) #4, !dbg !916
  call void @llvm.lifetime.end.p0i8(i64 20, i8* nonnull %155) #4, !dbg !917
  br i1 %30, label %157, label %167, !dbg !918

157:                                              ; preds = %154
  call void @llvm.dbg.value(metadata %struct.iphdr* %144, metadata !919, metadata !DIExpression()), !dbg !925
  %158 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %144, i64 0, i32 7, !dbg !928
  %159 = load i16, i16* %158, align 2, !dbg !928, !tbaa !929
  call void @llvm.dbg.value(metadata i16 %159, metadata !924, metadata !DIExpression()), !dbg !925
  %160 = add i16 %159, 1, !dbg !930
  call void @llvm.dbg.value(metadata i16 %159, metadata !924, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !925
  %161 = icmp ugt i16 %159, -3, !dbg !931
  %162 = zext i1 %161 to i16, !dbg !931
  %163 = add i16 %160, %162, !dbg !932
  store i16 %163, i16* %158, align 2, !dbg !933, !tbaa !929
  %164 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %144, i64 0, i32 5, !dbg !934
  %165 = load i8, i8* %164, align 4, !dbg !935, !tbaa !802
  %166 = add i8 %165, -1, !dbg !935
  store i8 %166, i8* %164, align 4, !dbg !935, !tbaa !802
  br label %173, !dbg !936

167:                                              ; preds = %154
  %168 = icmp eq i16 %29, -8826, !dbg !937
  br i1 %168, label %169, label %173, !dbg !939

169:                                              ; preds = %167
  %170 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %145, i64 0, i32 4, !dbg !940
  %171 = load i8, i8* %170, align 1, !dbg !941, !tbaa !846
  %172 = add i8 %171, -1, !dbg !941
  store i8 %172, i8* %170, align 1, !dbg !941, !tbaa !846
  br label %173, !dbg !942

173:                                              ; preds = %167, %169, %157
  %174 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %24, i64 0, i32 0, i64 0, !dbg !943
  %175 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 12, i64 0, !dbg !943
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %174, i8* nonnull align 2 dereferenceable(6) %175, i64 6, i1 false), !dbg !943
  %176 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %24, i64 0, i32 1, i64 0, !dbg !944
  %177 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 11, i64 0, !dbg !944
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(6) %176, i8* nonnull align 4 dereferenceable(6) %177, i64 6, i1 false), !dbg !944
  %178 = load i32, i32* %148, align 4, !dbg !945, !tbaa !909
  %179 = call i64 inttoptr (i64 51 to i64 (i8*, i32, i64)*)(i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i32 %178, i64 0) #4, !dbg !946
  %180 = trunc i64 %179 to i32, !dbg !946
  call void @llvm.dbg.value(metadata i32 %180, metadata !724, metadata !DIExpression()), !dbg !774
  br label %182, !dbg !947

181:                                              ; preds = %143, %143, %143
  call void @llvm.dbg.value(metadata i32 1, metadata !724, metadata !DIExpression()), !dbg !774
  br label %182, !dbg !948

182:                                              ; preds = %73, %65, %96, %64, %31, %1, %173, %181, %143, %37
  %183 = phi i32 [ 2, %37 ], [ 2, %143 ], [ 1, %181 ], [ %180, %173 ], [ 1, %1 ], [ 1, %31 ], [ 2, %64 ], [ 1, %96 ], [ 2, %73 ], [ 1, %65 ], !dbg !774
  call void @llvm.dbg.value(metadata i32 %183, metadata !724, metadata !DIExpression()), !dbg !774
  call void @llvm.dbg.label(metadata !773), !dbg !949
  %184 = getelementptr inbounds [12 x i8], [12 x i8]* %14, i64 0, i64 0, !dbg !950
  call void @llvm.lifetime.start.p0i8(i64 12, i8* nonnull %184) #4, !dbg !950
  call void @llvm.dbg.declare(metadata [12 x i8]* %14, metadata !768, metadata !DIExpression()), !dbg !950
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(12) %184, i8* nonnull align 1 dereferenceable(12) getelementptr inbounds ([12 x i8], [12 x i8]* @__const.xdp_router_func.____fmt.10, i64 0, i64 0), i64 12, i1 false), !dbg !950
  %185 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* nonnull %184, i32 12, i32 %183) #4, !dbg !950
  call void @llvm.lifetime.end.p0i8(i64 12, i8* nonnull %184) #4, !dbg !951
  %186 = bitcast i32* %2 to i8*, !dbg !952
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %186), !dbg !952
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !562, metadata !DIExpression()) #4, !dbg !952
  call void @llvm.dbg.value(metadata i32 %183, metadata !563, metadata !DIExpression()) #4, !dbg !952
  store i32 %183, i32* %2, align 4, !tbaa !572
  %187 = icmp ugt i32 %183, 4, !dbg !954
  br i1 %187, label %204, label %188, !dbg !955

188:                                              ; preds = %182
  call void @llvm.dbg.value(metadata i32* %2, metadata !563, metadata !DIExpression(DW_OP_deref)) #4, !dbg !952
  %189 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %186) #4, !dbg !956
  call void @llvm.dbg.value(metadata i8* %189, metadata !564, metadata !DIExpression()) #4, !dbg !952
  %190 = icmp eq i8* %189, null, !dbg !957
  br i1 %190, label %204, label %191, !dbg !958

191:                                              ; preds = %188
  call void @llvm.dbg.value(metadata i8* %189, metadata !564, metadata !DIExpression()) #4, !dbg !952
  %192 = bitcast i8* %189 to i64*, !dbg !959
  %193 = load i64, i64* %192, align 8, !dbg !960, !tbaa !579
  %194 = add i64 %193, 1, !dbg !960
  store i64 %194, i64* %192, align 8, !dbg !960, !tbaa !579
  %195 = load i32, i32* %15, align 4, !dbg !961, !tbaa !334
  %196 = load i32, i32* %19, align 4, !dbg !962, !tbaa !342
  %197 = sub i32 %195, %196, !dbg !963
  %198 = zext i32 %197 to i64, !dbg !964
  %199 = getelementptr inbounds i8, i8* %189, i64 8, !dbg !965
  %200 = bitcast i8* %199 to i64*, !dbg !965
  %201 = load i64, i64* %200, align 8, !dbg !966, !tbaa !588
  %202 = add i64 %201, %198, !dbg !966
  store i64 %202, i64* %200, align 8, !dbg !966, !tbaa !588
  %203 = load i32, i32* %2, align 4, !dbg !967, !tbaa !572
  call void @llvm.dbg.value(metadata i32 %203, metadata !563, metadata !DIExpression()) #4, !dbg !952
  br label %204, !dbg !968

204:                                              ; preds = %182, %188, %191
  %205 = phi i32 [ 0, %182 ], [ %203, %191 ], [ 0, %188 ], !dbg !952
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %186), !dbg !969
  call void @llvm.lifetime.end.p0i8(i64 64, i8* nonnull %23) #4, !dbg !970
  ret i32 %205, !dbg !970
}

; Function Attrs: nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare i32 @llvm.bswap.i32(i32) #1

; Function Attrs: norecurse nounwind readnone
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture readnone %0) #3 section "xdp_pass" !dbg !971 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !973, metadata !DIExpression()), !dbg !974
  ret i32 2, !dbg !975
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nounwind willreturn }
attributes #3 = { norecurse nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!231, !232, !233}
!llvm.ident = !{!234}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !230, line: 16, type: !78, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !75, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/rohit/cloned/New-IP/xdp/newip_router")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/rohit/cloned/New-IP/xdp/newip_router")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 28, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0, isUnsigned: true)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1, isUnsigned: true)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2, isUnsigned: true)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4, isUnsigned: true)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6, isUnsigned: true)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8, isUnsigned: true)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12, isUnsigned: true)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17, isUnsigned: true)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22, isUnsigned: true)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29, isUnsigned: true)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33, isUnsigned: true)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41, isUnsigned: true)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46, isUnsigned: true)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47, isUnsigned: true)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50, isUnsigned: true)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51, isUnsigned: true)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92, isUnsigned: true)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94, isUnsigned: true)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98, isUnsigned: true)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103, isUnsigned: true)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108, isUnsigned: true)
!38 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132, isUnsigned: true)
!39 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136, isUnsigned: true)
!40 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137, isUnsigned: true)
!41 = !DIEnumerator(name: "IPPROTO_RAW", value: 255, isUnsigned: true)
!42 = !DIEnumerator(name: "IPPROTO_MAX", value: 256, isUnsigned: true)
!43 = !{!44, !45, !46, !49, !74, !71}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!45 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !47, line: 24, baseType: !48)
!47 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!48 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !51, line: 33, size: 128, elements: !52)
!51 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "")
!52 = !{!53}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !50, file: !51, line: 40, baseType: !54, size: 128)
!54 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !50, file: !51, line: 34, size: 128, elements: !55)
!55 = !{!56, !62, !68}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !54, file: !51, line: 35, baseType: !57, size: 128)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 128, elements: !60)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !47, line: 21, baseType: !59)
!59 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!60 = !{!61}
!61 = !DISubrange(count: 16)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !54, file: !51, line: 37, baseType: !63, size: 128)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !64, size: 128, elements: !66)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !65, line: 25, baseType: !46)
!65 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!66 = !{!67}
!67 = !DISubrange(count: 8)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !54, file: !51, line: 38, baseType: !69, size: 128)
!69 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 128, elements: !72)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !65, line: 27, baseType: !71)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!72 = !{!73}
!73 = !DISubrange(count: 4)
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!75 = !{!0, !76, !86, !88, !92, !156, !158, !166, !173, !180, !185, !192}
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(name: "tx_port", scope: !2, file: !3, line: 22, type: !78, isLocal: false, isDefinition: true)
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !79, line: 108, size: 160, elements: !80)
!79 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helpers.h", directory: "/home/rohit/cloned/New-IP/xdp/newip_router")
!80 = !{!81, !82, !83, !84, !85}
!81 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !78, file: !79, line: 109, baseType: !7, size: 32)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !78, file: !79, line: 110, baseType: !7, size: 32, offset: 32)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !78, file: !79, line: 111, baseType: !7, size: 32, offset: 64)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !78, file: !79, line: 112, baseType: !7, size: 32, offset: 96)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !78, file: !79, line: 113, baseType: !7, size: 32, offset: 128)
!86 = !DIGlobalVariableExpression(var: !87, expr: !DIExpression())
!87 = distinct !DIGlobalVariable(name: "redirect_params", scope: !2, file: !3, line: 29, type: !78, isLocal: false, isDefinition: true)
!88 = !DIGlobalVariableExpression(var: !89, expr: !DIExpression())
!89 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 385, type: !90, isLocal: false, isDefinition: true)
!90 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 32, elements: !72)
!91 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(name: "stdin", scope: !2, file: !94, line: 137, type: !95, isLocal: false, isDefinition: false)
!94 = !DIFile(filename: "/usr/include/stdio.h", directory: "")
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !97, line: 7, baseType: !98)
!97 = !DIFile(filename: "/usr/include/bits/types/FILE.h", directory: "")
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !99, line: 49, size: 1728, elements: !100)
!99 = !DIFile(filename: "/usr/include/bits/types/struct_FILE.h", directory: "")
!100 = !{!101, !103, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !118, !120, !121, !122, !125, !126, !128, !132, !135, !139, !142, !145, !146, !147, !151, !152}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !98, file: !99, line: 51, baseType: !102, size: 32)
!102 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !98, file: !99, line: 54, baseType: !104, size: 64, offset: 64)
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !98, file: !99, line: 55, baseType: !104, size: 64, offset: 128)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !98, file: !99, line: 56, baseType: !104, size: 64, offset: 192)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !98, file: !99, line: 57, baseType: !104, size: 64, offset: 256)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !98, file: !99, line: 58, baseType: !104, size: 64, offset: 320)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !98, file: !99, line: 59, baseType: !104, size: 64, offset: 384)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !98, file: !99, line: 60, baseType: !104, size: 64, offset: 448)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !98, file: !99, line: 61, baseType: !104, size: 64, offset: 512)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !98, file: !99, line: 64, baseType: !104, size: 64, offset: 576)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !98, file: !99, line: 65, baseType: !104, size: 64, offset: 640)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !98, file: !99, line: 66, baseType: !104, size: 64, offset: 704)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !98, file: !99, line: 68, baseType: !116, size: 64, offset: 768)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !99, line: 36, flags: DIFlagFwdDecl)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !98, file: !99, line: 70, baseType: !119, size: 64, offset: 832)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !98, size: 64)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !98, file: !99, line: 72, baseType: !102, size: 32, offset: 896)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !98, file: !99, line: 73, baseType: !102, size: 32, offset: 928)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !98, file: !99, line: 74, baseType: !123, size: 64, offset: 960)
!123 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !124, line: 152, baseType: !45)
!124 = !DIFile(filename: "/usr/include/bits/types.h", directory: "")
!125 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !98, file: !99, line: 77, baseType: !48, size: 16, offset: 1024)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !98, file: !99, line: 78, baseType: !127, size: 8, offset: 1040)
!127 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !98, file: !99, line: 79, baseType: !129, size: 8, offset: 1048)
!129 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 8, elements: !130)
!130 = !{!131}
!131 = !DISubrange(count: 1)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !98, file: !99, line: 81, baseType: !133, size: 64, offset: 1088)
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !134, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !99, line: 43, baseType: null)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !98, file: !99, line: 89, baseType: !136, size: 64, offset: 1152)
!136 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !124, line: 153, baseType: !137)
!137 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !124, line: 47, baseType: !138)
!138 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "_codecvt", scope: !98, file: !99, line: 91, baseType: !140, size: 64, offset: 1216)
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !141, size: 64)
!141 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_codecvt", file: !99, line: 37, flags: DIFlagFwdDecl)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "_wide_data", scope: !98, file: !99, line: 92, baseType: !143, size: 64, offset: 1280)
!143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !144, size: 64)
!144 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_wide_data", file: !99, line: 38, flags: DIFlagFwdDecl)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_list", scope: !98, file: !99, line: 93, baseType: !119, size: 64, offset: 1344)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "_freeres_buf", scope: !98, file: !99, line: 94, baseType: !44, size: 64, offset: 1408)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !98, file: !99, line: 95, baseType: !148, size: 64, offset: 1472)
!148 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !149, line: 46, baseType: !150)
!149 = !DIFile(filename: "/usr/lib/llvm-10/lib/clang/10.0.0/include/stddef.h", directory: "")
!150 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !98, file: !99, line: 96, baseType: !102, size: 32, offset: 1536)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !98, file: !99, line: 98, baseType: !153, size: 160, offset: 1568)
!153 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 160, elements: !154)
!154 = !{!155}
!155 = !DISubrange(count: 20)
!156 = !DIGlobalVariableExpression(var: !157, expr: !DIExpression())
!157 = distinct !DIGlobalVariable(name: "stdout", scope: !2, file: !94, line: 138, type: !95, isLocal: false, isDefinition: false)
!158 = !DIGlobalVariableExpression(var: !159, expr: !DIExpression())
!159 = distinct !DIGlobalVariable(name: "bpf_csum_diff", scope: !2, file: !160, line: 782, type: !161, isLocal: true, isDefinition: true)
!160 = !DIFile(filename: "../libbpf/src//build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/rohit/cloned/New-IP/xdp/newip_router")
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!162 = !DISubroutineType(types: !163)
!163 = !{!164, !74, !71, !74, !71, !165}
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "__s64", file: !47, line: 30, baseType: !138)
!165 = !DIDerivedType(tag: DW_TAG_typedef, name: "__wsum", file: !65, line: 32, baseType: !71)
!166 = !DIGlobalVariableExpression(var: !167, expr: !DIExpression())
!167 = distinct !DIGlobalVariable(name: "bpf_redirect", scope: !2, file: !160, line: 607, type: !168, isLocal: true, isDefinition: true)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !169, size: 64)
!169 = !DISubroutineType(types: !170)
!170 = !{!45, !71, !171}
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !172)
!172 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!173 = !DIGlobalVariableExpression(var: !174, expr: !DIExpression())
!174 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !160, line: 49, type: !175, isLocal: true, isDefinition: true)
!175 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !176, size: 64)
!176 = !DISubroutineType(types: !177)
!177 = !{!44, !44, !178}
!178 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !179, size: 64)
!179 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!180 = !DIGlobalVariableExpression(var: !181, expr: !DIExpression())
!181 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !160, line: 1286, type: !182, isLocal: true, isDefinition: true)
!182 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !183, size: 64)
!183 = !DISubroutineType(types: !184)
!184 = !{!45, !44, !71, !171}
!185 = !DIGlobalVariableExpression(var: !186, expr: !DIExpression())
!186 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !160, line: 170, type: !187, isLocal: true, isDefinition: true)
!187 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !188, size: 64)
!188 = !DISubroutineType(types: !189)
!189 = !{!45, !190, !71, null}
!190 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !191, size: 64)
!191 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !91)
!192 = !DIGlobalVariableExpression(var: !193, expr: !DIExpression())
!193 = distinct !DIGlobalVariable(name: "bpf_fib_lookup", scope: !2, file: !160, line: 1803, type: !194, isLocal: true, isDefinition: true)
!194 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !195, size: 64)
!195 = !DISubroutineType(types: !196)
!196 = !{!45, !44, !197, !102, !71}
!197 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !198, size: 64)
!198 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_fib_lookup", file: !6, line: 3179, size: 512, elements: !199)
!199 = !{!200, !201, !202, !203, !204, !205, !206, !212, !218, !223, !224, !225, !229}
!200 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !198, file: !6, line: 3183, baseType: !58, size: 8)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "l4_protocol", scope: !198, file: !6, line: 3186, baseType: !58, size: 8, offset: 8)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !198, file: !6, line: 3187, baseType: !64, size: 16, offset: 16)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !198, file: !6, line: 3188, baseType: !64, size: 16, offset: 32)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !198, file: !6, line: 3191, baseType: !46, size: 16, offset: 48)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !198, file: !6, line: 3196, baseType: !71, size: 32, offset: 64)
!206 = !DIDerivedType(tag: DW_TAG_member, scope: !198, file: !6, line: 3198, baseType: !207, size: 32, offset: 96)
!207 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !198, file: !6, line: 3198, size: 32, elements: !208)
!208 = !{!209, !210, !211}
!209 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !207, file: !6, line: 3200, baseType: !58, size: 8)
!210 = !DIDerivedType(tag: DW_TAG_member, name: "flowinfo", scope: !207, file: !6, line: 3201, baseType: !70, size: 32)
!211 = !DIDerivedType(tag: DW_TAG_member, name: "rt_metric", scope: !207, file: !6, line: 3204, baseType: !71, size: 32)
!212 = !DIDerivedType(tag: DW_TAG_member, scope: !198, file: !6, line: 3207, baseType: !213, size: 128, offset: 128)
!213 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !198, file: !6, line: 3207, size: 128, elements: !214)
!214 = !{!215, !216}
!215 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !213, file: !6, line: 3208, baseType: !70, size: 32)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !213, file: !6, line: 3209, baseType: !217, size: 128)
!217 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 128, elements: !72)
!218 = !DIDerivedType(tag: DW_TAG_member, scope: !198, file: !6, line: 3216, baseType: !219, size: 128, offset: 256)
!219 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !198, file: !6, line: 3216, size: 128, elements: !220)
!220 = !{!221, !222}
!221 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !219, file: !6, line: 3217, baseType: !70, size: 32)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !219, file: !6, line: 3218, baseType: !217, size: 128)
!223 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_proto", scope: !198, file: !6, line: 3222, baseType: !64, size: 16, offset: 384)
!224 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !198, file: !6, line: 3223, baseType: !64, size: 16, offset: 400)
!225 = !DIDerivedType(tag: DW_TAG_member, name: "smac", scope: !198, file: !6, line: 3224, baseType: !226, size: 48, offset: 416)
!226 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 48, elements: !227)
!227 = !{!228}
!228 = !DISubrange(count: 6)
!229 = !DIDerivedType(tag: DW_TAG_member, name: "dmac", scope: !198, file: !6, line: 3225, baseType: !226, size: 48, offset: 464)
!230 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/rohit/cloned/New-IP/xdp/newip_router")
!231 = !{i32 7, !"Dwarf Version", i32 4}
!232 = !{i32 2, !"Debug Info Version", i32 3}
!233 = !{i32 1, !"wchar_size", i32 4}
!234 = !{!"clang version 10.0.0-4ubuntu1 "}
!235 = distinct !DISubprogram(name: "xdp_icmp_echo_func", scope: !3, file: !3, line: 64, type: !236, scopeLine: 65, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !246)
!236 = !DISubroutineType(types: !237)
!237 = !{!102, !238}
!238 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !239, size: 64)
!239 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !240)
!240 = !{!241, !242, !243, !244, !245}
!241 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !239, file: !6, line: 2857, baseType: !71, size: 32)
!242 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !239, file: !6, line: 2858, baseType: !71, size: 32, offset: 32)
!243 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !239, file: !6, line: 2859, baseType: !71, size: 32, offset: 64)
!244 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !239, file: !6, line: 2861, baseType: !71, size: 32, offset: 96)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !239, file: !6, line: 2862, baseType: !71, size: 32, offset: 128)
!246 = !{!247, !248, !249, !250, !255, !264, !265, !266, !267, !284, !300, !301, !302, !309, !310, !311}
!247 = !DILocalVariable(name: "ctx", arg: 1, scope: !235, file: !3, line: 64, type: !238)
!248 = !DILocalVariable(name: "data_end", scope: !235, file: !3, line: 66, type: !44)
!249 = !DILocalVariable(name: "data", scope: !235, file: !3, line: 67, type: !44)
!250 = !DILocalVariable(name: "nh", scope: !235, file: !3, line: 68, type: !251)
!251 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !252, line: 33, size: 64, elements: !253)
!252 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/rohit/cloned/New-IP/xdp/newip_router")
!253 = !{!254}
!254 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !251, file: !252, line: 34, baseType: !44, size: 64)
!255 = !DILocalVariable(name: "eth", scope: !235, file: !3, line: 69, type: !256)
!256 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !257, size: 64)
!257 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !258, line: 163, size: 112, elements: !259)
!258 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!259 = !{!260, !262, !263}
!260 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !257, file: !258, line: 164, baseType: !261, size: 48)
!261 = !DICompositeType(tag: DW_TAG_array_type, baseType: !59, size: 48, elements: !227)
!262 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !257, file: !258, line: 165, baseType: !261, size: 48, offset: 48)
!263 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !257, file: !258, line: 166, baseType: !64, size: 16, offset: 96)
!264 = !DILocalVariable(name: "eth_type", scope: !235, file: !3, line: 70, type: !102)
!265 = !DILocalVariable(name: "ip_type", scope: !235, file: !3, line: 71, type: !102)
!266 = !DILocalVariable(name: "icmp_type", scope: !235, file: !3, line: 72, type: !102)
!267 = !DILocalVariable(name: "iphdr", scope: !235, file: !3, line: 73, type: !268)
!268 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !269, size: 64)
!269 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !270, line: 86, size: 160, elements: !271)
!270 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!271 = !{!272, !273, !274, !275, !276, !277, !278, !279, !280, !282, !283}
!272 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !269, file: !270, line: 88, baseType: !58, size: 4, flags: DIFlagBitField, extraData: i64 0)
!273 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !269, file: !270, line: 89, baseType: !58, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!274 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !269, file: !270, line: 96, baseType: !58, size: 8, offset: 8)
!275 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !269, file: !270, line: 97, baseType: !64, size: 16, offset: 16)
!276 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !269, file: !270, line: 98, baseType: !64, size: 16, offset: 32)
!277 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !269, file: !270, line: 99, baseType: !64, size: 16, offset: 48)
!278 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !269, file: !270, line: 100, baseType: !58, size: 8, offset: 64)
!279 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !269, file: !270, line: 101, baseType: !58, size: 8, offset: 72)
!280 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !269, file: !270, line: 102, baseType: !281, size: 16, offset: 80)
!281 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !65, line: 31, baseType: !46)
!282 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !269, file: !270, line: 103, baseType: !70, size: 32, offset: 96)
!283 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !269, file: !270, line: 104, baseType: !70, size: 32, offset: 128)
!284 = !DILocalVariable(name: "ipv6hdr", scope: !235, file: !3, line: 74, type: !285)
!285 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !286, size: 64)
!286 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !287, line: 116, size: 320, elements: !288)
!287 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "")
!288 = !{!289, !290, !291, !295, !296, !297, !298, !299}
!289 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !286, file: !287, line: 118, baseType: !58, size: 4, flags: DIFlagBitField, extraData: i64 0)
!290 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !286, file: !287, line: 119, baseType: !58, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!291 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !286, file: !287, line: 126, baseType: !292, size: 24, offset: 8)
!292 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 24, elements: !293)
!293 = !{!294}
!294 = !DISubrange(count: 3)
!295 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !286, file: !287, line: 128, baseType: !64, size: 16, offset: 32)
!296 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !286, file: !287, line: 129, baseType: !58, size: 8, offset: 48)
!297 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !286, file: !287, line: 130, baseType: !58, size: 8, offset: 56)
!298 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !286, file: !287, line: 132, baseType: !50, size: 128, offset: 64)
!299 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !286, file: !287, line: 133, baseType: !50, size: 128, offset: 192)
!300 = !DILocalVariable(name: "echo_reply", scope: !235, file: !3, line: 75, type: !46)
!301 = !DILocalVariable(name: "old_csum", scope: !235, file: !3, line: 75, type: !46)
!302 = !DILocalVariable(name: "icmphdr", scope: !235, file: !3, line: 76, type: !303)
!303 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !304, size: 64)
!304 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmphdr_common", file: !252, line: 51, size: 32, elements: !305)
!305 = !{!306, !307, !308}
!306 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !304, file: !252, line: 52, baseType: !58, size: 8)
!307 = !DIDerivedType(tag: DW_TAG_member, name: "code", scope: !304, file: !252, line: 53, baseType: !58, size: 8, offset: 8)
!308 = !DIDerivedType(tag: DW_TAG_member, name: "cksum", scope: !304, file: !252, line: 54, baseType: !281, size: 16, offset: 16)
!309 = !DILocalVariable(name: "icmphdr_old", scope: !235, file: !3, line: 77, type: !304)
!310 = !DILocalVariable(name: "action", scope: !235, file: !3, line: 78, type: !71)
!311 = !DILabel(scope: !235, name: "out", file: !3, line: 159)
!312 = !DILocalVariable(name: "tmp", scope: !313, file: !314, line: 127, type: !50)
!313 = distinct !DISubprogram(name: "swap_src_dst_ipv6", scope: !314, file: !314, line: 125, type: !315, scopeLine: 126, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !317)
!314 = !DIFile(filename: "./../common/rewrite_helpers.h", directory: "/home/rohit/cloned/New-IP/xdp/newip_router")
!315 = !DISubroutineType(types: !316)
!316 = !{null, !285}
!317 = !{!318, !312}
!318 = !DILocalVariable(name: "ipv6", arg: 1, scope: !313, file: !314, line: 125, type: !285)
!319 = !DILocation(line: 127, column: 18, scope: !313, inlinedAt: !320)
!320 = distinct !DILocation(line: 118, column: 3, scope: !321)
!321 = distinct !DILexicalBlock(scope: !322, file: !3, line: 116, column: 2)
!322 = distinct !DILexicalBlock(scope: !323, file: !3, line: 115, column: 11)
!323 = distinct !DILexicalBlock(scope: !235, file: !3, line: 109, column: 6)
!324 = !DILocalVariable(name: "h_tmp", scope: !325, file: !314, line: 115, type: !226)
!325 = distinct !DISubprogram(name: "swap_src_dst_mac", scope: !314, file: !314, line: 113, type: !326, scopeLine: 114, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !328)
!326 = !DISubroutineType(types: !327)
!327 = !{null, !256}
!328 = !{!329, !324}
!329 = !DILocalVariable(name: "eth", arg: 1, scope: !325, file: !314, line: 113, type: !256)
!330 = !DILocation(line: 115, column: 7, scope: !325, inlinedAt: !331)
!331 = distinct !DILocation(line: 127, column: 2, scope: !235)
!332 = !DILocation(line: 0, scope: !235)
!333 = !DILocation(line: 66, column: 38, scope: !235)
!334 = !{!335, !336, i64 4}
!335 = !{!"xdp_md", !336, i64 0, !336, i64 4, !336, i64 8, !336, i64 12, !336, i64 16}
!336 = !{!"int", !337, i64 0}
!337 = !{!"omnipotent char", !338, i64 0}
!338 = !{!"Simple C/C++ TBAA"}
!339 = !DILocation(line: 66, column: 27, scope: !235)
!340 = !DILocation(line: 66, column: 19, scope: !235)
!341 = !DILocation(line: 67, column: 34, scope: !235)
!342 = !{!335, !336, i64 0}
!343 = !DILocation(line: 67, column: 23, scope: !235)
!344 = !DILocation(line: 67, column: 15, scope: !235)
!345 = !DILocation(line: 77, column: 2, scope: !235)
!346 = !DILocalVariable(name: "nh", arg: 1, scope: !347, file: !252, line: 124, type: !350)
!347 = distinct !DISubprogram(name: "parse_ethhdr", scope: !252, file: !252, line: 124, type: !348, scopeLine: 127, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !352)
!348 = !DISubroutineType(types: !349)
!349 = !{!102, !350, !44, !351}
!350 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !251, size: 64)
!351 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !256, size: 64)
!352 = !{!346, !353, !354}
!353 = !DILocalVariable(name: "data_end", arg: 2, scope: !347, file: !252, line: 125, type: !44)
!354 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !347, file: !252, line: 126, type: !351)
!355 = !DILocation(line: 0, scope: !347, inlinedAt: !356)
!356 = distinct !DILocation(line: 84, column: 13, scope: !235)
!357 = !DILocalVariable(name: "nh", arg: 1, scope: !358, file: !252, line: 79, type: !350)
!358 = distinct !DISubprogram(name: "parse_ethhdr_vlan", scope: !252, file: !252, line: 79, type: !359, scopeLine: 83, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !368)
!359 = !DISubroutineType(types: !360)
!360 = !{!102, !350, !44, !351, !361}
!361 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !362, size: 64)
!362 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "collect_vlans", file: !252, line: 64, size: 32, elements: !363)
!363 = !{!364}
!364 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !362, file: !252, line: 65, baseType: !365, size: 32)
!365 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 32, elements: !366)
!366 = !{!367}
!367 = !DISubrange(count: 2)
!368 = !{!357, !369, !370, !371, !372, !373, !374, !380, !381}
!369 = !DILocalVariable(name: "data_end", arg: 2, scope: !358, file: !252, line: 80, type: !44)
!370 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !358, file: !252, line: 81, type: !351)
!371 = !DILocalVariable(name: "vlans", arg: 4, scope: !358, file: !252, line: 82, type: !361)
!372 = !DILocalVariable(name: "eth", scope: !358, file: !252, line: 84, type: !256)
!373 = !DILocalVariable(name: "hdrsize", scope: !358, file: !252, line: 85, type: !102)
!374 = !DILocalVariable(name: "vlh", scope: !358, file: !252, line: 86, type: !375)
!375 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !376, size: 64)
!376 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !252, line: 42, size: 32, elements: !377)
!377 = !{!378, !379}
!378 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !376, file: !252, line: 43, baseType: !64, size: 16)
!379 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !376, file: !252, line: 44, baseType: !64, size: 16, offset: 16)
!380 = !DILocalVariable(name: "h_proto", scope: !358, file: !252, line: 87, type: !46)
!381 = !DILocalVariable(name: "i", scope: !358, file: !252, line: 88, type: !102)
!382 = !DILocation(line: 0, scope: !358, inlinedAt: !383)
!383 = distinct !DILocation(line: 129, column: 9, scope: !347, inlinedAt: !356)
!384 = !DILocation(line: 93, column: 14, scope: !385, inlinedAt: !383)
!385 = distinct !DILexicalBlock(scope: !358, file: !252, line: 93, column: 6)
!386 = !DILocation(line: 93, column: 24, scope: !385, inlinedAt: !383)
!387 = !DILocation(line: 93, column: 6, scope: !358, inlinedAt: !383)
!388 = !DILocation(line: 97, column: 10, scope: !358, inlinedAt: !383)
!389 = !DILocation(line: 99, column: 17, scope: !358, inlinedAt: !383)
!390 = !{!391, !391, i64 0}
!391 = !{!"short", !337, i64 0}
!392 = !DILocation(line: 0, scope: !393, inlinedAt: !383)
!393 = distinct !DILexicalBlock(scope: !394, file: !252, line: 109, column: 7)
!394 = distinct !DILexicalBlock(scope: !395, file: !252, line: 105, column: 39)
!395 = distinct !DILexicalBlock(scope: !396, file: !252, line: 105, column: 2)
!396 = distinct !DILexicalBlock(scope: !358, file: !252, line: 105, column: 2)
!397 = !DILocation(line: 105, column: 2, scope: !396, inlinedAt: !383)
!398 = !DILocation(line: 106, column: 7, scope: !394, inlinedAt: !383)
!399 = !DILocation(line: 109, column: 11, scope: !393, inlinedAt: !383)
!400 = !DILocation(line: 109, column: 15, scope: !393, inlinedAt: !383)
!401 = !DILocation(line: 109, column: 7, scope: !394, inlinedAt: !383)
!402 = !DILocation(line: 112, column: 18, scope: !394, inlinedAt: !383)
!403 = !DILocation(line: 85, column: 6, scope: !235)
!404 = !DILocalVariable(name: "nh", arg: 1, scope: !405, file: !252, line: 151, type: !350)
!405 = distinct !DISubprogram(name: "parse_iphdr", scope: !252, file: !252, line: 151, type: !406, scopeLine: 154, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !409)
!406 = !DISubroutineType(types: !407)
!407 = !{!102, !350, !44, !408}
!408 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !268, size: 64)
!409 = !{!404, !410, !411, !412, !413}
!410 = !DILocalVariable(name: "data_end", arg: 2, scope: !405, file: !252, line: 152, type: !44)
!411 = !DILocalVariable(name: "iphdr", arg: 3, scope: !405, file: !252, line: 153, type: !408)
!412 = !DILocalVariable(name: "iph", scope: !405, file: !252, line: 155, type: !268)
!413 = !DILocalVariable(name: "hdrsize", scope: !405, file: !252, line: 156, type: !102)
!414 = !DILocation(line: 0, scope: !405, inlinedAt: !415)
!415 = distinct !DILocation(line: 87, column: 13, scope: !416)
!416 = distinct !DILexicalBlock(scope: !417, file: !3, line: 86, column: 2)
!417 = distinct !DILexicalBlock(scope: !235, file: !3, line: 85, column: 6)
!418 = !DILocation(line: 158, column: 10, scope: !419, inlinedAt: !415)
!419 = distinct !DILexicalBlock(scope: !405, file: !252, line: 158, column: 6)
!420 = !DILocation(line: 158, column: 14, scope: !419, inlinedAt: !415)
!421 = !DILocation(line: 158, column: 6, scope: !405, inlinedAt: !415)
!422 = !DILocation(line: 161, column: 17, scope: !405, inlinedAt: !415)
!423 = !DILocation(line: 161, column: 21, scope: !405, inlinedAt: !415)
!424 = !DILocation(line: 163, column: 13, scope: !425, inlinedAt: !415)
!425 = distinct !DILexicalBlock(scope: !405, file: !252, line: 163, column: 5)
!426 = !DILocation(line: 163, column: 5, scope: !405, inlinedAt: !415)
!427 = !DILocation(line: 163, column: 5, scope: !425, inlinedAt: !415)
!428 = !DILocation(line: 167, column: 14, scope: !429, inlinedAt: !415)
!429 = distinct !DILexicalBlock(scope: !405, file: !252, line: 167, column: 6)
!430 = !DILocation(line: 167, column: 24, scope: !429, inlinedAt: !415)
!431 = !DILocation(line: 167, column: 6, scope: !405, inlinedAt: !415)
!432 = !DILocation(line: 171, column: 9, scope: !405, inlinedAt: !415)
!433 = !DILocation(line: 173, column: 14, scope: !405, inlinedAt: !415)
!434 = !{!435, !337, i64 9}
!435 = !{!"iphdr", !337, i64 0, !337, i64 0, !337, i64 1, !391, i64 2, !391, i64 4, !391, i64 6, !337, i64 8, !337, i64 9, !391, i64 10, !336, i64 12, !336, i64 16}
!436 = !DILocation(line: 88, column: 15, scope: !437)
!437 = distinct !DILexicalBlock(scope: !416, file: !3, line: 88, column: 7)
!438 = !DILocation(line: 88, column: 7, scope: !416)
!439 = !DILocalVariable(name: "nh", arg: 1, scope: !440, file: !252, line: 132, type: !350)
!440 = distinct !DISubprogram(name: "parse_ip6hdr", scope: !252, file: !252, line: 132, type: !441, scopeLine: 135, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !444)
!441 = !DISubroutineType(types: !442)
!442 = !{!102, !350, !44, !443}
!443 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !285, size: 64)
!444 = !{!439, !445, !446, !447}
!445 = !DILocalVariable(name: "data_end", arg: 2, scope: !440, file: !252, line: 133, type: !44)
!446 = !DILocalVariable(name: "ip6hdr", arg: 3, scope: !440, file: !252, line: 134, type: !443)
!447 = !DILocalVariable(name: "ip6h", scope: !440, file: !252, line: 136, type: !285)
!448 = !DILocation(line: 0, scope: !440, inlinedAt: !449)
!449 = distinct !DILocation(line: 93, column: 13, scope: !450)
!450 = distinct !DILexicalBlock(scope: !451, file: !3, line: 92, column: 2)
!451 = distinct !DILexicalBlock(scope: !417, file: !3, line: 91, column: 11)
!452 = !DILocation(line: 142, column: 11, scope: !453, inlinedAt: !449)
!453 = distinct !DILexicalBlock(scope: !440, file: !252, line: 142, column: 6)
!454 = !DILocation(line: 142, column: 17, scope: !453, inlinedAt: !449)
!455 = !DILocation(line: 142, column: 15, scope: !453, inlinedAt: !449)
!456 = !DILocation(line: 142, column: 6, scope: !440, inlinedAt: !449)
!457 = !DILocation(line: 136, column: 29, scope: !440, inlinedAt: !449)
!458 = !DILocation(line: 148, column: 15, scope: !440, inlinedAt: !449)
!459 = !{!460, !337, i64 6}
!460 = !{!"ipv6hdr", !337, i64 0, !337, i64 0, !337, i64 1, !391, i64 4, !337, i64 6, !337, i64 7, !461, i64 8, !461, i64 24}
!461 = !{!"in6_addr", !337, i64 0}
!462 = !DILocation(line: 94, column: 15, scope: !463)
!463 = distinct !DILexicalBlock(scope: !450, file: !3, line: 94, column: 7)
!464 = !DILocation(line: 94, column: 7, scope: !450)
!465 = !DILocation(line: 81, column: 9, scope: !235)
!466 = !DILocalVariable(name: "nh", arg: 1, scope: !467, file: !252, line: 206, type: !350)
!467 = distinct !DISubprogram(name: "parse_icmphdr_common", scope: !252, file: !252, line: 206, type: !468, scopeLine: 209, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !471)
!468 = !DISubroutineType(types: !469)
!469 = !{!102, !350, !44, !470}
!470 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !303, size: 64)
!471 = !{!466, !472, !473, !474}
!472 = !DILocalVariable(name: "data_end", arg: 2, scope: !467, file: !252, line: 207, type: !44)
!473 = !DILocalVariable(name: "icmphdr", arg: 3, scope: !467, file: !252, line: 208, type: !470)
!474 = !DILocalVariable(name: "h", scope: !467, file: !252, line: 210, type: !303)
!475 = !DILocation(line: 0, scope: !467, inlinedAt: !476)
!476 = distinct !DILocation(line: 108, column: 14, scope: !235)
!477 = !DILocation(line: 212, column: 8, scope: !478, inlinedAt: !476)
!478 = distinct !DILexicalBlock(scope: !467, file: !252, line: 212, column: 6)
!479 = !DILocation(line: 212, column: 14, scope: !478, inlinedAt: !476)
!480 = !DILocation(line: 212, column: 12, scope: !478, inlinedAt: !476)
!481 = !DILocation(line: 212, column: 6, scope: !467, inlinedAt: !476)
!482 = !DILocation(line: 218, column: 12, scope: !467, inlinedAt: !476)
!483 = !{!484, !337, i64 0}
!484 = !{!"icmphdr_common", !337, i64 0, !337, i64 1, !391, i64 2}
!485 = !DILocation(line: 109, column: 51, scope: !323)
!486 = !DILocation(line: 109, column: 38, scope: !323)
!487 = !DILocalVariable(name: "iphdr", arg: 1, scope: !488, file: !314, line: 136, type: !268)
!488 = distinct !DISubprogram(name: "swap_src_dst_ipv4", scope: !314, file: !314, line: 136, type: !489, scopeLine: 137, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !491)
!489 = !DISubroutineType(types: !490)
!490 = !{null, !268}
!491 = !{!487, !492}
!492 = !DILocalVariable(name: "tmp", scope: !488, file: !314, line: 138, type: !70)
!493 = !DILocation(line: 0, scope: !488, inlinedAt: !494)
!494 = distinct !DILocation(line: 112, column: 3, scope: !495)
!495 = distinct !DILexicalBlock(scope: !323, file: !3, line: 110, column: 2)
!496 = !DILocation(line: 138, column: 22, scope: !488, inlinedAt: !494)
!497 = !{!435, !336, i64 12}
!498 = !DILocation(line: 140, column: 24, scope: !488, inlinedAt: !494)
!499 = !{!435, !336, i64 16}
!500 = !DILocation(line: 140, column: 15, scope: !488, inlinedAt: !494)
!501 = !DILocation(line: 141, column: 15, scope: !488, inlinedAt: !494)
!502 = !DILocation(line: 114, column: 2, scope: !495)
!503 = !DILocation(line: 115, column: 20, scope: !322)
!504 = !DILocation(line: 115, column: 58, scope: !322)
!505 = !DILocation(line: 115, column: 45, scope: !322)
!506 = !DILocation(line: 0, scope: !313, inlinedAt: !320)
!507 = !DILocation(line: 127, column: 2, scope: !313, inlinedAt: !320)
!508 = !DILocation(line: 127, column: 30, scope: !313, inlinedAt: !320)
!509 = !{i64 0, i64 16, !510, i64 0, i64 16, !510, i64 0, i64 16, !510}
!510 = !{!337, !337, i64 0}
!511 = !DILocation(line: 129, column: 22, scope: !313, inlinedAt: !320)
!512 = !DILocation(line: 130, column: 16, scope: !313, inlinedAt: !320)
!513 = !DILocation(line: 131, column: 1, scope: !313, inlinedAt: !320)
!514 = !DILocation(line: 0, scope: !325, inlinedAt: !331)
!515 = !DILocation(line: 115, column: 2, scope: !325, inlinedAt: !331)
!516 = !DILocation(line: 117, column: 2, scope: !325, inlinedAt: !331)
!517 = !DILocation(line: 118, column: 2, scope: !325, inlinedAt: !331)
!518 = !DILocation(line: 119, column: 2, scope: !325, inlinedAt: !331)
!519 = !DILocation(line: 120, column: 1, scope: !325, inlinedAt: !331)
!520 = !DILocation(line: 130, column: 22, scope: !235)
!521 = !{!484, !391, i64 2}
!522 = !DILocation(line: 131, column: 17, scope: !235)
!523 = !DILocation(line: 132, column: 17, scope: !235)
!524 = !DILocation(line: 132, column: 16, scope: !235)
!525 = !DILocation(line: 133, column: 16, scope: !235)
!526 = !DILocation(line: 134, column: 38, scope: !235)
!527 = !DILocalVariable(name: "seed", arg: 1, scope: !528, file: !3, line: 52, type: !46)
!528 = distinct !DISubprogram(name: "icmp_checksum_diff", scope: !3, file: !3, line: 51, type: !529, scopeLine: 55, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !531)
!529 = !DISubroutineType(types: !530)
!530 = !{!46, !46, !303, !303}
!531 = !{!527, !532, !533, !534, !535}
!532 = !DILocalVariable(name: "icmphdr_new", arg: 2, scope: !528, file: !3, line: 53, type: !303)
!533 = !DILocalVariable(name: "icmphdr_old", arg: 3, scope: !528, file: !3, line: 54, type: !303)
!534 = !DILocalVariable(name: "csum", scope: !528, file: !3, line: 56, type: !71)
!535 = !DILocalVariable(name: "size", scope: !528, file: !3, line: 56, type: !71)
!536 = !DILocation(line: 0, scope: !528, inlinedAt: !537)
!537 = distinct !DILocation(line: 134, column: 19, scope: !235)
!538 = !DILocation(line: 58, column: 81, scope: !528, inlinedAt: !537)
!539 = !DILocation(line: 58, column: 9, scope: !528, inlinedAt: !537)
!540 = !DILocalVariable(name: "csum", arg: 1, scope: !541, file: !3, line: 36, type: !71)
!541 = distinct !DISubprogram(name: "csum_fold_helper", scope: !3, file: !3, line: 36, type: !542, scopeLine: 37, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !544)
!542 = !DISubroutineType(types: !543)
!543 = !{!46, !71}
!544 = !{!540, !545}
!545 = !DILocalVariable(name: "sum", scope: !541, file: !3, line: 38, type: !71)
!546 = !DILocation(line: 0, scope: !541, inlinedAt: !547)
!547 = distinct !DILocation(line: 59, column: 9, scope: !528, inlinedAt: !537)
!548 = !DILocation(line: 39, column: 14, scope: !541, inlinedAt: !547)
!549 = !DILocation(line: 39, column: 29, scope: !541, inlinedAt: !547)
!550 = !DILocation(line: 39, column: 21, scope: !541, inlinedAt: !547)
!551 = !DILocation(line: 40, column: 14, scope: !541, inlinedAt: !547)
!552 = !DILocation(line: 40, column: 6, scope: !541, inlinedAt: !547)
!553 = !DILocation(line: 41, column: 9, scope: !541, inlinedAt: !547)
!554 = !DILocation(line: 134, column: 17, scope: !235)
!555 = !DILocation(line: 157, column: 2, scope: !235)
!556 = !DILocation(line: 159, column: 1, scope: !235)
!557 = !DILocation(line: 0, scope: !558, inlinedAt: !571)
!558 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !230, file: !230, line: 24, type: !559, scopeLine: 25, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !561)
!559 = !DISubroutineType(types: !560)
!560 = !{!71, !238, !71}
!561 = !{!562, !563, !564}
!562 = !DILocalVariable(name: "ctx", arg: 1, scope: !558, file: !230, line: 24, type: !238)
!563 = !DILocalVariable(name: "action", arg: 2, scope: !558, file: !230, line: 24, type: !71)
!564 = !DILocalVariable(name: "rec", scope: !558, file: !230, line: 30, type: !565)
!565 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !566, size: 64)
!566 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !567, line: 10, size: 128, elements: !568)
!567 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/rohit/cloned/New-IP/xdp/newip_router")
!568 = !{!569, !570}
!569 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !566, file: !567, line: 11, baseType: !171, size: 64)
!570 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !566, file: !567, line: 12, baseType: !171, size: 64, offset: 64)
!571 = distinct !DILocation(line: 160, column: 9, scope: !235)
!572 = !{!336, !336, i64 0}
!573 = !DILocation(line: 30, column: 24, scope: !558, inlinedAt: !571)
!574 = !DILocation(line: 31, column: 7, scope: !575, inlinedAt: !571)
!575 = distinct !DILexicalBlock(scope: !558, file: !230, line: 31, column: 6)
!576 = !DILocation(line: 31, column: 6, scope: !558, inlinedAt: !571)
!577 = !DILocation(line: 38, column: 7, scope: !558, inlinedAt: !571)
!578 = !DILocation(line: 38, column: 17, scope: !558, inlinedAt: !571)
!579 = !{!580, !581, i64 0}
!580 = !{!"datarec", !581, i64 0, !581, i64 8}
!581 = !{!"long long", !337, i64 0}
!582 = !DILocation(line: 39, column: 25, scope: !558, inlinedAt: !571)
!583 = !DILocation(line: 39, column: 41, scope: !558, inlinedAt: !571)
!584 = !DILocation(line: 39, column: 34, scope: !558, inlinedAt: !571)
!585 = !DILocation(line: 39, column: 19, scope: !558, inlinedAt: !571)
!586 = !DILocation(line: 39, column: 7, scope: !558, inlinedAt: !571)
!587 = !DILocation(line: 39, column: 16, scope: !558, inlinedAt: !571)
!588 = !{!580, !581, i64 8}
!589 = !DILocation(line: 41, column: 9, scope: !558, inlinedAt: !571)
!590 = !DILocation(line: 41, column: 2, scope: !558, inlinedAt: !571)
!591 = !DILocation(line: 42, column: 1, scope: !558, inlinedAt: !571)
!592 = !DILocation(line: 161, column: 1, scope: !235)
!593 = !DILocation(line: 160, column: 2, scope: !235)
!594 = distinct !DISubprogram(name: "xdp_redirect_func", scope: !3, file: !3, line: 165, type: !236, scopeLine: 166, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !595)
!595 = !{!596, !597, !598, !599, !600, !601, !602, !603, !604, !605}
!596 = !DILocalVariable(name: "ctx", arg: 1, scope: !594, file: !3, line: 165, type: !238)
!597 = !DILocalVariable(name: "data_end", scope: !594, file: !3, line: 167, type: !44)
!598 = !DILocalVariable(name: "data", scope: !594, file: !3, line: 168, type: !44)
!599 = !DILocalVariable(name: "nh", scope: !594, file: !3, line: 169, type: !251)
!600 = !DILocalVariable(name: "eth", scope: !594, file: !3, line: 170, type: !256)
!601 = !DILocalVariable(name: "eth_type", scope: !594, file: !3, line: 171, type: !102)
!602 = !DILocalVariable(name: "action", scope: !594, file: !3, line: 172, type: !102)
!603 = !DILocalVariable(name: "dst", scope: !594, file: !3, line: 173, type: !261)
!604 = !DILocalVariable(name: "ifindex", scope: !594, file: !3, line: 174, type: !7)
!605 = !DILabel(scope: !594, name: "out", file: !3, line: 188)
!606 = !DILocation(line: 0, scope: !594)
!607 = !DILocation(line: 167, column: 38, scope: !594)
!608 = !DILocation(line: 167, column: 27, scope: !594)
!609 = !DILocation(line: 167, column: 19, scope: !594)
!610 = !DILocation(line: 168, column: 34, scope: !594)
!611 = !DILocation(line: 168, column: 23, scope: !594)
!612 = !DILocation(line: 168, column: 15, scope: !594)
!613 = !DILocation(line: 173, column: 2, scope: !594)
!614 = !DILocation(line: 173, column: 16, scope: !594)
!615 = !DILocation(line: 0, scope: !347, inlinedAt: !616)
!616 = distinct !DILocation(line: 180, column: 13, scope: !594)
!617 = !DILocation(line: 0, scope: !358, inlinedAt: !618)
!618 = distinct !DILocation(line: 129, column: 9, scope: !347, inlinedAt: !616)
!619 = !DILocation(line: 93, column: 14, scope: !385, inlinedAt: !618)
!620 = !DILocation(line: 93, column: 24, scope: !385, inlinedAt: !618)
!621 = !DILocation(line: 93, column: 6, scope: !358, inlinedAt: !618)
!622 = !DILocation(line: 97, column: 10, scope: !358, inlinedAt: !618)
!623 = !DILocation(line: 185, column: 2, scope: !594)
!624 = !DILocation(line: 186, column: 11, scope: !594)
!625 = !DILocation(line: 188, column: 1, scope: !594)
!626 = !DILocation(line: 0, scope: !558, inlinedAt: !627)
!627 = distinct !DILocation(line: 189, column: 9, scope: !594)
!628 = !DILocation(line: 26, column: 13, scope: !629, inlinedAt: !627)
!629 = distinct !DILexicalBlock(scope: !558, file: !230, line: 26, column: 6)
!630 = !DILocation(line: 26, column: 6, scope: !558, inlinedAt: !627)
!631 = !DILocation(line: 30, column: 24, scope: !558, inlinedAt: !627)
!632 = !DILocation(line: 31, column: 7, scope: !575, inlinedAt: !627)
!633 = !DILocation(line: 31, column: 6, scope: !558, inlinedAt: !627)
!634 = !DILocation(line: 38, column: 7, scope: !558, inlinedAt: !627)
!635 = !DILocation(line: 38, column: 17, scope: !558, inlinedAt: !627)
!636 = !DILocation(line: 39, column: 25, scope: !558, inlinedAt: !627)
!637 = !DILocation(line: 39, column: 41, scope: !558, inlinedAt: !627)
!638 = !DILocation(line: 39, column: 34, scope: !558, inlinedAt: !627)
!639 = !DILocation(line: 39, column: 19, scope: !558, inlinedAt: !627)
!640 = !DILocation(line: 39, column: 7, scope: !558, inlinedAt: !627)
!641 = !DILocation(line: 39, column: 16, scope: !558, inlinedAt: !627)
!642 = !DILocation(line: 41, column: 9, scope: !558, inlinedAt: !627)
!643 = !DILocation(line: 41, column: 2, scope: !558, inlinedAt: !627)
!644 = !DILocation(line: 42, column: 1, scope: !558, inlinedAt: !627)
!645 = !DILocation(line: 190, column: 1, scope: !594)
!646 = !DILocation(line: 189, column: 2, scope: !594)
!647 = distinct !DISubprogram(name: "xdp_redirect_map_func", scope: !3, file: !3, line: 194, type: !236, scopeLine: 195, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !648)
!648 = !{!649, !650, !651, !652, !653, !654, !655, !656, !658}
!649 = !DILocalVariable(name: "ctx", arg: 1, scope: !647, file: !3, line: 194, type: !238)
!650 = !DILocalVariable(name: "data_end", scope: !647, file: !3, line: 196, type: !44)
!651 = !DILocalVariable(name: "data", scope: !647, file: !3, line: 197, type: !44)
!652 = !DILocalVariable(name: "nh", scope: !647, file: !3, line: 198, type: !251)
!653 = !DILocalVariable(name: "eth", scope: !647, file: !3, line: 199, type: !256)
!654 = !DILocalVariable(name: "eth_type", scope: !647, file: !3, line: 200, type: !102)
!655 = !DILocalVariable(name: "action", scope: !647, file: !3, line: 201, type: !102)
!656 = !DILocalVariable(name: "dst", scope: !647, file: !3, line: 202, type: !657)
!657 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!658 = !DILabel(scope: !647, name: "out", file: !3, line: 221)
!659 = !DILocation(line: 0, scope: !647)
!660 = !DILocation(line: 196, column: 38, scope: !647)
!661 = !DILocation(line: 196, column: 27, scope: !647)
!662 = !DILocation(line: 196, column: 19, scope: !647)
!663 = !DILocation(line: 197, column: 34, scope: !647)
!664 = !DILocation(line: 197, column: 23, scope: !647)
!665 = !DILocation(line: 197, column: 15, scope: !647)
!666 = !DILocation(line: 0, scope: !347, inlinedAt: !667)
!667 = distinct !DILocation(line: 208, column: 13, scope: !647)
!668 = !DILocation(line: 0, scope: !358, inlinedAt: !669)
!669 = distinct !DILocation(line: 129, column: 9, scope: !347, inlinedAt: !667)
!670 = !DILocation(line: 93, column: 14, scope: !385, inlinedAt: !669)
!671 = !DILocation(line: 93, column: 24, scope: !385, inlinedAt: !669)
!672 = !DILocation(line: 93, column: 6, scope: !358, inlinedAt: !669)
!673 = !DILocation(line: 97, column: 10, scope: !358, inlinedAt: !669)
!674 = !DILocation(line: 213, column: 46, scope: !647)
!675 = !DILocation(line: 213, column: 8, scope: !647)
!676 = !DILocation(line: 214, column: 7, scope: !677)
!677 = distinct !DILexicalBlock(scope: !647, file: !3, line: 214, column: 6)
!678 = !DILocation(line: 214, column: 6, scope: !647)
!679 = !DILocation(line: 221, column: 1, scope: !647)
!680 = !DILocation(line: 0, scope: !558, inlinedAt: !681)
!681 = distinct !DILocation(line: 222, column: 9, scope: !647)
!682 = !DILocation(line: 26, column: 6, scope: !558, inlinedAt: !681)
!683 = !DILocation(line: 218, column: 2, scope: !647)
!684 = !DILocation(line: 219, column: 11, scope: !647)
!685 = !DILocation(line: 26, column: 13, scope: !629, inlinedAt: !681)
!686 = !DILocation(line: 30, column: 24, scope: !558, inlinedAt: !681)
!687 = !DILocation(line: 31, column: 7, scope: !575, inlinedAt: !681)
!688 = !DILocation(line: 31, column: 6, scope: !558, inlinedAt: !681)
!689 = !DILocation(line: 38, column: 7, scope: !558, inlinedAt: !681)
!690 = !DILocation(line: 38, column: 17, scope: !558, inlinedAt: !681)
!691 = !DILocation(line: 39, column: 25, scope: !558, inlinedAt: !681)
!692 = !DILocation(line: 39, column: 41, scope: !558, inlinedAt: !681)
!693 = !DILocation(line: 39, column: 34, scope: !558, inlinedAt: !681)
!694 = !DILocation(line: 39, column: 19, scope: !558, inlinedAt: !681)
!695 = !DILocation(line: 39, column: 7, scope: !558, inlinedAt: !681)
!696 = !DILocation(line: 39, column: 16, scope: !558, inlinedAt: !681)
!697 = !DILocation(line: 41, column: 9, scope: !558, inlinedAt: !681)
!698 = !DILocation(line: 41, column: 2, scope: !558, inlinedAt: !681)
!699 = !DILocation(line: 42, column: 1, scope: !558, inlinedAt: !681)
!700 = !DILocation(line: 222, column: 2, scope: !647)
!701 = distinct !DISubprogram(name: "xdp_router_func", scope: !3, file: !3, line: 242, type: !236, scopeLine: 243, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !702)
!702 = !{!703, !704, !705, !706, !707, !708, !709, !710, !721, !722, !723, !724, !725, !729, !730, !735, !740, !742, !747, !752, !754, !759, !762, !765, !768, !773}
!703 = !DILocalVariable(name: "ctx", arg: 1, scope: !701, file: !3, line: 242, type: !238)
!704 = !DILocalVariable(name: "data_end", scope: !701, file: !3, line: 244, type: !44)
!705 = !DILocalVariable(name: "data", scope: !701, file: !3, line: 245, type: !44)
!706 = !DILocalVariable(name: "fib_params", scope: !701, file: !3, line: 246, type: !198)
!707 = !DILocalVariable(name: "eth", scope: !701, file: !3, line: 247, type: !256)
!708 = !DILocalVariable(name: "ip6h", scope: !701, file: !3, line: 248, type: !285)
!709 = !DILocalVariable(name: "iph", scope: !701, file: !3, line: 249, type: !268)
!710 = !DILocalVariable(name: "newiph", scope: !701, file: !3, line: 250, type: !711)
!711 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !712, size: 64)
!712 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "newiphdr", file: !713, line: 3, size: 96, elements: !714)
!713 = !DIFile(filename: "./newip.h", directory: "/home/rohit/cloned/New-IP/xdp/newip_router")
!714 = !{!715, !716, !717, !718, !719, !720}
!715 = !DIDerivedType(tag: DW_TAG_member, name: "src_addr_type", scope: !712, file: !713, line: 5, baseType: !58, size: 8)
!716 = !DIDerivedType(tag: DW_TAG_member, name: "dst_addr_type", scope: !712, file: !713, line: 6, baseType: !58, size: 8, offset: 8)
!717 = !DIDerivedType(tag: DW_TAG_member, name: "addr_cast", scope: !712, file: !713, line: 7, baseType: !58, size: 8, offset: 16)
!718 = !DIDerivedType(tag: DW_TAG_member, name: "dummy", scope: !712, file: !713, line: 8, baseType: !58, size: 8, offset: 24)
!719 = !DIDerivedType(tag: DW_TAG_member, name: "src", scope: !712, file: !713, line: 9, baseType: !71, size: 32, offset: 32)
!720 = !DIDerivedType(tag: DW_TAG_member, name: "dst", scope: !712, file: !713, line: 10, baseType: !71, size: 32, offset: 64)
!721 = !DILocalVariable(name: "h_proto", scope: !701, file: !3, line: 251, type: !46)
!722 = !DILocalVariable(name: "nh_off", scope: !701, file: !3, line: 252, type: !171)
!723 = !DILocalVariable(name: "rc", scope: !701, file: !3, line: 253, type: !102)
!724 = !DILocalVariable(name: "action", scope: !701, file: !3, line: 254, type: !102)
!725 = !DILocalVariable(name: "src", scope: !726, file: !3, line: 288, type: !49)
!726 = distinct !DILexicalBlock(scope: !727, file: !3, line: 287, column: 2)
!727 = distinct !DILexicalBlock(scope: !728, file: !3, line: 286, column: 11)
!728 = distinct !DILexicalBlock(scope: !701, file: !3, line: 264, column: 6)
!729 = !DILocalVariable(name: "dst", scope: !726, file: !3, line: 289, type: !49)
!730 = !DILocalVariable(name: "____fmt", scope: !731, file: !3, line: 320, type: !734)
!731 = distinct !DILexicalBlock(scope: !732, file: !3, line: 320, column: 3)
!732 = distinct !DILexicalBlock(scope: !733, file: !3, line: 311, column: 2)
!733 = distinct !DILexicalBlock(scope: !727, file: !3, line: 310, column: 11)
!734 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 128, elements: !60)
!735 = !DILocalVariable(name: "____fmt", scope: !736, file: !3, line: 321, type: !737)
!736 = distinct !DILexicalBlock(scope: !732, file: !3, line: 321, column: 3)
!737 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 112, elements: !738)
!738 = !{!739}
!739 = !DISubrange(count: 14)
!740 = !DILocalVariable(name: "____fmt", scope: !741, file: !3, line: 322, type: !734)
!741 = distinct !DILexicalBlock(scope: !732, file: !3, line: 322, column: 3)
!742 = !DILocalVariable(name: "____fmt", scope: !743, file: !3, line: 323, type: !744)
!743 = distinct !DILexicalBlock(scope: !732, file: !3, line: 323, column: 3)
!744 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 120, elements: !745)
!745 = !{!746}
!746 = !DISubrange(count: 15)
!747 = !DILocalVariable(name: "____fmt", scope: !748, file: !3, line: 324, type: !749)
!748 = distinct !DILexicalBlock(scope: !732, file: !3, line: 324, column: 3)
!749 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 264, elements: !750)
!750 = !{!751}
!751 = !DISubrange(count: 33)
!752 = !DILocalVariable(name: "____fmt", scope: !753, file: !3, line: 325, type: !749)
!753 = distinct !DILexicalBlock(scope: !732, file: !3, line: 325, column: 3)
!754 = !DILocalVariable(name: "____fmt", scope: !755, file: !3, line: 326, type: !756)
!755 = distinct !DILexicalBlock(scope: !732, file: !3, line: 326, column: 3)
!756 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 88, elements: !757)
!757 = !{!758}
!758 = !DISubrange(count: 11)
!759 = !DILocalVariable(name: "____fmt", scope: !760, file: !3, line: 327, type: !761)
!760 = distinct !DILexicalBlock(scope: !732, file: !3, line: 327, column: 3)
!761 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 16, elements: !366)
!762 = !DILocalVariable(name: "____fmt", scope: !763, file: !3, line: 346, type: !764)
!763 = distinct !DILexicalBlock(scope: !701, file: !3, line: 346, column: 2)
!764 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 64, elements: !66)
!765 = !DILocalVariable(name: "____fmt", scope: !766, file: !3, line: 350, type: !153)
!766 = distinct !DILexicalBlock(scope: !767, file: !3, line: 350, column: 3)
!767 = distinct !DILexicalBlock(scope: !701, file: !3, line: 348, column: 2)
!768 = !DILocalVariable(name: "____fmt", scope: !769, file: !3, line: 375, type: !770)
!769 = distinct !DILexicalBlock(scope: !701, file: !3, line: 375, column: 2)
!770 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 96, elements: !771)
!771 = !{!772}
!772 = !DISubrange(count: 12)
!773 = !DILabel(scope: !701, name: "out", file: !3, line: 374)
!774 = !DILocation(line: 0, scope: !701)
!775 = !DILocation(line: 244, column: 38, scope: !701)
!776 = !DILocation(line: 244, column: 27, scope: !701)
!777 = !DILocation(line: 244, column: 19, scope: !701)
!778 = !DILocation(line: 245, column: 34, scope: !701)
!779 = !DILocation(line: 245, column: 23, scope: !701)
!780 = !DILocation(line: 245, column: 15, scope: !701)
!781 = !DILocation(line: 246, column: 2, scope: !701)
!782 = !DILocation(line: 246, column: 24, scope: !701)
!783 = !DILocation(line: 247, column: 23, scope: !701)
!784 = !DILocation(line: 257, column: 11, scope: !785)
!785 = distinct !DILexicalBlock(scope: !701, file: !3, line: 257, column: 6)
!786 = !DILocation(line: 257, column: 20, scope: !785)
!787 = !DILocation(line: 257, column: 6, scope: !701)
!788 = !DILocation(line: 263, column: 17, scope: !701)
!789 = !{!790, !391, i64 12}
!790 = !{!"ethhdr", !337, i64 0, !337, i64 6, !391, i64 12}
!791 = !DILocation(line: 264, column: 14, scope: !728)
!792 = !DILocation(line: 264, column: 6, scope: !701)
!793 = !DILocation(line: 266, column: 9, scope: !794)
!794 = distinct !DILexicalBlock(scope: !728, file: !3, line: 265, column: 2)
!795 = !DILocation(line: 268, column: 11, scope: !796)
!796 = distinct !DILexicalBlock(scope: !794, file: !3, line: 268, column: 7)
!797 = !DILocation(line: 268, column: 17, scope: !796)
!798 = !DILocation(line: 268, column: 15, scope: !796)
!799 = !DILocation(line: 268, column: 7, scope: !794)
!800 = !DILocation(line: 274, column: 12, scope: !801)
!801 = distinct !DILexicalBlock(scope: !794, file: !3, line: 274, column: 7)
!802 = !{!435, !337, i64 8}
!803 = !DILocation(line: 274, column: 16, scope: !801)
!804 = !DILocation(line: 274, column: 7, scope: !794)
!805 = !DILocation(line: 277, column: 21, scope: !794)
!806 = !{!807, !337, i64 0}
!807 = !{!"bpf_fib_lookup", !337, i64 0, !337, i64 1, !391, i64 2, !391, i64 4, !391, i64 6, !336, i64 8, !337, i64 12, !337, i64 16, !337, i64 32, !391, i64 48, !391, i64 50, !337, i64 52, !337, i64 58}
!808 = !DILocation(line: 278, column: 25, scope: !794)
!809 = !{!435, !337, i64 1}
!810 = !DILocation(line: 278, column: 14, scope: !794)
!811 = !DILocation(line: 278, column: 18, scope: !794)
!812 = !DILocation(line: 279, column: 33, scope: !794)
!813 = !DILocation(line: 279, column: 14, scope: !794)
!814 = !DILocation(line: 279, column: 26, scope: !794)
!815 = !{!807, !337, i64 1}
!816 = !DILocation(line: 280, column: 14, scope: !794)
!817 = !DILocation(line: 280, column: 20, scope: !794)
!818 = !{!807, !391, i64 2}
!819 = !DILocation(line: 281, column: 14, scope: !794)
!820 = !DILocation(line: 281, column: 20, scope: !794)
!821 = !{!807, !391, i64 4}
!822 = !DILocation(line: 282, column: 24, scope: !794)
!823 = !{!435, !391, i64 2}
!824 = !DILocation(line: 282, column: 14, scope: !794)
!825 = !DILocation(line: 282, column: 22, scope: !794)
!826 = !{!807, !391, i64 6}
!827 = !DILocation(line: 283, column: 30, scope: !794)
!828 = !DILocation(line: 283, column: 14, scope: !794)
!829 = !DILocation(line: 283, column: 23, scope: !794)
!830 = !DILocation(line: 284, column: 30, scope: !794)
!831 = !DILocation(line: 284, column: 14, scope: !794)
!832 = !DILocation(line: 284, column: 23, scope: !794)
!833 = !DILocation(line: 285, column: 2, scope: !794)
!834 = !DILocation(line: 286, column: 11, scope: !728)
!835 = !DILocation(line: 288, column: 45, scope: !726)
!836 = !DILocation(line: 0, scope: !726)
!837 = !DILocation(line: 289, column: 45, scope: !726)
!838 = !DILocation(line: 291, column: 10, scope: !726)
!839 = !DILocation(line: 292, column: 12, scope: !840)
!840 = distinct !DILexicalBlock(scope: !726, file: !3, line: 292, column: 7)
!841 = !DILocation(line: 292, column: 18, scope: !840)
!842 = !DILocation(line: 292, column: 16, scope: !840)
!843 = !DILocation(line: 292, column: 7, scope: !726)
!844 = !DILocation(line: 298, column: 13, scope: !845)
!845 = distinct !DILexicalBlock(scope: !726, file: !3, line: 298, column: 7)
!846 = !{!460, !337, i64 7}
!847 = !DILocation(line: 298, column: 23, scope: !845)
!848 = !DILocation(line: 298, column: 7, scope: !726)
!849 = !DILocation(line: 301, column: 21, scope: !726)
!850 = !DILocation(line: 302, column: 25, scope: !726)
!851 = !DILocation(line: 302, column: 41, scope: !726)
!852 = !DILocation(line: 302, column: 14, scope: !726)
!853 = !DILocation(line: 302, column: 23, scope: !726)
!854 = !DILocation(line: 303, column: 34, scope: !726)
!855 = !DILocation(line: 303, column: 14, scope: !726)
!856 = !DILocation(line: 303, column: 26, scope: !726)
!857 = !DILocation(line: 304, column: 14, scope: !726)
!858 = !DILocation(line: 304, column: 20, scope: !726)
!859 = !DILocation(line: 305, column: 14, scope: !726)
!860 = !DILocation(line: 305, column: 20, scope: !726)
!861 = !DILocation(line: 306, column: 24, scope: !726)
!862 = !{!460, !391, i64 4}
!863 = !DILocation(line: 306, column: 14, scope: !726)
!864 = !DILocation(line: 306, column: 22, scope: !726)
!865 = !DILocation(line: 307, column: 16, scope: !726)
!866 = !DILocation(line: 308, column: 16, scope: !726)
!867 = !DILocation(line: 313, column: 14, scope: !868)
!868 = distinct !DILexicalBlock(scope: !732, file: !3, line: 313, column: 7)
!869 = !DILocation(line: 313, column: 20, scope: !868)
!870 = !DILocation(line: 313, column: 18, scope: !868)
!871 = !DILocation(line: 313, column: 7, scope: !732)
!872 = !DILocation(line: 320, column: 3, scope: !731)
!873 = !DILocation(line: 320, column: 3, scope: !732)
!874 = !DILocation(line: 321, column: 3, scope: !736)
!875 = !DILocation(line: 321, column: 3, scope: !732)
!876 = !DILocation(line: 322, column: 3, scope: !741)
!877 = !DILocation(line: 322, column: 3, scope: !732)
!878 = !DILocation(line: 323, column: 3, scope: !743)
!879 = !{!880, !337, i64 2}
!880 = !{!"newiphdr", !337, i64 0, !337, i64 1, !337, i64 2, !337, i64 3, !336, i64 4, !336, i64 8}
!881 = !DILocation(line: 323, column: 3, scope: !732)
!882 = !DILocation(line: 324, column: 3, scope: !748)
!883 = !{!880, !337, i64 0}
!884 = !{!880, !336, i64 4}
!885 = !DILocation(line: 324, column: 3, scope: !732)
!886 = !DILocation(line: 325, column: 3, scope: !753)
!887 = !{!880, !337, i64 1}
!888 = !{!880, !336, i64 8}
!889 = !DILocation(line: 325, column: 3, scope: !732)
!890 = !DILocation(line: 326, column: 3, scope: !755)
!891 = !{!880, !337, i64 3}
!892 = !DILocation(line: 326, column: 3, scope: !732)
!893 = !DILocation(line: 327, column: 3, scope: !760)
!894 = !DILocation(line: 0, scope: !760)
!895 = !DILocation(line: 327, column: 3, scope: !732)
!896 = !DILocation(line: 329, column: 21, scope: !732)
!897 = !DILocation(line: 334, column: 14, scope: !732)
!898 = !DILocation(line: 334, column: 22, scope: !732)
!899 = !DILocation(line: 335, column: 33, scope: !732)
!900 = !DILocation(line: 335, column: 14, scope: !732)
!901 = !DILocation(line: 335, column: 23, scope: !732)
!902 = !DILocation(line: 336, column: 33, scope: !732)
!903 = !DILocation(line: 336, column: 14, scope: !732)
!904 = !DILocation(line: 336, column: 23, scope: !732)
!905 = !DILocation(line: 343, column: 28, scope: !701)
!906 = !{!335, !336, i64 12}
!907 = !DILocation(line: 343, column: 13, scope: !701)
!908 = !DILocation(line: 343, column: 21, scope: !701)
!909 = !{!807, !336, i64 8}
!910 = !DILocation(line: 345, column: 22, scope: !701)
!911 = !DILocation(line: 345, column: 7, scope: !701)
!912 = !DILocation(line: 346, column: 2, scope: !763)
!913 = !DILocation(line: 0, scope: !763)
!914 = !DILocation(line: 346, column: 2, scope: !701)
!915 = !DILocation(line: 347, column: 2, scope: !701)
!916 = !DILocation(line: 350, column: 3, scope: !766)
!917 = !DILocation(line: 350, column: 3, scope: !767)
!918 = !DILocation(line: 351, column: 7, scope: !767)
!919 = !DILocalVariable(name: "iph", arg: 1, scope: !920, file: !3, line: 230, type: !268)
!920 = distinct !DISubprogram(name: "ip_decrease_ttl", scope: !3, file: !3, line: 230, type: !921, scopeLine: 231, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !923)
!921 = !DISubroutineType(types: !922)
!922 = !{!102, !268}
!923 = !{!919, !924}
!924 = !DILocalVariable(name: "check", scope: !920, file: !3, line: 232, type: !71)
!925 = !DILocation(line: 0, scope: !920, inlinedAt: !926)
!926 = distinct !DILocation(line: 352, column: 4, scope: !927)
!927 = distinct !DILexicalBlock(scope: !767, file: !3, line: 351, column: 7)
!928 = !DILocation(line: 232, column: 21, scope: !920, inlinedAt: !926)
!929 = !{!435, !391, i64 10}
!930 = !DILocation(line: 233, column: 8, scope: !920, inlinedAt: !926)
!931 = !DILocation(line: 234, column: 38, scope: !920, inlinedAt: !926)
!932 = !DILocation(line: 234, column: 29, scope: !920, inlinedAt: !926)
!933 = !DILocation(line: 234, column: 13, scope: !920, inlinedAt: !926)
!934 = !DILocation(line: 235, column: 16, scope: !920, inlinedAt: !926)
!935 = !DILocation(line: 235, column: 9, scope: !920, inlinedAt: !926)
!936 = !DILocation(line: 352, column: 4, scope: !927)
!937 = !DILocation(line: 353, column: 20, scope: !938)
!938 = distinct !DILexicalBlock(scope: !927, file: !3, line: 353, column: 12)
!939 = !DILocation(line: 353, column: 12, scope: !927)
!940 = !DILocation(line: 354, column: 10, scope: !938)
!941 = !DILocation(line: 354, column: 19, scope: !938)
!942 = !DILocation(line: 354, column: 4, scope: !938)
!943 = !DILocation(line: 356, column: 3, scope: !767)
!944 = !DILocation(line: 357, column: 3, scope: !767)
!945 = !DILocation(line: 358, column: 50, scope: !767)
!946 = !DILocation(line: 358, column: 12, scope: !767)
!947 = !DILocation(line: 359, column: 3, scope: !767)
!948 = !DILocation(line: 364, column: 3, scope: !767)
!949 = !DILocation(line: 374, column: 1, scope: !701)
!950 = !DILocation(line: 375, column: 2, scope: !769)
!951 = !DILocation(line: 375, column: 2, scope: !701)
!952 = !DILocation(line: 0, scope: !558, inlinedAt: !953)
!953 = distinct !DILocation(line: 376, column: 9, scope: !701)
!954 = !DILocation(line: 26, column: 13, scope: !629, inlinedAt: !953)
!955 = !DILocation(line: 26, column: 6, scope: !558, inlinedAt: !953)
!956 = !DILocation(line: 30, column: 24, scope: !558, inlinedAt: !953)
!957 = !DILocation(line: 31, column: 7, scope: !575, inlinedAt: !953)
!958 = !DILocation(line: 31, column: 6, scope: !558, inlinedAt: !953)
!959 = !DILocation(line: 38, column: 7, scope: !558, inlinedAt: !953)
!960 = !DILocation(line: 38, column: 17, scope: !558, inlinedAt: !953)
!961 = !DILocation(line: 39, column: 25, scope: !558, inlinedAt: !953)
!962 = !DILocation(line: 39, column: 41, scope: !558, inlinedAt: !953)
!963 = !DILocation(line: 39, column: 34, scope: !558, inlinedAt: !953)
!964 = !DILocation(line: 39, column: 19, scope: !558, inlinedAt: !953)
!965 = !DILocation(line: 39, column: 7, scope: !558, inlinedAt: !953)
!966 = !DILocation(line: 39, column: 16, scope: !558, inlinedAt: !953)
!967 = !DILocation(line: 41, column: 9, scope: !558, inlinedAt: !953)
!968 = !DILocation(line: 41, column: 2, scope: !558, inlinedAt: !953)
!969 = !DILocation(line: 42, column: 1, scope: !558, inlinedAt: !953)
!970 = !DILocation(line: 377, column: 1, scope: !701)
!971 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 380, type: !236, scopeLine: 381, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !972)
!972 = !{!973}
!973 = !DILocalVariable(name: "ctx", arg: 1, scope: !971, file: !3, line: 380, type: !238)
!974 = !DILocation(line: 0, scope: !971)
!975 = !DILocation(line: 382, column: 2, scope: !971)
