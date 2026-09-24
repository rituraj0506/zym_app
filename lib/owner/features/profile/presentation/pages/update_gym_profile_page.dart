import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../utils/image_helper.dart';
import '../cubit/gym_profile_cubit.dart';
import '../cubit/gym_profile_state.dart';

class UpdateGymProfilePage extends StatefulWidget {
  const UpdateGymProfilePage({super.key});

  @override
  State<UpdateGymProfilePage> createState() =>
      _UpdateGymProfilePageState();
}

class _UpdateGymProfilePageState
    extends State<UpdateGymProfilePage> {

  final formKey = GlobalKey<FormState>();

  final gymNameController =
  TextEditingController();

  final addressController =
  TextEditingController();

  final cityController =
  TextEditingController();

  final stateController =
  TextEditingController();

  final pincodeController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  final openingTimeController =
  TextEditingController();

  final closingTimeController =
  TextEditingController();

  File? selectedImage;

  String networkImage = "";

  bool isDataFilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final state =
        context.read<GymProfileCubit>().state;

    if (state is GymProfileDataSuccess &&
        !isDataFilled) {

      final gym = state.profile.data;

      gymNameController.text =
          gym?.gymName ?? "";

      addressController.text =
          gym?.address ?? "";

      cityController.text =
          gym?.city ?? "";

      stateController.text =
          gym?.state ?? "";

      pincodeController.text =
          gym?.pincode ?? "";

      descriptionController.text =
          gym?.description ?? "";

      openingTimeController.text =
          gym?.openingTime ?? "";

      closingTimeController.text =
          gym?.closingTime ?? "";

      networkImage =
          gym?.gymImage ?? "";

      isDataFilled = true;
    }
  }

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

      final minute =
      pickedTime.minute
          .toString()
          .padLeft(2, '0');

      final period =
      pickedTime.period ==
          DayPeriod.am
          ? "AM"
          : "PM";

      controller.text =
      "$hour:$minute $period";
    }
  }

  @override
  void dispose() {

    gymNameController.dispose();

    addressController.dispose();

    cityController.dispose();

    stateController.dispose();

    pincodeController.dispose();

    descriptionController.dispose();

    openingTimeController.dispose();

    closingTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
        Colors.transparent,

        foregroundColor:
        Colors.black,

        centerTitle: true,

        title: const Text(
          "Update Gym Profile",

          style: TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: BlocConsumer<
          GymProfileCubit,
          GymProfileState>(

        listener: (context, state) {

          /// UPDATED SUCCESS
          if (state is GymProfileDataSuccess) {

            ScaffoldMessenger.of(context)
                .showSnackBar(

              const SnackBar(
                content: Text(
                  "Gym profile updated successfully",
                ),
              ),
            );

            Navigator.pop(context);
          }

          /// ERROR
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

          final bool isLoading =
          state
          is GymProfileUpdateLoading;

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
                    width:
                    double.infinity,

                    padding:
                    const EdgeInsets
                        .all(22),

                    decoration:
                    BoxDecoration(

                      gradient:
                      const LinearGradient(
                        colors: [

                          Color(0xFF8B5CF6),

                          Color(0xFF6D28D9),
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                          30),

                      boxShadow: [

                        BoxShadow(
                          color: Colors
                              .deepPurple
                              .withOpacity(.18),

                          blurRadius: 22,

                          offset:
                          const Offset(
                              0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [

                        GestureDetector(
                          onTap:
                          pickImage,

                          child: Stack(
                            alignment:
                            Alignment
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

                                  border:
                                  Border.all(
                                    color:
                                    Colors.white,

                                    width: 3,
                                  ),
                                ),

                                child:
                                CircleAvatar(
                                  radius: 58,

                                  backgroundColor:
                                  Colors.white,

                                  backgroundImage:
                                      selectedImage != null
                                          ? FileImage(
                                              selectedImage!,
                                            )
                                          : (networkImage.trim().isNotEmpty &&
                                                  networkImage.startsWith("http"))
                                              ? NetworkImage(
                                                  networkImage.replaceAll(
                                                      "127.0.0.1", "10.0.2.2"),
                                                )
                                              : null,

                                  child: (selectedImage == null &&
                                          (networkImage.trim().isEmpty ||
                                              !networkImage.startsWith("http")))
                                      ? const Icon(
                                          Icons.fitness_center_rounded,
                                          size: 42,
                                          color: Colors.deepPurple,
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

                                child:
                                const Icon(
                                  Icons.edit,

                                  size: 18,

                                  color: Colors
                                      .deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                            height: 16),

                        const Text(
                          "Update Gym Photo",

                          style: TextStyle(
                            color:
                            Colors.white,

                            fontSize: 20,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                            height: 6),

                        const Text(
                          "Tap image to change gym logo or cover image",

                          textAlign:
                          TextAlign.center,

                          style: TextStyle(
                            color:
                            Colors.white70,

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

                  const SizedBox(
                      height: 30),

                  const Text(
                    "Gym Information",

                    style: TextStyle(
                      fontSize: 21,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 18),

                  buildField(
                    controller:
                    gymNameController,

                    hint:
                    "Gym Name",

                    icon:
                    Icons
                        .fitness_center,
                  ),

                  buildField(
                    controller:
                    addressController,

                    hint:
                    "Address",

                    icon:
                    Icons
                        .location_on_outlined,
                  ),

                  Row(
                    children: [

                      Expanded(
                        child:
                        buildField(
                          controller:
                          cityController,

                          hint:
                          "City",

                          icon:
                          Icons
                              .location_city,
                        ),
                      ),

                      const SizedBox(
                          width: 12),

                      Expanded(
                        child:
                        buildField(
                          controller:
                          stateController,

                          hint:
                          "State",

                          icon:
                          Icons
                              .map_outlined,
                        ),
                      ),
                    ],
                  ),

                  buildField(
                    controller:
                    pincodeController,

                    hint:
                    "Pincode",

                    icon:
                    Icons
                        .pin_drop_outlined,

                    keyboardType:
                    TextInputType
                        .number,
                  ),

                  buildField(
                    controller:
                    descriptionController,

                    hint:
                    "Description",

                    icon:
                    Icons
                        .description_outlined,

                    maxLines: 4,

                    isRequired:
                    false,
                  ),

                  Row(
                    children: [

                      Expanded(
                        child:
                        buildField(
                          controller:
                          openingTimeController,

                          hint:
                          "Opening Time",

                          icon:
                          Icons
                              .access_time,

                          readOnly:
                          true,

                          onTap: () {

                            pickTime(
                              openingTimeController,
                            );
                          },
                        ),
                      ),

                      const SizedBox(
                          width: 12),

                      Expanded(
                        child:
                        buildField(
                          controller:
                          closingTimeController,

                          hint:
                          "Closing Time",

                          icon:
                          Icons
                              .access_time_filled,

                          readOnly:
                          true,

                          onTap: () {

                            pickTime(
                              closingTimeController,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 34),

                  SizedBox(
                    width:
                    double.infinity,

                    height: 58,

                    child:
                    ElevatedButton(

                      onPressed:
                      isLoading
                          ? null
                          : () {

                        if (formKey
                            .currentState!
                            .validate()) {

                          context
                              .read<
                              GymProfileCubit>()
                              .updateGymProfile(

                            gymName:
                            gymNameController
                                .text
                                .trim(),

                            address:
                            addressController
                                .text
                                .trim(),

                            city:
                            cityController
                                .text
                                .trim(),

                            stateName:
                            stateController
                                .text
                                .trim(),

                            pincode:
                            pincodeController
                                .text
                                .trim(),

                            description:
                            descriptionController
                                .text
                                .trim(),

                            openingTime:
                            openingTimeController
                                .text
                                .trim(),

                            closingTime:
                            closingTimeController
                                .text
                                .trim(),

                            image:
                            selectedImage,
                          );
                        }
                      },

                      style:
                      ElevatedButton
                          .styleFrom(

                        backgroundColor:
                        AppColors
                            .primary,

                        elevation: 0,

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              18),
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

                          : const Text(
                        "Update Gym",

                        style:
                        TextStyle(
                          fontSize:
                          17,

                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 30),
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
      const EdgeInsets.only(
          bottom: 16),

      child: TextFormField(
        controller: controller,

        maxLines: maxLines,

        keyboardType:
        keyboardType,

        readOnly: readOnly,

        onTap: onTap,

        validator: (value) {

          if (isRequired &&
              (value == null ||
                  value.trim().isEmpty)) {

            return "Required";
          }

          return null;
        },

        decoration:
        InputDecoration(

          hintText: hint,

          prefixIcon: Icon(
            icon,

            color:
            AppColors.primary,
          ),

          filled: true,

          fillColor:
          Colors.white,

          contentPadding:
          const EdgeInsets
              .symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius
                .circular(18),

            borderSide:
            BorderSide.none,
          ),

          enabledBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius
                .circular(18),

            borderSide:
            BorderSide(
              color: Colors
                  .grey
                  .shade200,
            ),
          ),

          focusedBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius
                .circular(18),

            borderSide:
            BorderSide(
              color:
              AppColors
                  .primary,

              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}