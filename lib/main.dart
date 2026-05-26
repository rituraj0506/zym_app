import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zymmanagement/login_screen.dart';
import 'package:zymmanagement/owner/dashboard_screen.dart';
import 'package:zymmanagement/owner/features/attendance/presentation/cubit/attendance_by_date_cubit.dart';
import 'package:zymmanagement/owner/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:zymmanagement/owner/features/expiredplan/presentation/cubit/expired_plan_cubit.dart';
import 'package:zymmanagement/owner/features/qr/presentation/cubit/scan_qr_cubit.dart';
import 'package:zymmanagement/splash_screen.dart';
import 'package:zymmanagement/theme/app_theme.dart';
import 'package:zymmanagement/user/dashboard_container.dart';
import 'package:zymmanagement/user/features/home/presentation/cubit/user_dashboard_cubit.dart';
import 'package:zymmanagement/user/features/profile/presentation/cubit/user_profile_cubit.dart';
import 'owner/features/home/presentation/cubit/owner_dashboard_cubit.dart';
import 'owner/features/home/presentation/pages/owner_dashboard_page.dart';
import 'owner/features/member/presentation/cubit/active_member_cubit.dart';
import 'owner/features/member/presentation/cubit/inactive_member_cubit.dart';
import 'owner/features/member/presentation/cubit/member_cubit.dart';
import 'owner/features/plan/presentation/cubit/plan_cubit.dart';
import 'owner/features/profile/presentation/cubit/gym_profile_cubit.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(

      providers: [

        BlocProvider(
          create: (_) =>
              OwnerDashboardCubit(),
        ),

        BlocProvider(
          create: (_) => UserDashboardCubit(),
        ),

        BlocProvider(
          create: (_) =>
              GymProfileCubit(),
        ),

        BlocProvider(
          create: (_) => PlanCubit(),
        ),

        BlocProvider(
          create: (_) => MemberCubit(),
      ),

        BlocProvider(
          create: (_) => ActiveMemberCubit(),
        ),

        BlocProvider(
          create: (_) => InActiveMemberCubit(),
        ),

        BlocProvider(
          create: (_) => UserProfileCubit(),
        ),

        BlocProvider(
          create: (_) => ScanQrCubit(),
        ),

        BlocProvider(
          create: (_) => AttendanceCubit(),
        ),

        BlocProvider(
          create: (_) => ExpiredPlanCubit(),
        ),

        BlocProvider(
          create: (_) => AttendanceByDateCubit(),
        ),
      ],

      child: MaterialApp(

        debugShowCheckedModeBanner:
        false,

        theme: AppTheme.lightTheme,

        initialRoute: '/splash',

        routes: {

          '/splash': (context) =>
          const SplashScreen(),

          '/login': (context) =>
          const LoginScreen(),

          '/dashboardScreen':
              (context) =>
              DashboardScreen(),

          '/ownerDashboard':
              (context) =>
              OwnerDashboardPage(),

          // User
          '/dashboardContainer':
              (context) =>
              DashboardContainer(),
        },
      ),
    );
  }
}