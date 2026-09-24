import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../theme/app_colors.dart';
import '../../../fee/cubit/member_fee_cubit.dart';
import '../../../fee/cubit/member_fee_state.dart';
import '../cubit/member_cubit.dart';
import '../cubit/member_state.dart';
import '../cubit/active_member_cubit.dart';
import '../cubit/active_member_state.dart';
import '../cubit/inactive_member_cubit.dart';
import '../cubit/inactive_member_state.dart';
import '../cubit/search_member_cubit.dart';
import '../cubit/search_member_state.dart';
import 'add_member_page.dart';
import 'member_profile_sheet.dart';
import 'member_tile.dart';

import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MemberDetailsPage extends StatefulWidget {
  const MemberDetailsPage({
    super.key,
  });

  @override
  State<MemberDetailsPage> createState() =>
      _MemberDetailsPageState();
}

class _MemberDetailsPageState
    extends State<MemberDetailsPage> {

  int selectedTab = 0;

  final ScrollController scrollController =
  ScrollController();

  bool isSearching = false;

  Timer? _debounce;

  final TextEditingController searchController =
  TextEditingController();



  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      context
          .read<MemberCubit>()
          .getAllMembers();
    });

    scrollController.addListener(
      _paginationListener,
    );
  }

  void _paginationListener() {

    if (!scrollController.hasClients) {
      return;
    }

    final maxScroll =
        scrollController
            .position
            .maxScrollExtent;

    final currentScroll =
        scrollController
            .position
            .pixels;

    if (currentScroll >=
        maxScroll - 200) {

      /// ALL MEMBERS
      if (selectedTab == 0) {

        context
            .read<MemberCubit>()
            .getAllMembers();
      }

      /// ACTIVE MEMBERS
      else if (selectedTab == 1) {

        context
            .read<ActiveMemberCubit>()
            .getActiveMembers();
      }

      /// NOT VISITING MEMBERS
      else {

        context
            .read<InActiveMemberCubit>()
            .getINActiveMembers();
      }
    }
  }


  @override
  void dispose() {

    _debounce?.cancel();

    searchController.dispose();

    scrollController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final bool isTablet = size.width > 700;

    double w(double value) =>
        size.width * (value / 390);

    double h(double value) =>
        size.height * (value / 844);

    return BlocListener<
        MemberFeeCubit,
        MemberFeeState>(
      listener: (context, state) async {

        if (state is MemberFeeLoading) {

          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text(
                "Generating PDF...",
              ),
            ),
          );
        }

        if (state is PdfDownloadedState) {
          final dir = await getTemporaryDirectory();
          final file = File(
            "${dir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.pdf",
          );

          await file.writeAsBytes(
            state.pdfBytes,
          );

          if (!context.mounted) return;
          _showReceiptActionSheet(context, file);
        }

        if (state is MemberFeeError) {

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                state.message,
              ),
            ),
          );
        }
      },

      child: Scaffold(

        backgroundColor:
        AppColors.background,

        body: SafeArea(
          child: Center(
            child: Container(

              constraints: BoxConstraints(
                maxWidth: isTablet
                    ? 650
                    : double.infinity,
              ),

              padding:
              EdgeInsets.all(w(18)),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// TITLE
                  Text(
                    "Members",
                    style: TextStyle(
                      fontSize:
                      isTablet
                          ? 28
                          : 22,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  SizedBox(
                    height: h(18),
                  ),

                  /// SEARCH
                  Row(
                    children: [

                      Expanded(
                        child: Container(

                          height:
                          isTablet
                              ? 58
                              : 50,

                          decoration:
                          BoxDecoration(
                            color:
                            Colors.white,
                            borderRadius:
                            BorderRadius.circular(
                              16,
                            ),
                            border: Border.all(
                              color: Colors
                                  .grey
                                  .shade300,
                            ),
                          ),

                          child: TextField(

                            controller:
                            searchController,

                            onChanged:
                                (value) {

                              _debounce
                                  ?.cancel();

                              _debounce =
                                  Timer(
                                    const Duration(
                                      milliseconds:
                                      500,
                                    ),
                                        () {

                                      if (value
                                          .trim()
                                          .isEmpty) {

                                        setState(() {
                                          isSearching =
                                          false;
                                        });

                                        context
                                            .read<
                                            MemberCubit>()
                                            .getAllMembers(
                                          isRefresh:
                                          true,
                                        );

                                        return;
                                      }

                                      setState(() {
                                        isSearching =
                                        true;
                                      });

                                      context
                                          .read<
                                          SearchMemberCubit>()
                                          .searchMembers(
                                        keyword:
                                        value,
                                      );
                                    },
                                  );
                            },

                            decoration:
                            const InputDecoration(
                              hintText:
                              "Search member...",
                              prefixIcon:
                              Icon(
                                Icons.search,
                              ),
                              border:
                              InputBorder
                                  .none,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: w(12),
                      ),

                      Container(
                        height:
                        isTablet
                            ? 58
                            : 50,

                        width:
                        isTablet
                            ? 58
                            : 50,

                        decoration:
                        BoxDecoration(
                          color:
                          Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color: Colors
                                .grey
                                .shade300,
                          ),
                        ),

                        child: const Icon(
                          Icons.tune_rounded,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: h(18),
                  ),

                  /// TABS
                  Row(
                    children: [

                      _buildTab(
                        title: "All",
                        index: 0,
                        isTablet:
                        isTablet,
                      ),

                      SizedBox(
                        width: w(10),
                      ),

                      _buildTab(
                        title: "Active",
                        index: 1,
                        isTablet:
                        isTablet,
                      ),

                      SizedBox(
                        width: w(10),
                      ),

                      _buildTab(
                        title:
                        "Not Visiting",
                        index: 2,
                        isTablet:
                        isTablet,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: h(24),
                  ),

                  Expanded(
                    child:
                    RefreshIndicator(

                      onRefresh:
                          () async {

                        if (selectedTab ==
                            0) {

                          await context
                              .read<
                              MemberCubit>()
                              .refreshMembers();
                        }

                        else if
                        (selectedTab ==
                            1) {

                          await context
                              .read<
                              ActiveMemberCubit>()
                              .getActiveMembers(
                            isRefresh:
                            true,
                          );
                        }

                        else {

                          await context
                              .read<
                              InActiveMemberCubit>()
                              .getINActiveMembers(
                            isRefresh:
                            true,
                          );
                        }
                      },

                      child:
                      _buildBody(
                        isTablet:
                        isTablet,
                        h: h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// BODY
  Widget _buildBody({
    required bool isTablet,
    required double Function(double) h,
  }) {

    if (isSearching) {

      return BlocBuilder<
          SearchMemberCubit,
          SearchMemberState>(
        builder: (context, state) {

          if (state is SearchMemberLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SearchMemberError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is SearchMemberLoaded) {

            return _memberListView(
              members:
              state.response.data ?? [],
              isTablet: isTablet,
              isLoadingMore: false,
            );
          }

          return const SizedBox();
        },
      );
    }
    /// ================= ALL =================

    if (selectedTab == 0) {

      return BlocBuilder<
          MemberCubit,
          MemberState>(
        builder: (
            context,
            state,
            ) {

          /// LOADING
          if (state
          is MemberLoading) {

            return _loadingList(
              isTablet:
              isTablet,
              h: h,
            );
          }

          /// ERROR
          if (state
          is MemberError) {

            return Center(
              child: Text(
                state.message,
              ),
            );
          }

          /// SUCCESS
          if (state
          is MemberLoaded) {

            return _memberListView(
              members:
              state.members,

              isTablet:
              isTablet,

              isLoadingMore:
              state.isLoadingMore,
            );
          }

          return const SizedBox();
        },
      );
    }

    /// ================= ACTIVE =================

    if (selectedTab == 1) {

      return BlocBuilder<
          ActiveMemberCubit,
          ActiveMemberState>(
        builder: (
            context,
            state,
            ) {

          /// LOADING
          if (state
          is ActiveMemberLoading) {

            return _loadingList(
              isTablet:
              isTablet,
              h: h,
            );
          }

          /// ERROR
          if (state
          is ActiveMemberError) {

            return Center(
              child: Text(
                state.message,
              ),
            );
          }

          /// SUCCESS
          if (state
          is ActiveMemberLoaded) {

            return _memberListView(
              members:
              state.members,

              isTablet:
              isTablet,

              isLoadingMore:
              false,
            );
          }

          /// PAGINATION LOADING
          if (state
          is ActiveMemberPaginationLoading) {

            return _memberListView(
              members:
              state.members,

              isTablet:
              isTablet,

              isLoadingMore:
              true,
            );
          }

          return const SizedBox();
        },
      );
    }

    /// ================= NOT VISITING =================

    return BlocBuilder<
        InActiveMemberCubit,
        InActiveMemberState>(
      builder: (
          context,
          state,
          ) {

        /// LOADING
        if (state
        is InActiveMemberLoading) {

          return _loadingList(
            isTablet:
            isTablet,
            h: h,
          );
        }

        /// ERROR
        if (state
        is InActiveMemberError) {

          return Center(
            child: Text(
              state.message,
            ),
          );
        }

        /// SUCCESS
        if (state
        is InActiveMemberLoaded) {

          return _memberListView(
            members:
            state.members,

            isTablet:
            isTablet,

            isLoadingMore:
            false,
          );
        }

        /// PAGINATION LOADING
        if (state
        is InActiveMemberPaginationLoading) {

          return _memberListView(
            members:
            state.members,

            isTablet:
            isTablet,

            isLoadingMore:
            true,
          );
        }

        return const SizedBox();
      },
    );
  }

  /// TAB
  Widget _buildTab({
    required String title,
    required int index,
    required bool isTablet,
  }) {

    final bool isSelected =
        selectedTab == index;

    return Expanded(
      child: GestureDetector(

        onTap: () {

          setState(() {
            selectedTab = index;
          });

          /// ALL
          if (index == 0) {

            context
                .read<MemberCubit>()
                .getAllMembers(
              isRefresh: true,
            );
          }

          /// ACTIVE
          else if (index == 1) {

            context
                .read<ActiveMemberCubit>()
                .getActiveMembers(
              isRefresh: true,
            );
          }

          /// NOT VISITING
          else {

            context
                .read<
                InActiveMemberCubit>()
                .getINActiveMembers(
              isRefresh: true,
            );
          }
        },

        child: Container(

          height:
          isTablet
              ? 52
              : 46,

          alignment:
          Alignment.center,

          decoration:
          BoxDecoration(

            color:
            isSelected
                ? AppColors
                .primary
                .withOpacity(.1)
                : Colors
                .grey
                .shade100,

            borderRadius:
            BorderRadius.circular(
              14,
            ),

            border: Border.all(
              color:
              isSelected
                  ? AppColors
                  .primary
                  : Colors
                  .transparent,
            ),
          ),

          child: Text(

            title,

            style: TextStyle(
              fontSize:
              isTablet
                  ? 15
                  : 13,

              fontWeight:
              FontWeight.w600,

              color:
              isSelected
                  ? AppColors
                  .primary
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  /// MEMBER LIST
  Widget _memberListView({
    required List members,
    required bool isTablet,
    required bool isLoadingMore,
  }) {

    if (members.isEmpty) {

      return Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: const [

            Icon(
              Icons.people_outline,
              size: 60,
              color: Colors.grey,
            ),

            SizedBox(
              height: 12,
            ),

            Text(
              "No Members Found",
            ),
          ],
        ),
      );
    }

    return ListView.separated(

      controller:
      scrollController,

      physics:
      const BouncingScrollPhysics(),

      itemCount:
      members.length +
          (isLoadingMore
              ? 1
              : 0),

      separatorBuilder:
          (_, __) =>
      const SizedBox(
        height: 18,
      ),

      itemBuilder:
          (context, index) {

        /// PAGINATION LOADER
        if (index ==
            members.length) {

          return const Padding(
            padding:
            EdgeInsets.all(
              20,
            ),

            child: Center(
              child:
              CircularProgressIndicator(),
            ),
          );
        }

        final member =
        members[index];

        final String memberName = (member.name != null && member.name.toString().trim().isNotEmpty)
            ? member.name.toString().trim()
            : (member.user?.name ?? "");

        final String memberPhone = (member.mobNo != null && member.mobNo.toString().trim().isNotEmpty)
            ? member.mobNo.toString().trim()
            : (member.user?.mobNo?.toString() ?? "");

        return MemberTile(
          name: memberName,
          mobNo: memberPhone,
          status: member.memberStatus ?? "",
          image: member.profilePhoto ?? "",
          planName: member.plan?.planName,
          planMonths: member.plan?.durationInMonths,
          expiryDate: member.expiryDate,
          isTablet: isTablet,
          onEdit: () {
            final memberCubit = context.read<MemberCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddMemberPage(
                  member: member,
                ),
              ),
            ).then((updated) {
              if (updated == true) {
                memberCubit.getAllMembers(isRefresh: true);
              }
            });
          },
          onDownloadPdf: () async {
            final memberId = member.id ?? "";
            context
                .read<MemberFeeCubit>()
                .downloadLatestReceiptPdf(memberId);
          },
          onViewProfile: () {
            MemberProfileSheet.show(
              context,
              member: member,
            );
          },
          onTap: () {
            MemberProfileSheet.show(
              context,
              member: member,
            );
          },
        );

      },
    );
  }


  /// LOADING LIST
  Widget _loadingList({
    required bool isTablet,
    required double Function(double) h,
  }) {

    return ListView.separated(

      physics:
      const BouncingScrollPhysics(),

      itemCount: 8,

      separatorBuilder:
          (_, __) =>
          SizedBox(
            height: h(18),
          ),

      itemBuilder:
          (_, __) {

        return _skeletonTile(
          isTablet:
          isTablet,
        );
      },
    );
  }

  /// SKELETON
  Widget _skeletonTile({
    required bool isTablet,
  }) {

    return Shimmer.fromColors(

      baseColor:
      Colors.grey.shade300,

      highlightColor:
      Colors.grey.shade100,

      child: Container(

        padding:
        const EdgeInsets.all(
          14,
        ),

        decoration:
        BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(
            18,
          ),
        ),

        child: Row(
          children: [

            CircleAvatar(

              radius:
              isTablet
                  ? 28
                  : 24,

              backgroundColor:
              Colors.white,
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Container(
                    height: 14,
                    width: 120,
                    color:
                    Colors.white,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Container(
                    height: 12,
                    width: 180,
                    color:
                    Colors.white,
                  ),
                ],
              ),
            ),

            Container(

              height: 26,

              width: 70,

              decoration:
              BoxDecoration(
                color:
                Colors.white,

                borderRadius:
                BorderRadius
                    .circular(
                  30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptActionSheet(BuildContext context, File file) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Color(0xFF25D366),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Receipt PDF Ready",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Send receipt directly to member or view on device",
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Share on WhatsApp / Apps Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      try {
                        final box =
                            context.findRenderObject() as RenderBox?;
                        final rect = box != null
                            ? box.localToGlobal(Offset.zero) & box.size
                            : null;

                        await SharePlus.instance.share(
                          ShareParams(
                            files: [
                              XFile(
                                file.path,
                                mimeType: 'application/pdf',
                                name: 'Gym_Membership_Receipt.pdf',
                              ),
                            ],
                            text:
                                "Dear Member, here is your Gym Membership Fee Receipt.",
                            sharePositionOrigin: rect,
                          ),
                        );
                      } catch (e) {
                        debugPrint("Error sharing PDF: $e");
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red.shade700,
                              content: Text(
                                "Share error: $e\n(Naye plugin ke liye app ko ek baar Stop karke dobara Run karein)",
                              ),
                            ),
                          );
                        }
                      }
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      "Share on WhatsApp / Apps",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Open / View PDF Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      OpenFile.open(file.path);
                    },
                    icon: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    label: const Text(
                      "Open & View PDF",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}