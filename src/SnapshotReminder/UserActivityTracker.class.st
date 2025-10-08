"
I record when the user has last interacted with any (Morphic) world via keyboard/mouse.
"
Class {
	#name : #UserActivityTracker,
	#superclass : #Object,
	#instVars : [
		'world',
		'lastActiveTime'
	],
	#category : #SnapshotReminder,
	#'squeak_changestamp' : 'ct 10/3/2025 02:12'
}

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 10/2/2025 23:01'
}
UserActivityTracker >> aboutToLeaveWorld [

	| newWorld |
	[[(newWorld := self currentWorld) == self world or: [newWorld isNil]]
		whileTrue: [1 second wait].
	self world: newWorld]
		forkAt: Processor systemBackgroundPriority.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 10/2/2025 22:47'
}
UserActivityTracker >> currentWorld [

	^ Project current world
]

{
	#category : #'event filtering',
	#'squeak_changestamp' : 'ct 10/3/2025 18:49'
}
UserActivityTracker >> filterEvent: anEvent for: aMorph [

	(self matchesEvent: anEvent) ifTrue: [self noteActivity].
	
	^ anEvent
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/8/2025 19:38'
}
UserActivityTracker >> initialize [

	super initialize.
	
	lastActiveTime := DateAndTime new. "pessimistic"
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 10/2/2025 22:43'
}
UserActivityTracker >> installEventFilter [

	self world addEventCaptureFilter: self.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 22:49'
}
UserActivityTracker >> lastActiveTime [

	^ lastActiveTime
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 22:49'
}
UserActivityTracker >> lastActiveTime: aDateAndTime [

	lastActiveTime := aDateAndTime.
]

{
	#category : #'event filtering',
	#'squeak_changestamp' : 'ct 10/2/2025 22:56'
}
UserActivityTracker >> matchesEvent: anEvent [

	anEvent isMouseOver ifTrue: [^ false].
	^ (anEvent isMouse and: [anEvent isMouseMove not])
		or: [anEvent isKeyboard]
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 10/3/2025 18:58'
}
UserActivityTracker >> noteActivity [

	self lastActiveTime: DateAndTime now.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 10/8/2025 19:37'
}
UserActivityTracker >> start [

	self world: self currentWorld.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 10/2/2025 22:55'
}
UserActivityTracker >> stop [

	self world: nil.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 10/2/2025 22:55'
}
UserActivityTracker >> uninstallEventFilter [

	self world removeEventCaptureFilter: self.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 22:46'
}
UserActivityTracker >> world [

	^ world
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 23:04'
}
UserActivityTracker >> world: aWorld [

	world isMorph ifTrue: [self uninstallEventFilter].
	world removeActionsWithReceiver: self.
	
	world := aWorld.
	
	self world ifNil: [^ self].
	self world isMorph ifTrue: [self installEventFilter].
	self world when: #aboutToLeaveWorld send: #aboutToLeaveWorld to: self.
]
