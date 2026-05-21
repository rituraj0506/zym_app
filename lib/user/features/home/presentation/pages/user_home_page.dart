import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {

  bool get isTablet {
    final width =
        WidgetsBinding.instance.window.physicalSize.width /
            WidgetsBinding.instance.window.devicePixelRatio;

    return width > 600;
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 20,
            vertical: isTablet ? 28 : 18,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 700 : width,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// HEADER
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(
                              "Hello Rahul 👋",
                              style: TextStyle(
                                fontSize:
                                isTablet ? 38 : 30,

                                fontWeight:
                                FontWeight.w700,

                                color:
                                const Color(0xFF111827),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Ready for today's workout?",
                              style: TextStyle(
                                fontSize:
                                isTablet ? 18 : 15,

                                color:
                                const Color(0xFF6B7280),

                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: isTablet ? 62 : 52,
                        width: isTablet ? 62 : 52,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(18),

                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors.black.withOpacity(.04),

                              blurRadius: 16,
                            ),
                          ],
                        ),

                        child: Stack(
                          children: [

                            const Center(
                              child: Icon(
                                Icons.notifications_none_rounded,
                                size: 28,
                              ),
                            ),

                            Positioned(
                              right: 15,
                              top: 15,

                              child: Container(
                                height: 10,
                                width: 10,

                                decoration:
                                const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isTablet ? 36 : 28),

                  /// ATTENDANCE CARD
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(
                      isTablet ? 28 : 22,
                    ),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF22C55E),
                          Color(0xFF16A34A),
                        ],

                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),

                      borderRadius:
                      BorderRadius.circular(34),

                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF22C55E,
                          ).withOpacity(.22),

                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                          children: [

                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(
                                  "Attendance",
                                  style: TextStyle(
                                    fontSize:
                                    isTablet ? 28 : 22,

                                    fontWeight:
                                    FontWeight.w700,

                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "Your monthly progress",
                                  style: TextStyle(
                                    fontSize:
                                    isTablet ? 16 : 14,

                                    color:
                                    Colors.white70,
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),

                              decoration: BoxDecoration(
                                color:
                                Colors.white.withOpacity(.15),

                                borderRadius:
                                BorderRadius.circular(18),
                              ),

                              child: const Row(
                                children: [

                                  Text(
                                    "May",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),

                                  SizedBox(width: 6),

                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: isTablet ? 34 : 28,
                        ),

                        Row(
                          children: [

                            SizedBox(
                              height:
                              isTablet ? 150 : 120,

                              width:
                              isTablet ? 150 : 120,

                              child: Stack(
                                alignment: Alignment.center,

                                children: [

                                  SizedBox(
                                    height:
                                    isTablet ? 150 : 120,

                                    width:
                                    isTablet ? 150 : 120,

                                    child:
                                    CircularProgressIndicator(
                                      value: .80,

                                      strokeWidth:
                                      isTablet ? 14 : 11,

                                      backgroundColor:
                                      Colors.white
                                          .withOpacity(.18),

                                      valueColor:
                                      const AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  ),

                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,

                                    children: [

                                      Text(
                                        "24",
                                        style: TextStyle(
                                          fontSize:
                                          isTablet
                                              ? 42
                                              : 34,

                                          fontWeight:
                                          FontWeight.w700,

                                          color:
                                          Colors.white,
                                        ),
                                      ),

                                      const Text(
                                        "/30 Days",
                                        style: TextStyle(
                                          color:
                                          Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width:
                              isTablet ? 36 : 24,
                            ),

                            Expanded(
                              child: Column(
                                children: [

                                  attendanceTile(
                                    title: "Present",
                                    value: "24",
                                    color: Colors.white,
                                  ),

                                  SizedBox(
                                    height:
                                    isTablet ? 24 : 18,
                                  ),

                                  attendanceTile(
                                    title: "Absent",
                                    value: "6",
                                    color:
                                    Colors.red.shade100,
                                  ),

                                  SizedBox(
                                    height:
                                    isTablet ? 24 : 18,
                                  ),

                                  attendanceTile(
                                    title: "Success",
                                    value: "80%",
                                    color:
                                    Colors.yellow.shade100,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 28 : 22),

                  /// PLAN CARD
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(
                      isTablet ? 26 : 22,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(30),

                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black.withOpacity(.04),

                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [

                        Container(
                          height:
                          isTablet ? 74 : 64,

                          width:
                          isTablet ? 74 : 64,

                          decoration: BoxDecoration(
                            gradient:
                            const LinearGradient(
                              colors: [
                                Color(0xFFFFD66B),
                                Color(0xFFF59E0B),
                              ],
                            ),

                            borderRadius:
                            BorderRadius.circular(22),
                          ),

                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),

                        SizedBox(
                          width: isTablet ? 24 : 18,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(
                                "Current Plan",
                                style: TextStyle(
                                  fontSize:
                                  isTablet ? 16 : 14,

                                  color:
                                  const Color(0xFF6B7280),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Premium Membership",
                                style: TextStyle(
                                  fontSize:
                                  isTablet ? 24 : 20,

                                  fontWeight:
                                  FontWeight.w700,

                                  color:
                                  const Color(0xFF111827),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Expires on 25 May 2025",
                                style: TextStyle(
                                  fontSize:
                                  isTablet ? 15 : 13,

                                  color:
                                  Colors.orange,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 34 : 30),

                  /// QUICK ACTION
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: isTablet ? 30 : 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: isTablet ? 24 : 18),

                  LayoutBuilder(
                    builder: (context, constraints) {

                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: [

                            Expanded(
                              child: quickActionCard(
                                icon:
                                Icons.restaurant_rounded,

                                title: "Diet Plan",

                                subtitle:
                                "View your daily nutrition plan",

                                gradient: const [
                                  Color(0xFF34D399),
                                  Color(0xFF10B981),
                                ],
                              ),
                            ),

                            const SizedBox(width: 24),

                            Expanded(
                              child: quickActionCard(
                                icon:
                                Icons.fitness_center_rounded,

                                title: "Workout",

                                subtitle:
                                "Track your training routine",

                                gradient: const [
                                  Color(0xFF60A5FA),
                                  Color(0xFF2563EB),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [

                          quickActionCard(
                            icon:
                            Icons.restaurant_rounded,

                            title: "Diet Plan",

                            subtitle:
                            "View your daily nutrition plan",

                            gradient: const [
                              Color(0xFF34D399),
                              Color(0xFF10B981),
                            ],
                          ),

                          const SizedBox(height: 18),

                          quickActionCard(
                            icon:
                            Icons.fitness_center_rounded,

                            title: "Workout",

                            subtitle:
                            "Track your training routine",

                            gradient: const [
                              Color(0xFF60A5FA),
                              Color(0xFF2563EB),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: isTablet ? 50 : 34),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget attendanceTile({
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [

        Container(
          height: 12,
          width: 12,

          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),

        Text(
          value,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget quickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(32),

        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Container(
            height: 64,
            width: 64,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),

              borderRadius:
              BorderRadius.circular(20),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            title,

            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            subtitle,

            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 30),

          Align(
            alignment: Alignment.bottomRight,

            child: Container(
              height: 48,
              width: 48,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(16),
              ),

              child: Icon(
                Icons.arrow_forward_rounded,
                color: gradient.first,
              ),
            ),
          ),
        ],
      ),
    );
  }
}