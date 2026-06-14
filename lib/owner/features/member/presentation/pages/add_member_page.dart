import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../models/gym_plan_response.dart';
import '../../../plan/presentation/cubit/plan_cubit.dart';
import '../../../plan/presentation/cubit/plan_state.dart';
import '../cubit/member_cubit.dart';
import '../cubit/member_state.dart';
import 'member_details_page.dart';
import '../../../../../owner/models/member_response.dart';


class AddMemberPage extends StatefulWidget {

  final MemberData? member;

  const AddMemberPage({
    super.key,
    this.member,
  });

  @override
  State<AddMemberPage> createState() =>
      _AddMemberPageState();
}

class _AddMemberPageState
    extends State<AddMemberPage> {

  bool get isEdit =>
      widget.member != null;

  String selectedPaymentMode = "cash";

  /// FORM KEY
  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  /// CONTROLLERS
  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController mobileController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController ageController =
  TextEditingController();

  final TextEditingController aadhaarController =
  TextEditingController();

  final TextEditingController addressController =
  TextEditingController();

  /// IMAGE
  File? profileImage;

  /// PLAN
  String? selectedPlanId;

  String? selectedPlanName;



  List<GymPlan> plans = [];

  bool obscurePassword = true;


  @override
  void initState() {
    super.initState();

    context.read<PlanCubit>().getAllPlans();

    if (widget.member != null) {

      nameController.text =
          widget.member!.user?.name?? "";

      emailController.text =
          widget.member!.user?.email ?? "";

      mobileController.text =
          widget.member!.mobNo ?? "";

      ageController.text =
          widget.member!.age?.toString() ?? "";

      aadhaarController.text =
          widget.member!.aadhaarNo ?? "";



      selectedPlanId =
          widget.member!.plan?.id;

      selectedPlanName =
          widget.member!.plan?.planName;

      widget.member?.profilePhoto;
    }
  }


  bool get canEditPlan {

    if (!isEdit) return true;

    final createdAt = widget.member?.createdAt;

    if (createdAt == null) {
      return false;
    }

    final diff =
    DateTime.now().difference(createdAt);

    return diff.inHours <= 24;
  }

  /// PICK IMAGE
  Future<void> pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bool isTablet = size.width > 700;

    double h(double value) =>
        size.height * (value / 844);

    return BlocListener<MemberCubit, MemberState>(
      listener: (context, state) {
        if (state is AddMemberSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );

          Navigator.pushReplacement(

            context,

            MaterialPageRoute(
              builder:
                  (_) =>
              const MemberDetailsPage(),
            ),
          );
        }

        if (state is MemberError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },

      child: Scaffold(
        backgroundColor:
        AppColors.background,

        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor:
          AppColors.background,

          title: Text(
            isEdit
                ? "Edit Member"
                : "Add New Member",

            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 40 : 20,
              vertical: 20,
            ),

            child: Form(
              key: formKey,

              child: Column(
                children: [
                  /// PROFILE IMAGE
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          height: h(110),
                          width: h(110),

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,

                            image: profileImage != null
                                ? DecorationImage(
                              image: FileImage(profileImage!),
                              fit: BoxFit.cover,
                            )
                                : widget.member?.profilePhoto != null
                                ? DecorationImage(
                              image: NetworkImage(
                                widget.member!.profilePhoto!,
                              ),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),

                          child: profileImage == null &&
                              widget.member?.profilePhoto == null
                              ? Icon(
                            Icons.person,
                            size: h(55),
                            color: Colors.grey,
                          )
                              : null,
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,

                          child: GestureDetector(
                            onTap: pickImage,

                            child: Container(
                              height: h(36),
                              width: h(36),

                              decoration:
                              const BoxDecoration(
                                color:
                                AppColors
                                    .primary,
                                shape:
                                BoxShape
                                    .circle,
                              ),

                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h(30)),

                  /// NAME
                  customTextField(
                    controller:
                    nameController,
                    hint: "Full Name",

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Name is required";
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: h(16)),

                  /// EMAIL
                  customTextField(
                    controller:
                    emailController,
                    hint: "Email Address",

                    keyboardType:
                    TextInputType
                        .emailAddress,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Email is required";
                      }

                      if (!value.contains("@")) {
                        return "Enter valid email";
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: h(16)),

                  /// MOBILE
                  customTextField(
                    controller:
                    mobileController,
                    hint: "Mobile Number",

                    keyboardType:
                    TextInputType.phone,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Mobile number is required";
                      }

                      if (value.length != 10) {
                        return "Enter valid mobile number";
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: h(16)),

                  /// PASSWORD
           if (!isEdit) ...[
                  TextFormField(
                    controller: passwordController,

                    obscureText: obscurePassword,

                    validator: (value) {

                      if (value == null ||
                          value.trim().isEmpty) {

                        return "Password is required";
                      }

                      if (value.length < 6) {
                        return "Minimum 6 characters";
                      }

                      return null;
                    },

                    decoration: InputDecoration(

                      hintText: "Password",

                      filled: true,
                      fillColor: Colors.white,

                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),

                      suffixIcon: IconButton(

                        onPressed: () {

                          setState(() {

                            obscurePassword =
                            !obscurePassword;
                          });
                        },

                        icon: Icon(

                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),

                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),

                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),

                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h(16)),

                  ],

                  /// AGE
                  customTextField(
                    controller:
                    ageController,
                    hint: "Age",

                    keyboardType:
                    TextInputType.number,
                  ),

                  SizedBox(height: h(16)),

                  /// AADHAAR
                  customTextField(
                    controller:
                    aadhaarController,
                    hint: "Aadhaar Number",

                    keyboardType:
                    TextInputType.number,
                  ),

                  SizedBox(height: h(16)),


                  /// ADDRESS
        if (!isEdit) ...[
                  customTextField(
                    controller:
                    addressController,
                    hint: "Address",
                    maxLines: 3,
                  ),

                  ],

                  SizedBox(height: h(16)),

                  // Plan dropdown
                  if (!isEdit) ...[
                    DropdownButtonFormField<String>(
                      value: selectedPaymentMode,
                      decoration: InputDecoration(
                        hintText: "Payment Mode",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "cash",
                          child: Text("Cash"),
                        ),
                        DropdownMenuItem(
                          value: "upi",
                          child: Text("UPI"),
                        ),
                        DropdownMenuItem(
                          value: "bank",
                          child: Text("Bank Transfer"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMode = value!;
                        });
                      },
                    ),

                    SizedBox(height: h(16)),
                  ],

                  /// PLAN DROPDOWN
                  BlocBuilder<
                      PlanCubit,
                      PlanState
                  >(
                    builder: (context, state) {

                      /// LOADING
                      if (state
                      is PlanDetailsLoading) {
                        return const Center(
                          child:
                          CircularProgressIndicator(),
                        );
                      }

                      /// SUCCESS
                      // if (state
                      // is PlanDetailsLoaded) {
                      //     plans = state.plans.data ?? [];
                      //
                      //   return DropdownButtonFormField<
                      //       String
                      //   >(
                      //     value:
                      //     selectedPlanId,
                      //
                      //     decoration:
                      //     InputDecoration(
                      //       hintText:
                      //       "Select Plan",
                      //
                      //       filled: true,
                      //       fillColor:
                      //       Colors.white,
                      //
                      //       border: OutlineInputBorder(
                      //         borderRadius:
                      //         BorderRadius.circular(
                      //           14,
                      //         ),
                      //       ),
                      //
                      //       enabledBorder: OutlineInputBorder(
                      //         borderRadius:
                      //         BorderRadius.circular(
                      //           14,
                      //         ),
                      //
                      //         borderSide: BorderSide(
                      //           color:
                      //           Colors
                      //               .grey
                      //               .shade300,
                      //         ),
                      //       ),
                      //
                      //       focusedBorder: OutlineInputBorder(
                      //         borderRadius:
                      //         BorderRadius.circular(
                      //           14,
                      //         ),
                      //
                      //         borderSide: const BorderSide(
                      //           color:
                      //           AppColors
                      //               .primary,
                      //           width:
                      //           1.5,
                      //         ),
                      //       ),
                      //     ),
                      //
                      //     items:
                      //     plans.map((
                      //         plan,
                      //         ) {
                      //       return DropdownMenuItem<
                      //           String
                      //       >(
                      //         value:
                      //         plan.id,
                      //
                      //         child: Text(
                      //           plan.planName ??
                      //               "",
                      //         ),
                      //       );
                      //     }).toList(),
                      //
                      //     onChanged: (
                      //         value,
                      //         ) {
                      //       final selectedPlan =
                      //       plans.firstWhere(
                      //             (
                      //             e,
                      //             ) =>
                      //         e.id ==
                      //             value,
                      //       );
                      //
                      //       setState(() {
                      //         selectedPlanId =
                      //             selectedPlan
                      //                 .id;
                      //
                      //         selectedPlanName =
                      //             selectedPlan
                      //                 .planName;
                      //       });
                      //     },
                      //
                      //     validator: (
                      //         value,
                      //         ) {
                      //       if (value ==
                      //           null) {
                      //         return "Please select plan";
                      //       }
                      //
                      //       return null;
                      //     },
                      //   );
                      // }

                      if (state is PlanDetailsLoaded) {

                        plans = state.plans.data ?? [];

                        if (isEdit && !canEditPlan) {

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                              BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              selectedPlanName ?? "No Plan",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }

                        return DropdownButtonFormField<String>(
                          value: selectedPlanId,

                          decoration: InputDecoration(
                            hintText: "Select Plan",
                            filled: true,
                            fillColor: Colors.white,

                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                          ),

                          items: plans.map((plan) {
                            return DropdownMenuItem<String>(
                              value: plan.id,
                              child: Text(
                                plan.planName ?? "",
                              ),
                            );
                          }).toList(),

                          onChanged: (value) {

                            final selectedPlan =
                            plans.firstWhere(
                                  (e) => e.id == value,
                            );

                            setState(() {
                              selectedPlanId =
                                  selectedPlan.id;

                              selectedPlanName =
                                  selectedPlan.planName;
                            });
                          },

                          validator: (value) {

                            if (value == null) {
                              return "Please select plan";
                            }

                            return null;
                          },
                        );
                      }

                      /// ERROR
                      if (state
                      is PlanDetailsError) {
                        return Text(
                          state.message,
                        );
                      }

                      return const SizedBox();
                    },
                  ),



                  SizedBox(height: h(35)),

                  /// BUTTON
                  BlocBuilder<
                      MemberCubit,
                      MemberState
                  >(
                    builder: (context, state) {

                      final bool isLoading =
                      state
                      is AddMemberLoading;

                      return SizedBox(
                        width: double.infinity,
                        height: h(55),

                        child: ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            AppColors
                                .primary,

                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),

                          onPressed:
                          isLoading
                              ? null
                              : () {

                            if (formKey
                                .currentState!
                                .validate()) {
                              if (isEdit) {
                                context
                                    .read<MemberCubit>()
                                    .updateMember(

                                  memberId:
                                  widget.member!.id!,

                                  name:
                                  nameController.text.trim(),

                                  age:
                                  ageController.text.trim(),

                                  mobNo:
                                  mobileController.text.trim(),

                                  aadhaarNo:
                                  aadhaarController.text.trim(),

                                  email:
                                  emailController.text.trim(),

                                  planId:
                                  selectedPlanId ?? "",

                                  profilePhoto:
                                  profileImage,
                                );
                              }
                              else {
                                context
                                    .read<MemberCubit>()
                                    .addMember(

                                  name:
                                  nameController.text.trim(),

                                  age:
                                  ageController.text.trim(),

                                  mobNo:
                                  mobileController.text.trim(),

                                  aadhaarNo:
                                  aadhaarController.text.trim(),

                                  email:
                                  emailController.text.trim(),

                                  password:
                                  passwordController.text.trim(),

                                  planId:
                                  selectedPlanId ?? "",

                                  paymentMode:
                                  selectedPaymentMode,

                                  profilePhoto:
                                  profileImage,
                                );
                              }
                            }

                          },
                          child:
                          isLoading
                              ? const CircularProgressIndicator(
                            color:
                            Colors
                                .white,
                          )
                              :  Text(
                            isEdit
                                ? "Update Member"
                                : "Save Member",

                            style: TextStyle(
                              fontSize:
                              16,
                              fontWeight:
                              FontWeight
                                  .w700,
                              color:
                              Colors
                                  .white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// CUSTOM TEXTFIELD
  Widget customTextField({
    required TextEditingController
    controller,

    required String hint,

    TextInputType? keyboardType,

    bool obscureText = false,

    int maxLines = 1,

    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,

      keyboardType: keyboardType,

      obscureText: obscureText,

      maxLines: maxLines,

      validator: validator,

      decoration: InputDecoration(
        hintText: hint,

        filled: true,
        fillColor: Colors.white,

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),

          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),

          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(14),

          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }




}