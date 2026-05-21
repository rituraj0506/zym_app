import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../theme/app_colors.dart';
import '../cubit/member_cubit.dart';
import '../cubit/member_state.dart';

class MemberDetailsPage extends StatefulWidget {
  const MemberDetailsPage({super.key});

  @override
  State<MemberDetailsPage> createState() =>
      _MemberDetailsPageState();
}

class _MemberDetailsPageState
    extends State<MemberDetailsPage> {

  int selectedTab = 0;

  final ScrollController scrollController =
  ScrollController();

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      context
          .read<MemberCubit>()
          .getAllMembers();
    });

    scrollController.addListener(() {

      if (!scrollController.hasClients) {
        return;
      }

      final cubit =
      context.read<MemberCubit>();

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

        cubit.getAllMembers();
      }
    });
  }

  @override
  void dispose() {

    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size =
        MediaQuery.of(context).size;

    final bool isTablet =
        size.width > 700;

    double w(double value) =>
        size.width * (value / 390);

    double h(double value) =>
        size.height * (value / 844);


    return Scaffold(

      backgroundColor:
      AppColors.background,

      body: SafeArea(
        child: Center(
          child: Container(

            constraints: BoxConstraints(
              maxWidth:
              isTablet
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

                SizedBox(height: h(18)),

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

                          border:
                          Border.all(
                            color: Colors
                                .grey
                                .shade300,
                          ),
                        ),

                        child:
                        const TextField(
                          decoration:
                          InputDecoration(
                            hintText:
                            "Search member...",

                            prefixIcon:
                            Icon(
                              Icons.search,
                            ),

                            border:
                            InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: w(12)),

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

                        border:
                        Border.all(
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

                SizedBox(height: h(18)),

                /// TABS
                Row(
                  children: [

                    _buildTab(
                      title: "All",
                      index: 0,
                      isTablet: isTablet,
                    ),

                    SizedBox(width: w(10)),

                    _buildTab(
                      title: "Active",
                      index: 1,
                      isTablet: isTablet,
                    ),

                    SizedBox(width: w(10)),

                    _buildTab(
                      title: "Inactive",
                      index: 2,
                      isTablet: isTablet,
                    ),
                  ],
                ),

                SizedBox(height: h(24)),

                /// MEMBER LIST
                Expanded(
                  child:
                  RefreshIndicator(

                    onRefresh: () async {

                      await context
                          .read<
                          MemberCubit>()
                          .refreshMembers();
                    },

                    child: BlocBuilder<
                        MemberCubit,
                        MemberState>(
                      builder:
                          (context, state) {

                        /// LOADING
                        if (state
                        is MemberLoading) {

                          return ListView
                              .separated(

                            physics:
                            const BouncingScrollPhysics(),

                            itemCount: 8,

                            separatorBuilder:
                                (_, __) =>
                                SizedBox(
                                  height:
                                  h(18),
                                ),

                            itemBuilder:
                                (
                                context,
                                index,
                                ) {

                              return _skeletonTile(
                                isTablet:
                                isTablet,
                              );
                            },
                          );
                        }

                        /// ERROR
                        if (state
                        is MemberError) {

                          return Center(
                            child: Text(
                              state
                                  .message,
                            ),
                          );
                        }

                        /// SUCCESS
                        if (state
                        is MemberLoaded) {

                          final members =
                              state.members;

                          final filteredMembers =
                          members.where((
                              member,
                              ) {

                            if (selectedTab ==
                                1) {

                              return member
                                  .memberStatus
                                  ?.toLowerCase() ==
                                  "active";
                            }

                            if (selectedTab ==
                                2) {

                              return member
                                  .memberStatus
                                  ?.toLowerCase() ==
                                  "inactive";
                            }

                            return true;

                          }).toList();

                          if (filteredMembers
                              .isEmpty) {

                            return Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                                children: const [

                                  Icon(
                                    Icons
                                        .people_outline,

                                    size: 60,

                                    color:
                                    Colors
                                        .grey,
                                  ),

                                  SizedBox(
                                    height:
                                    12,
                                  ),

                                  Text(
                                    "No Members Found",
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView
                              .separated(

                            controller:
                            scrollController,

                            physics:
                            const BouncingScrollPhysics(),

                            itemCount:
                            filteredMembers
                                .length +
                                (state
                                    .isLoadingMore
                                    ? 1
                                    : 0),

                            separatorBuilder:
                                (_, __) =>
                                SizedBox(
                                  height:
                                  h(18),
                                ),

                            itemBuilder:
                                (
                                context,
                                index,
                                ) {

                              /// PAGINATION LOADER
                              if (index ==
                                  filteredMembers
                                      .length) {

                                return const Padding(
                                  padding:
                                  EdgeInsets.all(
                                    20,
                                  ),

                                  child:
                                  Center(
                                    child:
                                    CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final member =
                              filteredMembers[
                              index];

                              return _memberTile(

                                name:
                                member
                                    .user
                                    ?.name ??
                                    "",

                                mobNo:
                                member.user?.mobNo  ??
                                    ""
                                   ,

                                status:
                                member
                                    .memberStatus ??
                                    "",

                                image:
                                member
                                    .profilePhoto ??
                                    "",

                                isTablet:
                                isTablet,
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton:
      FloatingActionButton
          .extended(

        backgroundColor:
        AppColors.primary,

        onPressed: () {},

        icon: const Icon(
          Icons.add,
        ),

        label: Text(

          "Add Member",

          style: TextStyle(
            fontSize:
            isTablet
                ? 16
                : 14,
          ),
        ),
      ),
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
                  : Colors
                  .black87,
            ),
          ),
        ),
      ),
    );
  }

  /// MEMBER TILE
  /// MEMBER TILE
  Widget _memberTile({
    required String name,
    required String mobNo,
    required String status,
    required String image,
    required bool isTablet,
  }) {

    final bool active =
        status.toLowerCase() ==
            "active";

    /// SAFE IMAGE CHECK
    final bool hasImage =
        image.trim().isNotEmpty;

    return Container(

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
          Colors.grey.shade200,
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
            Colors.grey.shade300,

            backgroundImage:
            hasImage
                ? NetworkImage(
              image,
            )
                : null,

            /// NULL SAFE
            onBackgroundImageError:
            hasImage
                ? (_, __) {}
                : null,

            child:
            !hasImage
                ? Icon(
              Icons.person,

              size:
              isTablet
                  ? 28
                  : 22,
            )
                : null,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                Text(

                  name,

                  style: TextStyle(
                    fontSize:
                    isTablet
                        ? 18
                        : 15,

                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(

                  "MobNo: $mobNo",

                  style: TextStyle(
                    fontSize:
                    isTablet
                        ? 14
                        : 12,

                    color:
                    Colors.grey
                        .shade600,
                  ),
                ),
              ],
            ),
          ),

          Container(

            padding:
            const EdgeInsets
                .symmetric(
              horizontal: 10,
              vertical: 5,
            ),

            decoration:
            BoxDecoration(

              color:
              active
                  ? Colors.green
                  .withOpacity(
                .1,
              )
                  : Colors.red
                  .withOpacity(
                .1,
              ),

              borderRadius:
              BorderRadius
                  .circular(
                10,
              ),
            ),

            child: Text(
              active
                  ? "Active"
                  : "Inactive",

              style: TextStyle(
                color:
                active
                    ? Colors
                    .green
                    : Colors.red,

                fontWeight:
                FontWeight
                    .w600,
              ),
            ),
          ),
        ],
      ),
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

        decoration: BoxDecoration(
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
                color: Colors.white,

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
}