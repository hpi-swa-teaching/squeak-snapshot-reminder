Extension { #name : #DateAndTime }

{
	#category : #'*SnapshotReminder-squeak protocol',
	#'squeak_changestamp' : 'ct 10/3/2025 03:58'
}
DateAndTime >> snapshotPrettyPrintOn: aStream [

	self flag: #moveUpstream.
	
	self offset = self class localOffset ifFalse: [^ self asLocal snapshotPrettyPrintOn: aStream].
	
	self printYMDOn: aStream.
	aStream space.
	self printHMSOn: aStream
]

{
	#category : #'*SnapshotReminder-squeak protocol',
	#'squeak_changestamp' : 'ct 10/3/2025 03:58'
}
DateAndTime >> snapshotPrettyPrintString [

	self flag: #moveUpstream.
	
	^ String streamContents: [:stream | self snapshotPrettyPrintOn: stream]
]
