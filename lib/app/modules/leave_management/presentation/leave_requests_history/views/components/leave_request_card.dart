import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:ts_admin/app/core/utils/extensions.dart';
import 'package:ts_admin/app/core/utils/theme_extensions.dart';
import 'package:ts_admin/app/modules/leave_management/domain/entities/leave_history_entity.dart';

class LeaveRequestCard extends StatefulWidget {
  final LeaveHistoryEntity request;
  final bool isExpanded;
  final VoidCallback onExpanded;
  final int index;

  const LeaveRequestCard({
    super.key,
    required this.request,
    required this.isExpanded,
    required this.onExpanded,
    required this.index,
  });

  @override
  State<LeaveRequestCard> createState() => _LeaveRequestCardState();
}

class _LeaveRequestCardState extends State<LeaveRequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    if (widget.isExpanded) {
      _expandController.forward();
    }
  }

  @override
  void didUpdateWidget(LeaveRequestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  String _getLeaveTypeLabel(String? leaveType) => leaveType?.capitalize ?? '';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: widget.onExpanded,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: context.surfaceColor.applyOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.hairlineBorderColor,
            width: 1,
          ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCollapsedHeader(context),
            if (widget.isExpanded) _buildExpandedContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.request.userName ?? 'N/A',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: context.secondaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getLeaveTypeLabel(widget.request.leaveType),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: context.secondaryTextColor,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              RotationTransition(
                turns: Tween(begin: 0.0, end: 0.5).animate(_expandController),
                child: Icon(
                  Icons.expand_more_rounded,
                  size: 24,
                  color: context.secondaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoChip(
                context,
                Icons.schedule_rounded,
                '${widget.request.duration ?? 0} ${(widget.request.duration ?? 0) > 1 ? "days" : "day"}',
              ),
              _buildInfoChip(
                context,
                Icons.date_range_outlined,
                DateFormat('MMM d')
                    .format(widget.request.requestedAt ?? DateTime.now()),
              ),
              LeaveStatusBadge(
                status: widget.request.status ?? 'Pending',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: context.secondaryTextColor,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.secondaryTextColor,
              ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.hairlineBorderColor,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailSection('Employee Information', [
                _buildDetailRow('Name', widget.request.userName),
                _buildDetailRow('Phone', widget.request.phoneNumber),
                _buildDetailRow('Department', widget.request.departmentName),
                _buildDetailRow('Designation', widget.request.designation),
              ]),
              const SizedBox(height: 16),
              _buildDetailSection('Leave Details', [
                _buildDetailRow(
                    'Type', _getLeaveTypeLabel(widget.request.leaveType)),
                _buildDetailRow(
                  'Start Date',
                  widget.request.fromDate != null
                      ? DateFormat('MMM d, yyyy')
                          .format(widget.request.fromDate!)
                      : null,
                ),
                _buildDetailRow(
                  'End Date',
                  widget.request.toDate != null
                      ? DateFormat('MMM d, yyyy').format(widget.request.toDate!)
                      : null,
                ),
                _buildDetailRow(
                  'Duration',
                  '${widget.request.duration ?? 0} days',
                ),
                if (widget.request.remainingDays != null)
                  _buildDetailRow(
                      'Remaining Leaves', widget.request.remainingDays),
              ]),
              const SizedBox(height: 16),
              _buildDetailSection('Request Timeline', [
                _buildDetailRow(
                  'Requested',
                  widget.request.requestedAt != null
                      ? DateFormat('MMM d, yyyy')
                          .format(widget.request.requestedAt!)
                      : null,
                ),
                _buildDetailRow('Reason', widget.request.reason),
              ]),
              const SizedBox(height: 16),
              _buildDetailSection('Decision', [
                _buildDetailRow(
                  'Status',
                  widget.request.status != null
                      ? '${widget.request.status![0].toUpperCase()}${widget.request.status!.substring(1).toLowerCase()}'
                      : null,
                ),
                _buildDetailRow('Reviewed By', widget.request.updatedBy),
                _buildDetailRow(
                  'Decision Date',
                  widget.request.updatedAt != null
                      ? DateFormat('MMM d, yyyy')
                          .format(widget.request.updatedAt!)
                      : null,
                ),
                if (widget.request.comments != null &&
                    widget.request.comments!.isNotEmpty)
                  _buildDetailRow('Reason/Note', widget.request.comments),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
        ),
        const SizedBox(height: 8),
        ...children.map((child) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: child,
            )),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.secondaryTextColor,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

class LeaveStatusBadge extends StatelessWidget {
  final String status;
  final DateTime? decisionDate;

  const LeaveStatusBadge({
    super.key,
    required this.status,
    this.decisionDate,
  });

  Color _getStatusColor(BuildContext context, String status) {
    return switch (status.toLowerCase()) {
      'approved' => Colors.green,
      'rejected' => Colors.red,
      _ => Colors.orange,
    };
  }

  IconData _getStatusIcon(String status) {
    return switch (status.toLowerCase()) {
      'approved' => Icons.check_circle_rounded,
      'rejected' => Icons.cancel_rounded,
      _ => Icons.schedule_rounded,
    };
  }

  String _getStatusLabel(String status) {
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(context, status);
    final statusIcon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.applyOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.applyOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                statusIcon,
                size: 16,
                color: statusColor,
              ),
              const SizedBox(width: 6),
              Text(
                _getStatusLabel(status),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          if (decisionDate != null) ...[
            const SizedBox(height: 4),
            Text(
              '${decisionDate!.day}/${decisionDate!.month}/${decisionDate!.year}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.secondaryTextColor,
                    fontSize: 10,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
