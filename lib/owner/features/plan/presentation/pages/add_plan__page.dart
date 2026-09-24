import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zymmanagement/owner/features/plan/presentation/pages/plan_details_page.dart';
import 'package:zymmanagement/theme/app_colors.dart';

import '../../../../models/gym_plan_response.dart';
import '../cubit/plan_cubit.dart';
import '../cubit/plan_state.dart';
import 'package:flutter/services.dart';

class AddPlanPage extends StatefulWidget {

  final GymPlan? plan;

  const AddPlanPage({
    super.key,
    this.plan,
  });

  @override
  State<AddPlanPage> createState() =>
      _AddPlanPageState();
}

class _AddPlanPageState
    extends State<AddPlanPage> {

  bool get isEdit =>
      widget.plan != null;

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController
  planNameController =
  TextEditingController();

  final TextEditingController
  durationController =
  TextEditingController();

  final TextEditingController
  priceController =
  TextEditingController();

  final TextEditingController
  descriptionController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    if (isEdit) {

      planNameController.text =
          widget.plan?.planName ?? "";

      durationController.text =
          widget.plan?.durationInMonths
              .toString() ??
              "";

      priceController.text =
          widget.plan?.price
              .toString() ??
              "";

      descriptionController.text =
          widget.plan?.description ?? "";
    }
  }

  Future<void> submitPlan() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String planName = planNameController.text.trim();
    final String duration = durationController.text.trim();
    final String price = priceController.text.trim();
    final String description = descriptionController.text.trim();

    // Confirmation Popup to verify Month, Price, and Plan Name
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => _buildConfirmPlanDialog(
        dialogCtx: dialogCtx,
        planName: planName,
        duration: duration,
        price: price,
        description: description,
      ),
    );

    if (confirmed != true || !mounted) return;

    if (isEdit) {
      context.read<PlanCubit>().updatePlan(
        id: widget.plan?.id ?? "",
        planName: planName,
        durationInMonths: int.parse(duration),
        price: int.parse(price),
        description: description,
      );
    } else {
      context.read<PlanCubit>().createPlan(
        planName: planName,
        durationInMonths: int.parse(duration),
        price: int.parse(price),
        description: description,
      );
    }
  }

  Widget _buildConfirmPlanDialog({
    required BuildContext dialogCtx,
    required String planName,
    required String duration,
    required String price,
    required String description,
  }) {
    final width = MediaQuery.of(dialogCtx).size.width;
    final bool isTablet = width >= 700;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 60 : 20,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Icon + Header
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.assignment_turned_in_rounded,
                    size: 34,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Center(
                child: Text(
                  isEdit ? "Confirm Plan Update" : "Confirm Plan Details",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  "Please verify the plan details before proceeding.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Summary Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Plan Name
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Plan Name",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            planName,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFE2E8F0),
                      ),
                    ),

                    // Duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Duration",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "$duration Month${duration == '1' ? '' : 's'}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFE2E8F0),
                      ),
                    ),

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "₹$price",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),

                    // Description (if present)
                    if (description.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE2E8F0),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              description,
                              textAlign: TextAlign.end,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(dialogCtx, false),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Edit Details",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(dialogCtx, true),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isEdit ? "Confirm Update" : "Confirm & Save",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {

    planNameController.dispose();

    durationController.dispose();

    priceController.dispose();

    descriptionController.dispose();

    super.dispose();
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
  }) {

    return InputDecoration(

      hintText: hint,

      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
      ),

      filled: true,

      fillColor: Colors.white,

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),

        borderSide:
        BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(18),

        borderSide:
        BorderSide(
          color:
          AppColors.border,
        ),
      ),

      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(18),

        borderSide:
        const BorderSide(
          color:
          AppColors.primary,
          width: 1.4,
        ),
      ),

      errorBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(18),

        borderSide:
        const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context)
            .size
            .width;

    final bool isTablet =
        width >= 700;

    return BlocConsumer<
        PlanCubit,
        PlanState>(

      listener: (
          context,
          state,
          ) {

        /// CREATE SUCCESS
        if (state
        is PlanCreateSuccess) {

          ScaffoldMessenger.of(
              context)
              .showSnackBar(

            SnackBar(
              content:
              Text(
                state.message,
              ),
            ),
          );

          Navigator.pushReplacement(
            context,

            MaterialPageRoute(
              builder: (_) =>
              const PlanDetailsPage(),
            ),
          );
        }

        /// UPDATE SUCCESS
        if (state
        is PlanUpdateSuccess) {

          ScaffoldMessenger.of(
              context)
              .showSnackBar(

            SnackBar(
              content:
              Text(
                state.message,
              ),
            ),
          );

          Navigator.pushReplacement(
            context,

            MaterialPageRoute(
              builder: (_) =>
              const PlanDetailsPage(),
            ),
          );
        }

        /// CREATE ERROR
        if (state
        is PlanCreateError) {

          ScaffoldMessenger.of(
              context)
              .showSnackBar(

            SnackBar(
              content:
              Text(
                state.message,
              ),
            ),
          );
        }

        /// UPDATE ERROR
        if (state
        is PlanUpdateError) {

          ScaffoldMessenger.of(
              context)
              .showSnackBar(

            SnackBar(
              content:
              Text(
                state.message,
              ),
            ),
          );
        }
      },

      builder: (
          context,
          state,
          ) {

        final isLoading =

            state
            is PlanCreateLoading ||

                state
                is PlanUpdateLoading;

        return Scaffold(

          backgroundColor:
          AppColors.background,

          appBar: AppBar(

            elevation: 0,

            backgroundColor:
            AppColors.background,

            centerTitle: true,

            title: Text(

              isEdit
                  ? "Edit Plan"
                  : "Add Plan",

              style: TextStyle(
                color:
                AppColors
                    .textPrimary,

                fontWeight:
                FontWeight.bold,

                fontSize:
                isTablet
                    ? 24
                    : 20,
              ),
            ),

            iconTheme:
            const IconThemeData(
              color:
              AppColors
                  .textPrimary,
            ),
          ),

          body: SafeArea(

            child:
            SingleChildScrollView(

              padding:
              EdgeInsets.symmetric(

                horizontal:
                isTablet
                    ? 28
                    : 18,

                vertical:
                isTablet
                    ? 24
                    : 18,
              ),

              child: Form(

                key: _formKey,

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    /// TOP CARD
                    Container(

                      width:
                      double.infinity,

                      padding:
                      EdgeInsets.all(
                        isTablet
                            ? 28
                            : 22,
                      ),

                      decoration:
                      BoxDecoration(

                        borderRadius:
                        BorderRadius
                            .circular(
                          28,
                        ),

                        gradient:
                        const LinearGradient(

                          begin:
                          Alignment
                              .topLeft,

                          end:
                          Alignment
                              .bottomRight,

                          colors: [

                            Color(
                                0xFF8B5CF6),

                            Color(
                                0xFF6D28D9),
                          ],
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                            AppColors
                                .primary
                                .withOpacity(
                                .25),

                            blurRadius:
                            22,

                            offset:
                            const Offset(
                                0,
                                8),
                          ),
                        ],
                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Container(

                            padding:
                            const EdgeInsets
                                .all(
                              14,
                            ),

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.white
                                  .withOpacity(
                                  .15),

                              borderRadius:
                              BorderRadius
                                  .circular(
                                  18),
                            ),

                            child:
                            const Icon(

                              Icons
                                  .workspace_premium,

                              color:
                              Colors
                                  .white,

                              size:
                              34,
                            ),
                          ),

                          SizedBox(
                            height:
                            isTablet
                                ? 20
                                : 16,
                          ),

                          Text(

                            isEdit
                                ? "Update Gym Membership Plan"
                                : "Create Gym Membership Plan",

                            style:
                            TextStyle(

                              color:
                              Colors
                                  .white,

                              fontWeight:
                              FontWeight
                                  .bold,

                              fontSize:
                              isTablet
                                  ? 28
                                  : 22,
                            ),
                          ),

                          const SizedBox(
                              height:
                              8),

                          Text(

                            "Add flexible membership plans for your gym members.",

                            style:
                            TextStyle(

                              color:
                              Colors
                                  .white
                                  .withOpacity(
                                  .9),

                              fontSize:
                              isTablet
                                  ? 16
                                  : 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height:
                      isTablet
                          ? 32
                          : 26,
                    ),

                    /// PLAN NAME
                    buildLabel(
                        "Plan Name"),

                    const SizedBox(
                        height: 10),

                    TextFormField(

                      controller:
                      planNameController,

                      decoration:
                      inputDecoration(

                        hint:
                        "Enter plan name",

                        icon:
                        Icons
                            .card_membership,
                      ),

                      validator:
                          (value) {

                        if (value ==
                            null ||
                            value
                                .trim()
                                .isEmpty) {

                          return "Please enter plan name";
                        }

                        return null;
                      },
                    ),

                    SizedBox(
                      height:
                      isTablet
                          ? 24
                          : 20,
                    ),

                    /// DURATION
                    buildLabel(
                        "Duration (Months)"),

                    const SizedBox(
                        height: 10),

                    // TextFormField(
                    //
                    //   controller:
                    //   durationController,
                    //
                    //   keyboardType:
                    //   TextInputType
                    //       .number,
                    //
                    //   decoration:
                    //   inputDecoration(
                    //
                    //     hint:
                    //     "Enter duration",
                    //
                    //     icon:
                    //     Icons
                    //         .calendar_month,
                    //   ),
                    //
                    //   validator:
                    //       (value) {
                    //
                    //     if (value ==
                    //         null ||
                    //         value
                    //             .trim()
                    //             .isEmpty) {
                    //
                    //       return "Please enter duration";
                    //     }
                    //
                    //     return null;
                    //   },
                    // ),

                    TextFormField(
                      controller: durationController,
                      keyboardType: TextInputType.number,

                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction(
                              (oldValue, newValue) {
                            if (newValue.text.isEmpty) {
                              return newValue;
                            }

                            final value = int.tryParse(newValue.text);

                            if (value != null && value <= 12) {
                              return newValue;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Duration cannot be more than 12 months",
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );

                            return oldValue;
                          },
                        ),
                      ],

                      decoration: inputDecoration(
                        hint: "Enter duration",
                        icon: Icons.calendar_month,
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter duration";
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height:
                      isTablet
                          ? 24
                          : 20,
                    ),

                    /// PRICE
                    buildLabel("Price"),

                    const SizedBox(
                        height: 10),

                    TextFormField(

                      controller:
                      priceController,

                      keyboardType:
                      TextInputType
                          .number,

                      decoration:
                      inputDecoration(

                        hint:
                        "Enter price",

                        icon:
                        Icons
                            .currency_rupee,
                      ),

                      validator:
                          (value) {

                        if (value ==
                            null ||
                            value
                                .trim()
                                .isEmpty) {

                          return "Please enter price";
                        }

                        return null;
                      },
                    ),

                    SizedBox(
                      height:
                      isTablet
                          ? 24
                          : 20,
                    ),

                    /// DESCRIPTION
                    buildLabel(
                        "Description (Optional)"),

                    const SizedBox(
                        height: 10),

                    TextFormField(

                      controller:
                      descriptionController,

                      maxLines: 4,

                      decoration:
                      inputDecoration(

                        hint:
                        "Enter description",

                        icon:
                        Icons
                            .description_outlined,
                      ),
                    ),

                    SizedBox(
                      height:
                      isTablet
                          ? 40
                          : 32,
                    ),

                    /// BUTTON
                    SizedBox(

                      width:
                      double.infinity,

                      height:
                      isTablet
                          ? 64
                          : 58,

                      child:
                      ElevatedButton(

                        onPressed:
                        isLoading
                            ? null
                            : submitPlan,

                        style:
                        ElevatedButton
                            .styleFrom(

                          backgroundColor:
                          AppColors
                              .primary,

                          elevation:
                          0,

                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius
                                .circular(
                              18,
                            ),
                          ),
                        ),

                        child:
                        isLoading

                            ? const SizedBox(

                          height:
                          24,

                          width:
                          24,

                          child:
                          CircularProgressIndicator(

                            color:
                            Colors
                                .white,

                            strokeWidth:
                            2.5,
                          ),
                        )

                            : Text(

                          isEdit
                              ? "Update Plan"
                              : "Add Plan",

                          style:
                          TextStyle(

                            fontSize:
                            isTablet
                                ? 18
                                : 16,

                            fontWeight:
                            FontWeight
                                .bold,

                            color:
                            Colors
                                .white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildLabel(
      String title) {

    return Text(

      title,

      style: const TextStyle(

        fontSize: 15,

        fontWeight:
        FontWeight.w600,

        color:
        AppColors.textPrimary,
      ),
    );
  }
}