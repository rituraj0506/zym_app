import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zymmanagement/theme/app_colors.dart';
import 'package:zymmanagement/utils/image_helper.dart';
import '../../../home/presentation/cubit/owner_dashboard_cubit.dart';
import '../cubit/gym_profile_cubit.dart';
import '../cubit/gym_profile_state.dart';

class CreateGymProfilePage extends StatefulWidget {
  const CreateGymProfilePage({super.key});

  @override
  State<CreateGymProfilePage> createState() =>
      _CreateGymProfilePageState();
}

class _CreateGymProfilePageState
    extends State<CreateGymProfilePage> {
  final formKey = GlobalKey<FormState>();

  final gymNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final descriptionController = TextEditingController();
  final openingTimeController = TextEditingController();
  final closingTimeController = TextEditingController();

  File? selectedImage;

  Future<void> pickImage() async {
    final source = await ImageHelper.showImageSourceDialog(
      context,
      maxSizeInKb: 200,
      title: "Select Gym Photo",
    );
    if (source == null || !mounted) return;

    final processed = await ImageHelper.pickCropAndCompressImage(
      context: context,
      source: source,
      maxSizeInKb: 200,
      cropTitle: 'Crop Gym Photo',
    );

    if (processed != null && mounted) {
      final bytes = await processed.length();
      if (!mounted) return;
      if (bytes > 200 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image size exceeds 200 KB limit. Please select a smaller photo."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        selectedImage = processed;
      });
    }
  }

  Future<void> pickTime(
      TextEditingController controller,
      ) async {
    final TimeOfDay? pickedTime =
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final hour =
      pickedTime.hourOfPeriod == 0
          ? 12
          : pickedTime.hourOfPeriod;

      final minute = pickedTime.minute
          .toString()
          .padLeft(2, '0');

      final period =
      pickedTime.period == DayPeriod.am
          ? "AM"
          : "PM";

      controller.text =
      "$hour:$minute $period";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Create Gym Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: BlocConsumer<
          GymProfileCubit,
          GymProfileState>(
        listener: (context, state) {
          if (state is GymProfileSuccess) {
            context
                .read<OwnerDashboardCubit>()
                .getDashboardData();

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );

            Navigator.pop(context);
          }

          if (state is GymProfileError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },

        builder: (context, state) {
          return SingleChildScrollView(
            padding:
            const EdgeInsets.all(18),

            child: Form(
              key: formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  /// TOP CARD
                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      gradient:
                      const LinearGradient(
                        colors: [
                          Color(0xFF8B5CF6),
                          Color(0xFF6D28D9),
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                          28),

                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .deepPurple
                              .withOpacity(.18),
                          blurRadius: 20,
                          offset:
                          const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: pickImage,

                          child: Stack(
                            alignment: Alignment
                                .bottomRight,

                            children: [
                              Container(
                                padding:
                                const EdgeInsets
                                    .all(4),

                                decoration:
                                BoxDecoration(
                                  shape:
                                  BoxShape.circle,

                                  border: Border.all(
                                    color:
                                    Colors.white,
                                    width: 3,
                                  ),
                                ),

                                child: CircleAvatar(
                                  radius: 58,
                                  backgroundColor:
                                  Colors.white,

                                  backgroundImage:
                                  selectedImage !=
                                      null
                                      ? FileImage(
                                    selectedImage!,
                                  )
                                      : null,

                                  child:
                                  selectedImage ==
                                      null
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,

                                    children: const [
                                      Icon(
                                        Icons
                                            .cloud_upload_rounded,
                                        size:
                                        34,
                                        color:
                                        Colors.deepPurple,
                                      ),

                                      SizedBox(
                                          height:
                                          6),

                                      Text(
                                        "Upload",
                                        style:
                                        TextStyle(
                                          fontSize:
                                          12,
                                          fontWeight:
                                          FontWeight.w600,
                                          color:
                                          Colors.deepPurple,
                                        ),
                                      ),
                                    ],
                                  )
                                      : null,
                                ),
                              ),

                              Container(
                                padding:
                                const EdgeInsets
                                    .all(8),

                                decoration:
                                const BoxDecoration(
                                  color:
                                  Colors.white,
                                  shape:
                                  BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors
                                      .deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          "Upload Gym Logo / Photo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Tap image to upload your gym profile picture",
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Max 200 KB • Auto-compressed",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Gym Information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  buildField(
                    controller:
                    gymNameController,
                    hint: "Gym Name",
                    icon:
                    Icons.fitness_center,
                  ),

                  buildField(
                    controller:
                    addressController,
                    hint: "Address",
                    icon: Icons
                        .location_on_outlined,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: buildField(
                          controller:
                          cityController,
                          hint: "City",
                          icon: Icons
                              .location_city,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: buildField(
                          controller:
                          stateController,
                          hint: "State",
                          icon:
                          Icons.map_outlined,
                        ),
                      ),
                    ],
                  ),

                  buildField(
                    controller:
                    pincodeController,
                    hint: "Pincode",
                    icon: Icons
                        .pin_drop_outlined,
                    keyboardType:
                    TextInputType.number,
                  ),

                  buildField(
                    controller:
                    descriptionController,
                    hint: "Description",
                    icon: Icons
                        .description_outlined,
                    maxLines: 4,
                    isRequired: false,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: buildField(
                          controller:
                          openingTimeController,
                          hint:
                          "Opening Time",
                          icon:
                          Icons.access_time,
                          readOnly: true,

                          onTap: () {
                            pickTime(
                              openingTimeController,
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: buildField(
                          controller:
                          closingTimeController,
                          hint:
                          "Closing Time",
                          icon: Icons
                              .access_time_filled,
                          readOnly: true,

                          onTap: () {
                            pickTime(
                              closingTimeController,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 58,

                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey
                            .currentState!
                            .validate()) {
                          context
                              .read<
                              GymProfileCubit>()
                              .createGymProfile(
                            gymName:
                            gymNameController
                                .text,

                            address:
                            addressController
                                .text,

                            city:
                            cityController
                                .text,

                            stateName:
                            stateController
                                .text,

                            pincode:
                            pincodeController
                                .text,

                            description:
                            descriptionController
                                .text,

                            openingTime:
                            openingTimeController
                                .text,

                            closingTime:
                            closingTimeController
                                .text,

                            image:
                            selectedImage,
                          );
                        }
                      },

                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.primary,
                        elevation: 0,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(18),
                        ),
                      ),

                      child: state
                      is GymProfileCreateLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,

                        child:
                        CircularProgressIndicator(
                          color:
                          Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        "Create Gym",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildField({
    required TextEditingController
    controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isRequired = true,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,

        validator: (value) {
          if (isRequired &&
              (value == null ||
                  value.isEmpty)) {
            return "Required";
          }

          return null;
        },

        decoration: InputDecoration(
          hintText: hint,

          prefixIcon: Icon(
            icon,
            color: Colors.deepPurple,
          ),

          filled: true,
          fillColor: Colors.white,

          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 18,
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
              color: Colors.grey.shade200,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(18),

            borderSide: BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}