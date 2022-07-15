Extension { #name : #Number }

{ #category : #'*FormSceneGraph-SqueakCompatibility' }
Number >> closeTo: num precision: aPrecision [
	"are these two numbers close?"

	num isFloat ifTrue: [ ^ num closeTo: self asFloat precision: aPrecision ].
	^ [ self = num ] onErrorDo: [ false ]
]
