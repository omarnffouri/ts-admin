import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';

import '../../../../domain/entities/incoming_user_leave_request_entity.dart';
import '../../../leave_requested/views/components/leave_status_badge.dart';
import '../../controllers/manage_leave_requests_controller.dart';

class ManageLeaveRequestCard extends StatefulWidget {
  final UserLeaveRequestEntity request;
  final int index;
  final int totalCount;

  const ManageLeaveRequestCard({
    super.key,
    required this.request,
    required this.index,
    required this.totalCount,
  });

  @override
  State<ManageLeaveRequestCard> createState() => _ManageLeaveRequestCardState();
}

class _ManageLeaveRequestCardState extends State<ManageLeaveRequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;
  bool _isExpanded = false;
  final controller = Get.find<ManageLeaveRequestsController>();

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

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    // Pad before cutting — single-word names produce fewer than 2 letters.
    return name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .join()
        .padRight(2, '?')
        .substring(0, 2);
  }

  Future<void> _showApprovalDialog(String action) async {
    final request = widget.request;
    final isApprove = action == 'approved';

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ApprovalDialog(
        employeeName: request.name ?? 'N/A',
        leaveType: _getLeaveTypeLabel(request.leaveType),
        fromDate: request.fromDate,
        toDate: request.toDate,
        action: action,
        isApprove: isApprove,
        onCommentSubmitted: isApprove
            ? null
            : (comments) async {
                Navigator.pop(context, true);
                await controller.submit(
                  id: request.id!,
                  status: 'rejected',
                  comments: comments,
                );
              },
      ),
    );

    if (result == true && isApprove) {
      await controller.submit(
        id: request.id!,
        status: 'approved',
      );
    }
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
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onTap: _toggleExpansion,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Employee info + status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Employee avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: context.brandColor.applyOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.brandColor.applyOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _getInitials(request.name),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: context.brandColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Employee info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.name ?? 'N/A',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getLeaveTypeLabel(request.leaveType),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),

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

                // Quick info row
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
                    const SizedBox(width: 12),
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: context.hintTextColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Requested $requestDateText',
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

                            // Employee Information Section
                            _buildSectionTitle(
                              theme,
                              context,
                              'Employee Information',
                              Icons.person_rounded,
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              theme,
                              context,
                              'Department',
                              request.department,
                              Icons.business_rounded,
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              theme,
                              context,
                              'Designation',
                              request.designation,
                              Icons.work_rounded,
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              theme,
                              context,
                              'Phone',
                              request.phoneNumber,
                              Icons.phone_rounded,
                            ),
                            const SizedBox(height: 12),

                            // Leave Information Section
                            _buildSectionTitle(
                              theme,
                              context,
                              'Leave Details',
                              Icons.calendar_month_rounded,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailRow(
                                    theme,
                                    context,
                                    'From',
                                    request.fromDate != null
                                        ? DateFormat('MMM dd, yyyy')
                                            .format(request.fromDate!)
                                        : 'N/A',
                                    Icons.calendar_today_rounded,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDetailRow(
                                    theme,
                                    context,
                                    'To',
                                    request.toDate != null
                                        ? DateFormat('MMM dd, yyyy')
                                            .format(request.toDate!)
                                        : 'N/A',
                                    Icons.calendar_today_rounded,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              theme,
                              context,
                              'Duration',
                              daysText,
                              Icons.hourglass_bottom_rounded,
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              theme,
                              context,
                              'Leave Type',
                              _getLeaveTypeLabel(request.leaveType),
                              _getLeaveTypeIcon(request.leaveType),
                            ),
                            const SizedBox(height: 12),

                            // Reason Section (if available)
                            if (request.reason != null &&
                                request.reason!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle(
                                    theme,
                                    context,
                                    'Reason',
                                    Icons.description_rounded,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: context.surfaceVariantColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      request.reason!,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),

                            // Remaining Leave Balance Section
                            _buildSectionTitle(
                              theme,
                              context,
                              'Leave Balance',
                              Icons.analytics_rounded,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.applyOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.applyOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 18,
                                    color: Colors.green.applyOpacity(0.7),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Remaining: ${request.remainingDays ?? 'N/A'} days',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.green.applyOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Action Buttons
                            Obx(
                              () => controller.isSubmitting.value
                                  ? Center(
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          color: context.brandColor,
                                          strokeWidth: 2.4,
                                          strokeCap: StrokeCap.round,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        // Reject button
                                        Expanded(
                                          child: _buildActionButton(
                                            theme,
                                            context,
                                            'Reject',
                                            Colors.red,
                                            Icons.close_rounded,
                                            () =>
                                                _showApprovalDialog('rejected'),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Approve button
                                        Expanded(
                                          child: _buildActionButton(
                                            theme,
                                            context,
                                            'Approve',
                                            Colors.green,
                                            Icons.check_rounded,
                                            () =>
                                                _showApprovalDialog('approved'),
                                          ),
                                        ),
                                      ],
                                    ),
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

  Widget _buildSectionTitle(
    ThemeData theme,
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: context.secondaryTextColor,
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    ThemeData theme,
    BuildContext context,
    String label,
    String? value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: context.hintTextColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value ?? 'N/A',
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    ThemeData theme,
    BuildContext context,
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = context.isDark;
    final isGreen = color == Colors.green;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isGreen
              ? color.applyOpacity(0.15)
              : isDark
                  ? color.applyOpacity(0.2)
                  : color.applyOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.applyOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprovalDialog extends StatefulWidget {
  final String employeeName;
  final String leaveType;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String action;
  final bool isApprove;
  final Function(String)? onCommentSubmitted;

  const _ApprovalDialog({
    required this.employeeName,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.action,
    required this.isApprove,
    this.onCommentSubmitted,
  });

  @override
  State<_ApprovalDialog> createState() => _ApprovalDialogState();
}

class _ApprovalDialogState extends State<_ApprovalDialog> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isApprove = widget.isApprove;
    final dateRange = widget.fromDate != null && widget.toDate != null
        ? '${DateFormat('MMM dd').format(widget.fromDate!)} - ${DateFormat('MMM dd, yyyy').format(widget.toDate!)}'
        : 'N/A';

    return AlertDialog(
      backgroundColor: context.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            isApprove ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isApprove ? Colors.green : Colors.red,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isApprove ? 'Approve Request?' : 'Reject Request?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConfirmationDetail(
                    theme,
                    context,
                    'Employee',
                    widget.employeeName,
                    Icons.person_rounded,
                  ),
                  const SizedBox(height: 8),
                  _buildConfirmationDetail(
                    theme,
                    context,
                    'Leave Type',
                    widget.leaveType,
                    Icons.calendar_today_rounded,
                  ),
                  const SizedBox(height: 8),
                  _buildConfirmationDetail(
                    theme,
                    context,
                    'Date Range',
                    dateRange,
                    Icons.date_range_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (!isApprove) ...[
              Text(
                'Rejection Reason',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLines: 3,
                minLines: 2,
                decoration: InputDecoration(
                  hintText: 'Enter reason for rejection...',
                  filled: true,
                  fillColor: context.fieldFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.hairlineBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.hairlineBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.focusedBorderColor,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: theme.textTheme.labelMedium?.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (!isApprove && _commentController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a rejection reason'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            if (!isApprove) {
              widget.onCommentSubmitted?.call(_commentController.text);
            } else {
              Navigator.pop(context, true);
            }
          },
          icon: Icon(isApprove ? Icons.check_rounded : Icons.close_rounded),
          label: Text(isApprove ? 'Approve' : 'Reject'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isApprove ? Colors.green : Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationDetail(
    ThemeData theme,
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: context.hintTextColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
