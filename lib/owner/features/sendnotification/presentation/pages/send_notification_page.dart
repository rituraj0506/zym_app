import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/send_notification_cubit.dart';
import '../cubit/send_notification_state.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() =>
      _SendNotificationPageState();
}

class _SendNotificationPageState
    extends State<SendNotificationPage> {
  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController messageController =
  TextEditingController();

  String selectedAudience = "All Members";

  final List<String> audiences = [
    "All Members",
    "Active Members",
    "Expiring Soon",
    "Expired Members",
  ];

  String get targetType {
    switch (selectedAudience) {
      case "Active Members":
        return "active";

      case "Expiring Soon":
        return "expiringSoon";


      case "Expired Members":
        return "expired";

      default:
        return "all";
    }
  }

  void _sendNotification() {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter notification title",
          ),
        ),
      );
      return;
    }

    if (messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter notification message",
          ),
        ),
      );
      return;
    }

    context.read<SendNotificationCubit>().sendNotification(
      title: titleController.text.trim(),
      message: messageController.text.trim(),
      targetType: targetType,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Widget _buildTemplateChip({
    required String title,
    required String message,
  }) {
    return ActionChip(
      label: Text(title),
      onPressed: () {
        titleController.text = title;
        messageController.text = message;
      },
    );
  }

  Widget _buildAudienceChip(String audience) {
    final bool isSelected =
        selectedAudience == audience;

    return ChoiceChip(
      label: Text(audience),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          selectedAudience = audience;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
        SendNotificationCubit,
        SendNotificationState>(
      listener: (context, state) {
        if (state
        is SendNotificationSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );

          titleController.clear();
          messageController.clear();
        }

        if (state
        is SendNotificationError) {
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
        state is SendNotificationLoading;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Send Notification",
            ),
          ),
          body: SingleChildScrollView(
            padding:
            const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                /// HEADER CARD
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(
                    16,
                  ),
                  decoration:
                  BoxDecoration(
                    gradient:
                    const LinearGradient(
                      colors: [
                        Colors.deepPurple,
                        Colors.purple,
                      ],
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(
                      20,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Icon(
                        Icons
                            .notifications_active,
                        color:
                        Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Send Notifications",
                        style:
                        TextStyle(
                          color: Colors
                              .white,
                          fontSize:
                          20,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Notify your members instantly.",
                        style:
                        TextStyle(
                          color: Colors
                              .white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 24),

                /// AUDIENCE
                const Text(
                  "Select Audience",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: audiences
                      .map(
                    _buildAudienceChip,
                  )
                      .toList(),
                ),

                const SizedBox(
                    height: 24),

                /// TEMPLATES
                const Text(
                  "Quick Templates",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTemplateChip(
                      title:
                      "Membership Expiring",
                      message:
                      "Your membership will expire soon. Please renew to continue enjoying gym access.",
                    ),
                    _buildTemplateChip(
                      title:
                      "Renewal Reminder",
                      message:
                      "This is a reminder to renew your gym membership.",
                    ),
                    _buildTemplateChip(
                      title:
                      "Gym Closed",
                      message:
                      "Today gym will remain closed due to maintenance.",
                    ),
                    _buildTemplateChip(
                      title:
                      "Special Offer",
                      message:
                      "Special discount available for membership renewal this week.",
                    ),
                  ],
                ),

                const SizedBox(
                    height: 24),

                /// TITLE
                TextField(
                  controller:
                  titleController,
                  decoration:
                  InputDecoration(
                    labelText:
                    "Notification Title",
                    prefixIcon:
                    const Icon(
                      Icons.title,
                    ),
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 16),

                /// MESSAGE
                TextField(
                  controller:
                  messageController,
                  maxLines: 5,
                  decoration:
                  InputDecoration(
                    labelText:
                    "Notification Message",
                    alignLabelWithHint:
                    true,
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 24),

                /// SUMMARY CARD
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(
                    16,
                  ),
                  decoration:
                  BoxDecoration(
                    color: Colors
                        .deepPurple
                        .withValues(
                      alpha: .08,
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(
                      16,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.group,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              selectedAudience,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.send,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              targetType,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 30),

                /// SEND BUTTON
                SizedBox(
                  width:
                  double.infinity,
                  height: 56,
                  child:
                  ElevatedButton.icon(
                    onPressed:
                    isLoading
                        ? null
                        : _sendNotification,
                    icon: isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                      CircularProgressIndicator(
                        strokeWidth:
                        2,
                      ),
                    )
                        : const Icon(
                      Icons.send,
                    ),
                    label: Text(
                      isLoading
                          ? "Sending..."
                          : "Send Notification",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}