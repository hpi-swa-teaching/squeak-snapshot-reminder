"
I remind the user to save their image regularly when they don't do it by themselves. I aim to be as unobtrusive as possible by starting with a docking bar balloon and showing a pop-up only when the user seems to be inactive. I can be snoozed and configured flexibly.
"
Class {
	#name : #SnapshotReminder,
	#superclass : #Object,
	#instVars : [
		'reminderThreshold',
		'snoozeDelay',
		'maxUserActiveDelay',
		'lastSnapshotTime',
		'process',
		'userActivityTracker',
		'snoozeTime'
	],
	#classVars : [
		'Default',
		'RegisteredInstances'
	],
	#category : #SnapshotReminder,
	#'squeak_changestamp' : 'ct 10/3/2025 02:15'
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 20:36'
}
SnapshotReminder class >> assureDefault [

	^ self default ifNil: [self default: self new; default]
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/3/2025 18:43'
}
SnapshotReminder class >> cleanUp: aggressive [

	aggressive ifTrue:
		[self default ifNotNil: [:ea | ea stopProcess].
		self default: nil.
		self registeredInstances copy do: [:ea |
			ea stopProcess; unregister]].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 20:07'
}
SnapshotReminder class >> default [

	^ Default
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 20:09'
}
SnapshotReminder class >> default: aSnapshotReminder [

	self default ifNotNil: [:reminder | reminder unregister].
	Default := aSnapshotReminder register.
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'ct 10/3/2025 00:33'
}
SnapshotReminder class >> defaultMaxUserActiveDelayString [
	<preference: 'Snapshot reminder: max user active delay' category: #SnapshotReminder description: 'Defer snapshot reminders when user activity is detected (e.g., typing) by up to the provided delay. Enter a duration (e.g., 30 seconds/10.5 minutes) or leave empty to always reminder obtrusively.' type: #String>

	^ self default
		ifNil: [^ '']
		ifNotNil: [:reminder | (reminder maxUserActiveDelay ifNil: [^ '']) printString]
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'ct 10/2/2025 23:27'
}
SnapshotReminder class >> defaultMaxUserActiveDelayString: aString [

	self assureDefault maxUserActiveDelay:
		(self durationFromString: aString).
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'ct 10/3/2025 00:29'
}
SnapshotReminder class >> defaultReminderThresholdString [
	<preference: 'Snapshot reminder threshold' category: #SnapshotReminder description: 'Reminds to save image after the specified delay. Enter a duration (e.g., 30 minutes/3 hours/1 day + 1 hour) or leave empty to disable reminders.' type: #String>

	^ self default
		ifNil: [^ '']
		ifNotNil: [:reminder | (reminder reminderThreshold ifNil: [^ '']) printString]
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'ct 10/3/2025 00:28'
}
SnapshotReminder class >> defaultReminderThresholdString: aString [

	(self durationFromString: aString)
		ifNil: [self default ifNotNil: [:reminder | reminder reminderThreshold: nil; unregister; stopProcess]]
		ifNotNil: [:duration | self assureDefault reminderThreshold: duration; register; startProcess].
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'ct 10/3/2025 00:32'
}
SnapshotReminder class >> defaultSnoozeDelayString [
	<preference: 'Snapshot reminder: snooze delay' category: #SnapshotReminder description: 'Reminds to save image again when the first reminder was discarded after the specified delay. Only applies when a reminder threshold is set. Enter a duration (e.g., 30 seconds/10.5 minutes) or leave empty to disable snoozing.' type: #String>

	^ self default
		ifNil: [^ '']
		ifNotNil: [:reminder | (reminder snoozeDelay ifNil: [^ '']) printString]
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'ct 10/2/2025 23:21'
}
SnapshotReminder class >> defaultSnoozeDelayString: aString [

	self assureDefault snoozeDelay:
		(self durationFromString: aString).
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 10/2/2025 20:07'
}
SnapshotReminder class >> durationFromString: aString [

	| duration |
	aString ifEmpty: [^ nil].
	
	[^ Duration fromString: aString] ifError: [].
	
	duration := Object readFrom: aString.
	(duration isNil or: [duration isKindOf: Duration])
		ifFalse: [self error: 'invalid duration'].
	^ duration
]

{
	#category : #'app - accessing',
	#'squeak_changestamp' : 'ct 10/3/2025 04:02'
}
SnapshotReminder class >> githubRepositoryParams [
	"{owner. name. directory}"

	^ {'hpi-swa-teaching'. 'squeak-snapshot-reminder'. 'src'}
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/3/2025 02:45'
}
SnapshotReminder class >> initialize [

	RegisteredInstances := IdentitySet new.
	Smalltalk
		addToStartUpList: self;
		addToShutDownList: self.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/3/2025 02:45'
}
SnapshotReminder class >> registeredInstances [

	^ RegisteredInstances
]

{
	#category : #'system startup',
	#'squeak_changestamp' : 'ct 10/2/2025 18:21'
}
SnapshotReminder class >> shutDown: quitting [

	self registeredInstances do: [:ea |
		ea shutDown].
]

{
	#category : #'system startup',
	#'squeak_changestamp' : 'ct 10/2/2025 18:20'
}
SnapshotReminder class >> startUp: resuming [

	self registeredInstances do: [:ea |
		ea startUp].
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/2/2025 20:45'
}
SnapshotReminder class >> unload [

	Smalltalk
		removeFromShutDownList: self;
		removeFromStartUpList: self.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 10/2/2025 22:10'
}
SnapshotReminder >> canExplain [ 

	^ true
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 10/2/2025 23:19'
}
SnapshotReminder >> canSnooze [

	^ self snoozeDelay notNil
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/2/2025 23:41'
}
SnapshotReminder >> defaultMaxUserActiveDelay [

	^ 10 minutes
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/5/2025 18:34'
}
SnapshotReminder >> defaultReminderThreshold [

	^ 24 hours
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/3/2025 02:11'
}
SnapshotReminder >> defaultSnoozeDelay [

	^ 30 minutes
]

{
	#category : #'reminding - docking bar',
	#'squeak_changestamp' : 'ct 10/8/2025 19:04'
}
SnapshotReminder >> dockingBarMenuBalloonClicked: anEvent from: aBalloonMorph [

	"bring up the reminder now again, but in the right process"
	self userActivityTracker lastActiveTime: DateAndTime new. "override waitUntilUserIsInactive"
	self resetSnooze.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 10/3/2025 20:03'
}
SnapshotReminder >> explain [

	self flag: #todo. "use SBE if installed"
	^ HelpBrowser future in: [:helpBrowser |
		[helpBrowser open
			model showTopicNamed: #workingWithSqueak]
				on: CurrentReadOnlySourceFiles do: [:ex | ex resume: ex defaultAction] "<= Squeak 6.0 (non-Errors are caught by promises too)"]
]

{
	#category : #'reminding - docking bar',
	#'squeak_changestamp' : 'ct 10/3/2025 03:57'
}
SnapshotReminder >> findDockingBarItem [

	| dockingBar world |
	world := Project current world.
	world isMorph ifFalse: [^ nil].
	dockingBar := (world mainDockingBars ifEmpty: [^ nil]) first.
	^ (dockingBar submorphs select: #isMenuItemMorph)
		at: 1 ifAbsent: [^ nil]
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 10/8/2025 21:05'
}
SnapshotReminder >> getStartUpTime [

	self shouldRemindAlways ifTrue: [^ self lastSnapshotTime].
	
	self future yourself wait. "Wait one UI cycle for handling any leftover mouseUp/keyUp events that were issued while saving the image"
	[self userActivityTracker lastActiveTime > self lastSnapshotTime]
		whileFalse: [self interCyclePause: nil].
	^ self now
]

{
	#category : #'reminding - docking bar',
	#'squeak_changestamp' : 'ct 10/3/2025 02:34'
}
SnapshotReminder >> hideDockingBarReminder [

	| menuItem |
	menuItem := self findDockingBarItem ifNil: [^ self].
	
	(menuItem removeProperty: #snapshotReminderHighlight) ifNotNil: [:m | m delete].
	menuItem balloonText: nil.
	((menuItem removeProperty: #snapshotReminderBalloons) ifNil: [#()]) do: [:ea | ea delete].
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/8/2025 19:03'
}
SnapshotReminder >> initialize [

	super initialize.
	
	self reminderThreshold: self defaultReminderThreshold.
	self snoozeDelay: self defaultSnoozeDelay.
	self maxUserActiveDelay: self defaultMaxUserActiveDelay.
	self lastSnapshotTime: DateAndTime now. "optimistic"
	
	userActivityTracker := UserActivityTracker new.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 10/2/2025 22:27'
}
SnapshotReminder >> interCyclePause: quantumDurationOrNil [

	| duration |
	duration := self minCycleLapse.
	quantumDurationOrNil ifNotNil:
		[duration := duration min: quantumDurationOrNil / 10 "*somewhat* accurate snoozing etc."].
	^ duration wait
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 10/2/2025 23:23'
}
SnapshotReminder >> isRunning [

	^ process notNil and: [process isTerminated not]
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 10/2/2025 20:35'
}
SnapshotReminder >> isSnoozing [

	^ self snoozeTime notNil
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 19:57'
}
SnapshotReminder >> lastSnapshotTime [

	^ lastSnapshotTime
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 20:34'
}
SnapshotReminder >> lastSnapshotTime: aDateAndTime [

	lastSnapshotTime := aDateAndTime.
]

{
	#category : #'accessing - preferences',
	#'squeak_changestamp' : 'ct 10/2/2025 23:17'
}
SnapshotReminder >> maxUserActiveDelay [

	^ maxUserActiveDelay
]

{
	#category : #'accessing - preferences',
	#'squeak_changestamp' : 'ct 10/8/2025 19:04'
}
SnapshotReminder >> maxUserActiveDelay: aDurationOrNil [

	maxUserActiveDelay := aDurationOrNil.
]

{
	#category : #'accessing - preferences',
	#'squeak_changestamp' : 'ct 10/2/2025 19:52'
}
SnapshotReminder >> minCycleLapse [

	^ 10 seconds
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 10/2/2025 18:24'
}
SnapshotReminder >> now [

	^ DateAndTime now
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 10/2/2025 22:03'
}
SnapshotReminder >> openSettings [

	^ PreferenceBrowser future in: [:browser |
		browser open selectedCategory: #SnapshotReminder]
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/2/2025 20:09'
}
SnapshotReminder >> register [

	self class registeredInstances add: self.
]

{
	#category : #reminding,
	#'squeak_changestamp' : 'ct 10/3/2025 20:03'
}
SnapshotReminder >> remindUser [

	self future showDockingBarReminder.
	
	self waitUntilUserIsInactive.
	self remindUserNow.
]

{
	#category : #reminding,
	#'squeak_changestamp' : 'ct 10/2/2025 18:31'
}
SnapshotReminder >> remindUserAgain [

	^ self remindUser
]

{
	#category : #reminding,
	#'squeak_changestamp' : 'ct 10/8/2025 22:05'
}
SnapshotReminder >> remindUserNow [

	| message options promise choice |
	message := 
'You have not saved your image for quite some time!<br>
<br>
Last snapshot was saved at <b>{1}</b>.<br>
<br>
Saving your image regularly preserves your entire session and can prevent data loss.'
		asTextFromHtml format: {self lastSnapshotTime snapshotPrettyPrintString}.
	options := OrderedDictionary new.
	options at: 'Save now' put: #saveImage.
	self canSnooze ifTrue: [options at: 'Snooze' put: #snooze].
	self canExplain ifTrue: [options at: 'Learn more' put: #explain].
	options at: 'Settings' put: #openSettings.
	
	"Could be a simple future send if interrupts did not leave the promise pending forever - see: https://lists.squeakfoundation.org/archives/list/squeak-dev@lists.squeakfoundation.org/thread/LCPS7LAH7FPGGAI5NKAPL3A544TIG4N7/#IHLP5G6IX4BMIVBK4VZSBYKV5SCUYDD2"
	promise := Promise new.
	Project current addDeferredUIMessage:
		[promise resolveWith:
			(["hack to fine-tune appearance without proper extensions"
			self currentWorld future in: [:world |
				world isMorph ifTrue:
					[(world submorphThat: [:m | (m isKindOf: DialogWindow) and: [m message asString beginsWith: message asString "<= Squeak 6.0" lines first]] ifNone: nil) ifNotNil: [:m |
						| preferredPosition |
						m title: 'Reminder'.
						m messageMorph averageLineLength: 55; imageForm. "hack to properly compute width before the following layout change"
						m buttonRowMorph listDirection: #leftToRight.
						m selectButton: m buttons second "prevent accidental enter to save image".
						
						"center (undo getUserResponse*AtHand*)"
						m fullBounds.
						m preferredPosition: (preferredPosition := m world center); moveToPreferredPosition.
						"prevent accidental mouse click on button"
						(m morphsAt: self currentHand position)
							detect: [:ea | ea isButton]
							ifFound: [:ea |
								m preferredPosition: (preferredPosition := preferredPosition + ea height); moveToPreferredPosition]]]].
			
			Project uiManager
				chooseOptionFromLabeledValues: options
				title: message]
					ifCurtailed: [promise reject])].
	
	choice := [promise wait] ifError: [nil].
	choice ifNotNil:
		[| result |
		result := self perform: choice.
		result isPromise ifTrue: [result wait]].
	choice = #snooze
		ifTrue: [self future hideDockingBarReminder]
		ifFalse: [self canSnooze ifTrue: [self snooze]].
]

{
	#category : #'accessing - preferences',
	#'squeak_changestamp' : 'ct 10/2/2025 19:54'
}
SnapshotReminder >> reminderThreshold [

	^ reminderThreshold
]

{
	#category : #'accessing - preferences',
	#'squeak_changestamp' : 'ct 10/2/2025 19:54'
}
SnapshotReminder >> reminderThreshold: aDuration [

	reminderThreshold := aDuration.
]

{
	#category : #reminding,
	#'squeak_changestamp' : 'ct 10/3/2025 20:03'
}
SnapshotReminder >> resetSnooze [

	self snoozeTime: nil.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 10/8/2025 22:14'
}
SnapshotReminder >> runSnapshotReminder [

	| startUpTime |
	startUpTime := self getStartUpTime.
	
	[| now |
	now := self now.
	self isSnoozing
		ifTrue:
			[now >= self snoozeTime ifTrue:
				[self remindUserAgain]]
		ifFalse:
			[self now - startUpTime >= self reminderThreshold ifTrue:
				[self remindUser]].
	
	self interCyclePause: self snoozeDelay]
		repeat.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 10/2/2025 22:13'
}
SnapshotReminder >> saveImage [

	"shutDown will kill the active process, so we MUST do this in the UI process"
	^ Smalltalk future saveSession
]

{
	#category : #'accessing - preferences',
	#'squeak_changestamp' : 'ct 10/8/2025 22:08'
}
SnapshotReminder >> shouldRemindAlways [
	"If true, always remind the user after the specified threshold, starting from the last snapshot of the image. If false, only start counting the threshold with the first user activity after the snapshot. The latter is helpful if the user keeps their image unattended after saving for a long time, but might miss important changes that are not bound to interactivity, such as long-running computation started before the last snapshot."

	^ false
]

{
	#category : #'reminding - docking bar',
	#'squeak_changestamp' : 'ct 10/3/2025 20:03'
}
SnapshotReminder >> showDockingBarReminder [

	| menuItem highlight message |
	self hideDockingBarReminder.
	
	menuItem := self findDockingBarItem ifNil: [^ self].
	
	highlight := Morph new
		color: Color orange;
		disableLayout: true;
		extent: menuItem extent;
		position: menuItem position;
		yourself.
	menuItem owner addMorphBack: highlight.
	menuItem setProperty: #snapshotReminderHighlight toValue: highlight.
	
	message := 'You have not saved your image for quite some time!'.
	menuItem balloonText: message.
	menuItem showBalloon: message at: menuItem center.
	menuItem world activeHand balloonHelpList removeAllSuchThat: [:ea |
		ea textMorph contents = message
			ifTrue:
				[ea
					on: #mouseEnter send: #show to: Cursor webLink;
					on: #mouseLeave send: #show to: Cursor normal;
					on: #mouseUp send: #dockingBarMenuBalloonClicked:from: to: self.
				(menuItem valueOfProperty: #snapshotReminderBalloons ifAbsentPut: [IdentitySet new]) add: ea];
			yourself].
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 10/2/2025 18:21'
}
SnapshotReminder >> shutDown [

	self stopProcess.
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 10/2/2025 23:19'
}
SnapshotReminder >> snooze [

	self snoozeTime: self snoozeDelay fromNow.
]

{
	#category : #'accessing - preferences',
	#'squeak_changestamp' : 'ct 10/2/2025 23:19'
}
SnapshotReminder >> snoozeDelay [

	^ snoozeDelay
]

{
	#category : #'accessing - preferences',
	#'squeak_changestamp' : 'ct 10/2/2025 23:19'
}
SnapshotReminder >> snoozeDelay: aDurationOrNil [

	snoozeDelay := aDurationOrNil.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 20:35'
}
SnapshotReminder >> snoozeTime [

	^ snoozeTime
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 20:35'
}
SnapshotReminder >> snoozeTime: aDateAndTimeOrNil [

	snoozeTime := aDateAndTimeOrNil.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 10/8/2025 19:03'
}
SnapshotReminder >> startProcess [

	self stopProcess.
	
	self userActivityTracker start.
	process := [self runSnapshotReminder]
		forkAt: Processor systemBackgroundPriority named: self printString.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 10/3/2025 20:03'
}
SnapshotReminder >> startUp [

	self lastSnapshotTime: self now. "Resuming a previously unsaved image will trigger this hook to, but here we assume that if the user does not recover unsaved changes manually, they have discarded them deliberately."
	self resetSnooze.
	self startProcess.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 10/8/2025 19:04'
}
SnapshotReminder >> stopProcess [

	self userActivityTracker stop.
	self hideDockingBarReminder.
	
	process ifNil: [^ self].
	process terminate.
	process := nil.
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/2/2025 20:18'
}
SnapshotReminder >> unregister [

	self class registeredInstances remove: self ifAbsent: [].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 23:19'
}
SnapshotReminder >> userActivityTracker [

	^ userActivityTracker
]

{
	#category : #'accessing - preferences',
	#'squeak_changestamp' : 'ct 10/2/2025 23:39'
}
SnapshotReminder >> userInactivityThreshold [

	^ 10 seconds
]

{
	#category : #reminding,
	#'squeak_changestamp' : 'ct 10/3/2025 18:45'
}
SnapshotReminder >> waitUntilUserIsInactive [

	| maxDelay start threshold |
	maxDelay := self maxUserActiveDelay.
	start := self now.
	[((threshold := self userInactivityThreshold)
		ifNil: [true]
		ifNotNil: [self now - self userActivityTracker lastActiveTime >= threshold])
			or:
				[(maxDelay := self maxUserActiveDelay)
					ifNil: [false]
					ifNotNil: [self now - start >= maxDelay]]]
		whileFalse: [self interCyclePause: (threshold min: (maxDelay ifNil: [threshold]))].
]
