"
I remind the user to save their image regularly when they don't do it by themselves. I aim to be as unobtrusive as possible by starting with a docking bar balloon and showing a pop-up only when the user seems to be inactive. I can be snoozed and configured flexibly.
"
Class {
	#name : #SnapshotReminder,
	#superclass : #Object,
	#traits : 'TCtApp',
	#classTraits : 'TCtApp classTrait',
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
	#category : #'app - accessing',
	#'squeak_changestamp' : 'ct 10/3/2025 02:16'
}
SnapshotReminder class >> appName [

	^ 'Snapshot Reminder'
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 10/2/2025 20:36'
}
SnapshotReminder class >> assureDefault [

	^ self default ifNil: [self default: self new; default]
]

{
	#category : #'app - accessing',
	#'squeak_changestamp' : 'ct 10/3/2025 02:16'
}
SnapshotReminder class >> baselineName [

	^ 'SnapshotReminder'
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/3/2025 02:45'
}
SnapshotReminder class >> cleanUp: aggressive [

	aggressive ifTrue:
		[self default ifNotNil: [:ea | ea stopProcess].
		self default: nil.
		self registeredInstances do: [:ea |
			ea stopProcess; unregister].
		RegisteredInstances := nil].
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
	#'squeak_changestamp' : 'ct 10/3/2025 02:47'
}
SnapshotReminder class >> githubRepositoryParams [
	"{owner. name. directory}"

	^ {'hpi-swa-teaching'. 'squeak-snapshot-reminder'. 'packages'}
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
	#category : #'app - accessing',
	#'squeak_changestamp' : 'ct 10/3/2025 02:16'
}
SnapshotReminder class >> packageNamePrefix [

	^ 'SnapshotReminder'
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
	#'squeak_changestamp' : 'ct 10/2/2025 19:54'
}
SnapshotReminder >> defaultReminderThreshold [

	^ 3 hours
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 10/3/2025 02:11'
}
SnapshotReminder >> defaultSnoozeDelay [

	^ 30 minutes
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 10/2/2025 22:12'
}
SnapshotReminder >> explain [

	self flag: #todo. "use SBE if installed"
	^ HelpBrowser future in: [:helpBrowser |
		helpBrowser open
			model showTopicNamed: #workingWithSqueak]
]

{
	#category : #'reminding - docking bar',
	#'squeak_changestamp' : 'ct 10/3/2025 02:54'
}
SnapshotReminder >> findDockingBarItem [

	| dockingBar world |
	world := Project current world.
	world isMorph ifFalse: [^ nil].
	dockingBar := (world mainDockingBars ifEmpty: [^ nil]) first.
	^ (dockingBar submorphs select: #isMenuItemMorph)
		detect: [:m | m submorphIndex = 1] ifNone: [nil]
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
	#'squeak_changestamp' : 'ct 10/2/2025 23:41'
}
SnapshotReminder >> initialize [

	super initialize.
	
	self reminderThreshold: self defaultReminderThreshold.
	self snoozeDelay: self defaultSnoozeDelay.
	self maxUserActiveDelay: self defaultMaxUserActiveDelay.
	self lastSnapshotTime: DateAndTime now. "optimistic"
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
	#'squeak_changestamp' : 'ct 10/3/2025 02:40'
}
SnapshotReminder >> maxUserActiveDelay: aDurationOrNil [

	maxUserActiveDelay := aDurationOrNil.
	
	self updateUserActivityTracker.
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
	#'squeak_changestamp' : 'ct 10/3/2025 02:42'
}
SnapshotReminder >> remindUser [

	| message options promise choice |
	self future showDockingBarReminder.
	
	self waitUntilUserIsInactive.
	
	message := 
'You have not saved your image for quite some time!<br>
<br>
Last snapshot was saved at <b>{1}</b>.<br>
<br>
Saving your image regularly preserves your entire session and can prevent data loss.'
		asTextFromHtml format: {self lastSnapshotTime talkPrettyPrintString}.
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
					[(world submorphThat: [:m | (m isKindOf: DialogWindow) and: [m message asString beginsWith: message lines first]] ifNone: nil) ifNotNil: [:m |
						m title: 'Reminder'.
						m messageMorph averageLineLength: 55; imageForm.
						m buttonRowMorph listDirection: #leftToRight]]].
			
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
	#category : #reminding,
	#'squeak_changestamp' : 'ct 10/2/2025 18:31'
}
SnapshotReminder >> remindUserAgain [

	^ self remindUser
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
	#category : #control,
	#'squeak_changestamp' : 'ct 10/3/2025 02:41'
}
SnapshotReminder >> runSnapshotReminder [

	[| now |
	now := self now.
	self isSnoozing
		ifTrue:
			[now >= self snoozeTime ifTrue:
				[self remindUserAgain]]
		ifFalse:
			[self now - self lastSnapshotTime >= self reminderThreshold ifTrue:
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
	#category : #'reminding - docking bar',
	#'squeak_changestamp' : 'ct 10/3/2025 02:35'
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
		(ea textMorph contents = message)
			ifTrue: [(menuItem valueOfProperty: #snapshotReminderBalloons ifAbsentPut: [IdentitySet new]) add: ea];
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
	#'squeak_changestamp' : 'ct 10/2/2025 23:16'
}
SnapshotReminder >> startProcess [

	self stopProcess.
	
	self userActivityTracker ifNotNil: [:tracker | tracker start].
	process := [self runSnapshotReminder]
		forkAt: Processor systemBackgroundPriority named: self printString.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 10/3/2025 02:43'
}
SnapshotReminder >> startUp [

	self lastSnapshotTime: self now. "Resuming a previously unsaved image will trigger this hook to, but here we assume that if the user does not recover unsaved changes manually, they have discarded them deliberately."
	self snoozeTime: nil.
	self startProcess.
]

{
	#category : #control,
	#'squeak_changestamp' : 'ct 10/3/2025 00:26'
}
SnapshotReminder >> stopProcess [

	self userActivityTracker ifNotNil: [:tracker | tracker stop].
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
	#category : #private,
	#'squeak_changestamp' : 'ct 10/3/2025 02:40'
}
SnapshotReminder >> updateUserActivityTracker [

	self maxUserActiveDelay
		ifNil:
			[userActivityTracker ifNotNil: [userActivityTracker stop].
			userActivityTracker := nil]
		ifNotNil:
			[userActivityTracker ifNil:
				[userActivityTracker := UserActivityTracker new.
				self isRunning ifTrue: [userActivityTracker start]]].
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
	#'squeak_changestamp' : 'ct 10/2/2025 23:39'
}
SnapshotReminder >> waitUntilUserIsInactive [

	| maxDelay start threshold |
	maxDelay := self maxUserActiveDelay.
	start := DateAndTime now.
	[((threshold := self userInactivityThreshold)
		ifNil: [true]
		ifNotNil: [self now - self userActivityTracker lastActiveTime >= threshold])
			or:
				[(maxDelay := self maxUserActiveDelay)
					ifNil: [false]
					ifNotNil: [self now - start >= maxDelay]]]
			whileFalse: [self interCyclePause: (threshold min: (maxDelay ifNil: [threshold]))].
]
