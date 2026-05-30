import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../theme/app_colors.dart';

class MemberTile extends StatelessWidget {

  final String name;
  final String mobNo;
  final String status;
  final String image;
  final bool isTablet;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const MemberTile({
    super.key,
    required this.name,
    required this.mobNo,
    required this.status,
    required this.image,
    required this.isTablet,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final style =
    _getStatusStyle(status);

    final bool hasImage =
        image.trim().isNotEmpty;

    return RepaintBoundary(

      child: GestureDetector(

        onTap: onTap,

        child: Container(

          padding:
          const EdgeInsets.all(14),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
            BorderRadius.circular(22),

            border: Border.all(
              color: Colors.grey.shade200,
            ),

            boxShadow: const [

              BoxShadow(

                color: Colors.black12,

                blurRadius: 6,

                offset: Offset(0, 2),
              ),
            ],
          ),

          child: Column(
            children: [

              /// TOP
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// IMAGE
                  Stack(
                    children: [

                      Container(

                        padding:
                        const EdgeInsets.all(2),

                        decoration: BoxDecoration(

                          shape: BoxShape.circle,

                          border: Border.all(
                            color: AppColors.primary
                                .withOpacity(.2),
                            width: 2,
                          ),
                        ),

                        child: CircleAvatar(

                          radius:
                          isTablet
                              ? 30
                              : 27,

                          backgroundColor:
                          Colors.grey.shade100,

                          backgroundImage:
                          hasImage
                              ? CachedNetworkImageProvider(
                            image,
                          )
                              : null,

                          child: !hasImage
                              ? Icon(
                            Icons.person_rounded,
                            size:
                            isTablet
                                ? 28
                                : 22,
                            color:
                            Colors.grey,
                          )
                              : null,
                        ),
                      ),

                      /// STATUS DOT
                      Positioned(

                        right: 2,
                        bottom: 2,

                        child: Container(

                          height: 12,
                          width: 12,

                          decoration: BoxDecoration(

                            color: style.color,

                            shape: BoxShape.circle,

                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  /// DETAILS
                  Expanded(
                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        /// NAME + MENU
                        Row(
                          children: [

                            Expanded(
                              child: Text(

                                name,

                                maxLines: 1,

                                overflow:
                                TextOverflow
                                    .ellipsis,

                                style: TextStyle(

                                  fontSize:
                                  isTablet
                                      ? 17
                                      : 15,

                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),
                            ),

                            IconButton(

                              visualDensity:
                              VisualDensity.compact,

                              splashRadius: 20,

                              onPressed: () {

                                _showOptions(
                                  context,
                                );
                              },

                              icon: Icon(

                                Icons.more_vert_rounded,

                                size: 20,

                                color: Colors
                                    .grey.shade700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 2),

                        /// MOBILE
                        Row(
                          children: [

                            Icon(
                              Icons.phone_rounded,
                              size: 14,
                              color: Colors
                                  .grey.shade600,
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Text(

                                mobNo,

                                style: TextStyle(

                                  fontSize:
                                  isTablet
                                      ? 13
                                      : 12,

                                  color: Colors
                                      .grey.shade600,

                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// STATUS
                        Container(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(

                            color: style.bgColor,

                            borderRadius:
                            BorderRadius.circular(
                              30,
                            ),
                          ),

                          child: Row(

                            mainAxisSize:
                            MainAxisSize.min,

                            children: [

                              Icon(
                                style.icon,
                                size: 13,
                                color: style.color,
                              ),

                              const SizedBox(width: 5),

                              Text(

                                status,

                                style: TextStyle(

                                  color:
                                  style.color,

                                  fontWeight:
                                  FontWeight.w700,

                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Divider(
                color: Colors.grey.shade100,
                height: 1,
              ),

              const SizedBox(height: 14),

              /// ACTIONS
              Row(
                children: [

                  /// CALL
                  Expanded(
                    child: InkWell(

                      borderRadius:
                      BorderRadius.circular(
                        14,
                      ),

                      onTap: _callMember,

                      child: Container(

                        height: 46,

                        decoration: BoxDecoration(

                          color:
                          AppColors.primary,

                          borderRadius:
                          BorderRadius.circular(
                            14,
                          ),
                        ),

                        child: Row(

                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [

                            const Icon(
                              Icons.call_rounded,
                              color: Colors.white,
                              size: 17,
                            ),

                            const SizedBox(width: 8),

                            Text(

                              "Call Member",

                              style: TextStyle(

                                color:
                                Colors.white,

                                fontWeight:
                                FontWeight.w700,

                                fontSize:
                                isTablet
                                    ? 14
                                    : 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// WHATSAPP
                  InkWell(

                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),

                    onTap: _openWhatsapp,

                    child: Container(

                      height: 46,
                      width: 46,

                      decoration: BoxDecoration(

                        color: const Color(
                          0x1A25D366,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Center(
                        child: FaIcon(

                          FontAwesomeIcons.whatsapp,

                          color: Color(
                            0xFF25D366,
                          ),

                          size: 22,
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

  /// CALL
  Future<void> _callMember() async {

    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: mobNo,
    );

    if (await canLaunchUrl(
      phoneUri,
    )) {

      await launchUrl(phoneUri);
    }
  }

  /// WHATSAPP
  Future<void> _openWhatsapp() async {

    final String phone =
    mobNo.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    final Uri whatsappUri =
    Uri.parse(
      "whatsapp://send?phone=91$phone",
    );

    final Uri fallbackUri =
    Uri.parse(
      "https://wa.me/91$phone",
    );

    if (await canLaunchUrl(
      whatsappUri,
    )) {

      await launchUrl(

        whatsappUri,

        mode:
        LaunchMode.externalApplication,
      );
    }

    else {

      await launchUrl(

        fallbackUri,

        mode:
        LaunchMode.externalApplication,
      );
    }
  }

  /// BOTTOM SHEET
  void _showOptions(
      BuildContext context,
      ) {

    showModalBottomSheet(

      context: context,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),

      builder: (_) {

        return SafeArea(

          child: Padding(

            padding:
            const EdgeInsets.symmetric(
              vertical: 12,
            ),

            child: Column(

              mainAxisSize:
              MainAxisSize.min,

              children: [

                ListTile(

                  leading: const Icon(
                    Icons.edit_rounded,
                  ),

                  title: const Text(
                    "Edit Member",
                  ),

                  onTap: () {

                    Navigator.pop(
                      context,
                    );

                    onEdit?.call();
                  },
                ),

                ListTile(

                  leading: const Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),

                  title: const Text(

                    "Delete Member",

                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),

                  onTap: () {

                    Navigator.pop(
                      context,
                    );

                    onDelete?.call();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// STATUS STYLE
  _StatusStyle _getStatusStyle(
      String value,
      ) {

    final status =
    value.trim().toLowerCase();

    switch (status) {

      case "active":

        return _StatusStyle(

          color: Colors.green,

          bgColor:
          const Color(0x1A4CAF50),

          icon:
          Icons.check_circle_rounded,
        );

      case "expired":

        return _StatusStyle(

          color: Colors.orange,

          bgColor:
          const Color(0x1AFF9800),

          icon: Icons
              .access_time_filled_rounded,
        );

      case "inactive":

        return _StatusStyle(

          color: Colors.red,

          bgColor:
          const Color(0x1AF44336),

          icon:
          Icons.cancel_rounded,
        );

      default:

        return _StatusStyle(

          color: Colors.grey,

          bgColor:
          const Color(0x1A9E9E9E),

          icon:
          Icons.info_rounded,
        );
    }
  }
}

class _StatusStyle {

  final Color color;
  final Color bgColor;
  final IconData icon;

  _StatusStyle({
    required this.color,
    required this.bgColor,
    required this.icon,
  });
}