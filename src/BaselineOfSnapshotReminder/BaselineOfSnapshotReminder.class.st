Class {
	#name : #BaselineOfSnapshotReminder,
	#superclass : #BaselineOf,
	#category : #BaselineOfSnapshotReminder
}

{
	#category : #baseline,
	#'squeak_changestamp' : 'ct 10/8/2025 22:52'
}
BaselineOfSnapshotReminder >> baseline: spec [
	<baseline>

	spec for: #common do: [
		"dependencies"
		spec
			baseline: 'CtAppFramework' with:
				[spec repository: 'github://LinqLover/squeak-appframework:main'].
		
		"packages"
		spec package: 'SnapshotReminder' with:
			[spec postLoadDoIt: #postLoad].
		
		"groups"
		spec
			group: #default with: #('SnapshotReminder');
			group: #recommended with: #('CtAppFramework');
			group: #withRecommended with: #(default recommended)].
]

{
	#category : #scripts,
	#'squeak_changestamp' : 'ct 10/8/2025 22:52'
}
BaselineOfSnapshotReminder >> postLoad [

	"until 78825efa9008ea6b668a7c66f5cfb5aadaed315e was optional"
	SnapshotReminder allInstancesDo: [:ea |
		ea userActivityTracker ifNil: [ea instVarNamed: 'userActivityTracker' put: UserActivityTracker new]].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 5/26/2021 15:29'
}
BaselineOfSnapshotReminder >> projectClass [

	^ (self environment classNamed: #MetacelloCypressBaselineProject) ifNil: [super projectClass]
]
