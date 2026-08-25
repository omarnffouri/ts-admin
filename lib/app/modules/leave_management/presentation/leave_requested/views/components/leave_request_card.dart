import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../domain/entities/requested_leave_entity.dart';
import 'leave_status_badge.dart';

class LeaveRequestCard extends StatefulWidget {
  final RequestEntity request;
  final int index;
  final int totalCount;

  const LeaveRequestCard({
    super.key,
    required this.request,
    required this.index,
    required this.totalCount,
  });

  @override
  State<LeaveRequestCard> createState() => _LeaveRequestCardState();
}

class _LeaveRequestCardState extends State<LeaveRequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  String _getLeaveTypeLabel(String? leaveType) =>
      leaveType?.capitalize ?? 'Leave';

  IconData _getLeaveTypeIcon(String? leaveType) {
    if (leaveType == null) return Icons.calendar_today_rounded;
    final type = leaveType.toLowerCase();
    if (type.contains('sick')) return Icons.medical_information_rounded;
    if (type.contains('emergency')) return Icons.warning_rounded;
    if (type.contains('annual')) return Icons.beach_access_rounded;
    if (type.contains('maternity') || type.contains('paternity')) {
      return Icons.child_care_rounded;
    }
    return Icons.calendar_today_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = context.isDark;
    final request = widget.request;
    final daysText =
        '${request.duration} ${request.duration! > 1 ? 'days' : 'day'}';
    final requestDateText = request.requestedAt != null
        ? DateFormat('MMM dd, yyyy').format(request.requestedAt!)
        : 'N/A';

    return Container(
      margin: EdgeInsets.only(
        bottom: widget.index == (widget.totalCount - 1) ? 20 : 12,
      ),
      decoration: BoxDecoration(
        color: context.fieldFillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.hairlineBorderColor),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.applyOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _toggleExpansion,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Leave type + status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Leave type icon and title
                    Icon(
                      _getLeaveTypeIcon(request.leaveType),
                      size: 20,
                      color: context.secondaryTextColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getLeaveTypeLabel(request.leaveType),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Requested $requestDateText',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status badge
                    LeaveStatusBadge(status: request.status),
                    const SizedBox(width: 8),
                    // Expand/collapse chevron
                    RotationTransition(
                      turns: _rotateAnimation,
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: 24,
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Quick info: Duration
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: context.hintTextColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      daysText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.hintTextColor,
                      ),
                    ),
                  ],
                ),

                // Expanded content
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: _isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Divider(
                              color: context.hairlineBorderColor,
                              height: 1,
                              thickness: 1,
                            ),
                            const SizedBox(height: 12),

                            // Date range
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 16,
                                  color: context.hintTextColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'From:',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.secondaryTextColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  request.fromDate != null
                                      ? DateFormat('MMM dd, yyyy')
                                          .format(request.fromDate!)
                                      : 'N/A',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 16,
                                  color: context.hintTextColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'To:',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.secondaryTextColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  request.toDate != null
                                      ? DateFormat('MMM dd, yyyy')
                                          .format(request.toDate!)
                                      : 'N/A',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),

                            // Reason (if available)
                            if (request.reason != null &&
                                request.reason!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  Text(
                                    'Reason',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context.secondaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    request.reason!,
                                    style: theme.textTheme.bodySmall,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),

                            // Comments (if available)
                            if (request.comments != null &&
                                request.comments!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  Text(
                                    'Comments',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: context.secondaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    request.comments!,
                                    style: theme.textTheme.bodySmall,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
