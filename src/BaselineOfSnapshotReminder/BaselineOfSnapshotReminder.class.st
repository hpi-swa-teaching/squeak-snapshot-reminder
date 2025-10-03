Class {
	#name : #BaselineOfSnapshotReminder,
	#superclass : #BaselineOf,
	#category : #BaselineOfSnapshotReminder
}

{
	#category : #baseline,
	#'squeak_changestamp' : 'ct 10/3/2025 03:45'
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
			[spec requires: #('CtAppFramework')].
		
		"groups"
		spec group: #default with: #('SnapshotReminder')]
]

{
	#category : #'self-updating',
	#'squeak_changestamp' : 'ct 10/3/2025 03:59'
}
BaselineOfSnapshotReminder >> installDependencies [
	"Install most important dependencies. Metacello>>#get is not recursive."

	Metacello new
		baseline: 'CtAppFramework';
		repository: 'github://LinqLover/squeak-appframework:main';
		get;
		load.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 5/26/2021 15:29'
}
BaselineOfSnapshotReminder >> projectClass [

	^ (self environment classNamed: #MetacelloCypressBaselineProject) ifNil: [super projectClass]
]
