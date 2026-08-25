/// A broadcast topic matching the application statuses drivers subscribe to in
/// the driver app after login. [value] is the snake_case FCM topic sent to the
/// backend; [label] is the human-readable name shown in the dropdown.
class AnnouncementTopic {
  final String value;
  final String label;

  const AnnouncementTopic({required this.value, required this.label});

  /// Kept in sync with the driver app's `allTopics` subscription list.
  static const List<AnnouncementTopic> all = [
    AnnouncementTopic(value: 'under_review', label: 'Under Review'),
    AnnouncementTopic(value: 'phone_screening', label: 'Phone Screening'),
    AnnouncementTopic(value: 'in_process', label: 'In Process'),
    AnnouncementTopic(value: 'approved', label: 'Approved'),
    AnnouncementTopic(value: 'hired', label: 'Hired'),
    AnnouncementTopic(value: 'on_hold', label: 'On Hold'),
    AnnouncementTopic(value: 'rejected', label: 'Rejected'),
    AnnouncementTopic(value: 'terminated', label: 'Terminated'),
  ];
}
