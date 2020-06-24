Extension { #name : #TransformMorph }

{ #category : #'*FormSceneGraph-Morphic' }
TransformMorph >> buildChildrenSceneGraphNodeWith: builder [
	submorphs isEmpty ifTrue: [ ^ builder null ].
	^ builder withClippingBounds: self innerBounds when: self clipSubmorphs build: [ 
		builder withTransform: transform asFormSGTransform build: [ 
			self buildClippedChildrenSceneGraphNodeWith: builder
		]
	].

]
