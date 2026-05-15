import 'package:flutter/material.dart';
import 'package:zymmanagement/owner/features/plan/presentation/pages/plan_details_page.dart';
import 'package:zymmanagement/theme/app_colors.dart';

class AddPlanPage extends StatefulWidget {
  const AddPlanPage({super.key});

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController planNameController =
  TextEditingController();

  final TextEditingController durationController =
  TextEditingController();

  final TextEditingController priceController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  bool isLoading = false;

  Future<void> submitPlan() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    final body = {
      "planName": planNameController.text.trim(),
      "durationInMonths": int.parse(
        durationController.text.trim(),
      ),
      "price": int.parse(
        priceController.text.trim(),
      ),
      "description":
      descriptionController.text.trim(),
    };

    debugPrint(body.toString());

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Plan Added Successfully"),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const PlanDetailsPage(),
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
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColors.border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.4,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final bool isTablet = width >= 700;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: true,

        title: Text(
          "Add Plan",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 24 : 20,
          ),
        ),

        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 28 : 18,
            vertical: isTablet ? 24 : 18,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                /// TOP CARD
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(
                    isTablet ? 28 : 22,
                  ),

                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                      28,
                    ),

                    gradient:
                    const LinearGradient(
                      begin: Alignment.topLeft,
                      end:
                      Alignment.bottomRight,

                      colors: [
                        Color(0xFF8B5CF6),
                        Color(0xFF6D28D9),
                      ],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary
                            .withOpacity(.25),
                        blurRadius: 22,
                        offset:
                        const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Container(
                        padding:
                        const EdgeInsets.all(
                          14,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(.15),
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: const Icon(
                          Icons.workspace_premium,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),

                      SizedBox(
                        height:
                        isTablet ? 20 : 16,
                      ),

                      Text(
                        "Create Gym Membership Plan",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize:
                          isTablet
                              ? 28
                              : 22,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Add flexible membership plans for your gym members.",

                        style: TextStyle(
                          color: Colors.white
                              .withOpacity(.9),

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
                  height: isTablet ? 32 : 26,
                ),

                /// PLAN NAME
                buildLabel("Plan Name"),

                const SizedBox(height: 10),

                TextFormField(
                  controller:
                  planNameController,

                  decoration:
                  inputDecoration(
                    hint:
                    "Enter plan name",
                    icon:
                    Icons.card_membership,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Please enter plan name";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: isTablet ? 24 : 20,
                ),

                /// DURATION
                buildLabel("Duration (Months)"),

                const SizedBox(height: 10),

                TextFormField(
                  controller:
                  durationController,

                  keyboardType:
                  TextInputType.number,

                  decoration:
                  inputDecoration(
                    hint:
                    "Enter duration",
                    icon:
                    Icons.calendar_month,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Please enter duration";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: isTablet ? 24 : 20,
                ),

                /// PRICE
                buildLabel("Price"),

                const SizedBox(height: 10),

                TextFormField(
                  controller:
                  priceController,

                  keyboardType:
                  TextInputType.number,

                  decoration:
                  inputDecoration(
                    hint: "Enter price",
                    icon:
                    Icons.currency_rupee,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Please enter price";
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: isTablet ? 24 : 20,
                ),

                /// DESCRIPTION
                buildLabel(
                  "Description (Optional)",
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller:
                  descriptionController,

                  maxLines: 4,

                  decoration:
                  inputDecoration(
                    hint:
                    "Enter description",
                    icon:
                    Icons.description_outlined,
                  ),
                ),

                SizedBox(
                  height: isTablet ? 40 : 32,
                ),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height:
                  isTablet ? 64 : 58,

                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : submitPlan,

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.primary,

                      elevation: 0,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          18,
                        ),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,

                      child:
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Text(
                      "Add Plan",
                      style: TextStyle(
                        fontSize:
                        isTablet
                            ? 18
                            : 16,

                        fontWeight:
                        FontWeight.bold,

                        color:
                        Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String title) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}