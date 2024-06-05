Extension { #name : 'TransformMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
TransformMorph >> buildChildrenSceneGraphNodeWith: builder [
	submorphs isEmpty ifTrue: [ ^ builder null ].
	^ builder withClippingBounds: self innerBounds when: self clipSubmorphs build: [ 
		builder withTransform: transform asFormSGTransform build: [ 
			self buildClippedChildrenSceneGraphNodeWith: builder
		]
	].

]

{ #category : '*FormSceneGraph-MorphicP12' }
TransformMorph >> invalidRect: damageRect from: aMorph [
	"Translate damage reports from submorphs by the scrollOffset."
	self setProperty: #invalidSceneGraph toValue: true.
	aMorph == self
		ifTrue:[super invalidRect: damageRect from: self]
		ifFalse:[super invalidRect: (((transform localBoundsToGlobal: damageRect) intersect: bounds ifNone: [ ^ self ] ) expandBy: 1) from: self].
]
