# squeak-snapshot-reminder
Regulary reminds Squeak users to save their image

## Installation

```smalltalk
Metacello new
	baseline: 'SnapshotReminder';
	repository: 'github://hpi-swa-teaching/squeak-snapshot-reminder:main';
	get; "for updates"
	load.
```

Optionally, `load: #withRecommended` instead for self-updates.

To enable snapshot reminders, do this:

```smalltalk
SnapshotReminder ensureDefault startProcess.
```

Or go to the preference browser and set a snapshot reminder threshold.

To disable snapshot reminders, delete the snapshot reminder threshold in the preferences.
