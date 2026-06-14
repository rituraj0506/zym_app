import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/transaction_history_response.dart';
import '../../cubit/transaction_details_cubit.dart';
import '../../cubit/transaction_details_state.dart';
import 'package:intl/intl.dart';

class TransactionDetailsPage extends StatefulWidget {
  const TransactionDetailsPage({super.key});

  @override
  State<TransactionDetailsPage> createState() =>
      _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {

  final TextEditingController searchController =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();




  @override
  void initState() {
    super.initState();

    final cubit =
    context.read<TransactionDetailsCubit>();

    cubit.fetchTransactionDetails();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        cubit.loadMore();
      }
    });
  }


  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      body: BlocBuilder<
          TransactionDetailsCubit,
          TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TransactionError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is TransactionLoaded) {
            final transactions =
                state.transactionHistory.data ?? [];

            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet =
                      constraints.maxWidth > 700;

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<
                          TransactionDetailsCubit>()
                          .refresh();
                    },
                    child: Column(
                      children: [
                        _buildAppBar(),
                        Expanded(
                          child: ListView.builder(
                            controller:
                            _scrollController,
                            padding:
                            const EdgeInsets.all(
                                16),
                            itemCount:
                            transactions.length +
                                3,
                            itemBuilder:
                                (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    _buildStatsSection(
                                      isTablet,
                                      state,
                                    ),
                                    const SizedBox(
                                        height: 16),
                                  ],
                                );
                              }

                              if (index == 1) {
                                return _buildPaymentsHeader(
                                  transactions.length,
                                );
                              }

                              if (index == transactions.length + 2) {
                                final cubit =
                                context.read<TransactionDetailsCubit>();

                                if (cubit.isLoadingMore) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                return const SizedBox(height: 20);
                              }

                              final payment =
                              transactions[
                              index - 2];

                              return Padding(
                                padding:
                                const EdgeInsets.only(
                                  top: 12,
                                ),
                                child: PaymentTile(
                                  payment:
                                  payment,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xffEAEAEA),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 8),
          const Text(
            "Payments",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildStatsSection(
      bool isTablet,
      TransactionLoaded state,
      ) {
    final cards = [
      _StatCard(
        title: "Total Payments",
        value:
        "${state.transactionHistory.pagination?.totalPayments ?? 0}",
        subtitle: "All Time",
        color: const Color(0xff6A3DE8),
        icon: Icons.receipt_long,
      ),
      _StatCard(
        title: "Total Collection",
        value:
        "₹ ${state.monthlyCollection.totalCollection ?? 0}",
        subtitle: "This Month",
        color: const Color(0xff2DBA4E),
        icon: Icons.account_balance_wallet,
      ),
      _StatCard(
        title: "Today Collection",
        value:
        "₹ ${state.todayCollection.totalCollection ?? 0}",
        subtitle: "Today",
        color: const Color(0xff4B7BEA),
        icon: Icons.calendar_month,
      ),
    ];

    if (isTablet) {
      return Row(
        children: cards
            .map(
              (e) => Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 6),
              child: e,
            ),
          ),
        )
            .toList(),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: cards.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * .35,
            child: cards[index],
          );
        },
      ),
    );
  }


  Widget _buildPaymentsHeader(
      int totalPayments,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Text(
            "Recent Payments",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            "$totalPayments Payments",
          ),
        ],
      ),
    );
  }

}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
            color.withOpacity(.12),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 8,
                      color:
                      Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                      Colors.grey.shade600,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PaymentTile extends StatelessWidget {
  final TransactionData payment;

  const PaymentTile({
    super.key,
    required this.payment,
  });

  String get initials {
    final name =
        payment.member?.name ?? "";

    // final parts = name.split(" ");

    final parts =
    name.trim().split(RegExp(r'\s+'));

    if (parts.length > 1) {
      return "${parts[0][0]}${parts[1][0]}"
          .toUpperCase();
    }

    return name.isNotEmpty
        ? name[0].toUpperCase()
        : "?";
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(initials),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  payment.member?.name ?? "",
                  style: const TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "${payment.plan?.planName ?? ""} • ${payment.paymentType ?? ""}",
                  style: TextStyle(
                    color:
                    Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  payment.paidDate != null
                      ? DateFormat(
                    "dd MMM yyyy • hh:mm a",
                  ).format(
                    payment.paidDate!,
                  )
                      : "",
                  style: TextStyle(
                    color:
                    Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Text(
                "₹${payment.amount ?? 0}",
                style: const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                (payment.paymentMode ?? "")
                    .toUpperCase(),
                style: TextStyle(
                  color: modeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.chevron_right,
          ),
        ],
      ),
    );
  }



  Color get modeColor {
    switch ((payment.paymentMode ?? "")
        .toLowerCase()) {
      case "cash":
        return Colors.green;

      case "upi":
        return Colors.orange;

      case "bank":
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }


}

