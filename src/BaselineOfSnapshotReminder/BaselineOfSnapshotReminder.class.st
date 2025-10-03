Class {
	#name : #BaselineOfSnapshotReminder,
	#superclass : #BaselineOf,
	#category : #BaselineOfSnapshotReminder
}

{
	#category : #baseline,
	#'squeak_changestamp' : 'ct 10/3/2025 18:38'
}
BaselineOfSnapshotReminder >> baseline: spec [
	<baseline>

	spec for: #common do: [
		"dependencies"
		spec
			baseline: 'CtAppFramework' with:
				[spec repository: 'github://LinqLover/squeak-appframework:main'].
		
		"packages"
		spec package: 'SnapshotReminder'.
		
		"groups"
		spec
			group: #default with: #('SnapshotReminder');
			group: #recommended with: #('CtAppFramework');
			group: #withRecommended with: #(default recommended)].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 5/26/2021 15:29'
}
BaselineOfSnapshotReminder >> projectClass [

	^ (self environment classNamed: #MetacelloCypressBaselineProject) ifNil: [super projectClass]
]
