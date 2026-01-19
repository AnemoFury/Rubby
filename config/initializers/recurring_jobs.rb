# Solid Queue Recurring Scheduled Jobs

Solid::Queue::ScheduledJob.new(
  DigestEmailJob,
  schedule: "every 1 day at 8:00 AM",
  timezone: "UTC"
).tap(&:schedule)
