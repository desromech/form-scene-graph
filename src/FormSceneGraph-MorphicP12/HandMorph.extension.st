Extension { #name : 'HandMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
HandMorph >> activateSceneHardwareCursor [
	| cursor |
	self world ifNil: [ ^ self ].
	self world activeHand == self ifFalse: [ ^ self ].
	cursor := hardwareCursor ifNil: [Cursor normal].
	self currentCursor == cursor ifFalse: [ cursor show ]
]

{ #category : '*FormSceneGraph-MorphicP12' }
HandMorph >> buildSceneGraphNodeWith: builder [
	| cursor |
	self activateSceneHardwareCursor.
	self shouldUseHardwareCursorForScene ifTrue: [ ^ builder null ].

	cursor := temporaryCursor ifNil: [ NormalCursor ].
	^ builder texturedRectangle: (bounds topLeft extent: cursor extent) form: cursor
]

{ #category : '*FormSceneGraph-MorphicP12' }
HandMorph >> computeDamageRectForNextFrame [
	| savedDamageRectangle damageRect myBounds |
	savedDamageRectangle := self sceneSavedDamageRectangle ifNil: [Rectangle empty].
	(submorphs isEmpty and: [savedDamageRectangle isEmpty and: [self shouldUseHardwareCursorForScene ]]) ifTrue: [ ^ savedDamageRectangle ].
	
	damageRect := myBounds := self fullBounds.
	damageRect := damageRect merge: savedDamageRectangle.
	self sceneSavedDamageRectangle: damageRect.
	hasChanged := false.

	submorphs ifNotEmpty: [
		self sceneSavedDamageRectangle: myBounds.
	] ifEmpty: [
		self sceneSavedDamageRectangle: nil.
	].

	^ damageRect
]

{ #category : '*FormSceneGraph-MorphicP12' }
HandMorph >> doBuildFullSceneGraphWith: builder [
	| contentNode childrenNode overlayNode |
	childrenNode := self buildChildrenSceneGraphNodeWith: builder.
	contentNode := self buildSceneGraphNodeWith: builder.
	overlayNode := self buildOverlaySceneGraphNodeWith: builder.
	^ childrenNode , contentNode , overlayNode
]

{ #category : '*FormSceneGraph-MorphicP12' }
HandMorph >> sceneRenderingCursor [
	^ hardwareCursor ifNil: [ temporaryCursor ifNil: [ Cursor normal ] ]
]

{ #category : '*FormSceneGraph-MorphicP12' }
HandMorph >> sceneSavedDamageRectangle [
	^ self valueOfProperty: #sceneSavedDamageRectangle ifAbsent: [ nil ]
]

{ #category : '*FormSceneGraph-MorphicP12' }
HandMorph >> sceneSavedDamageRectangle: rectangle [
	^ self setProperty: #sceneSavedDamageRectangle toValue: rectangle
]

{ #category : '*FormSceneGraph-MorphicP12' }
HandMorph >> shouldUseHardwareCursorForScene [
	^ self sceneRenderingCursor isValidHardwareCompatibleCursor and: [self == self world activeHand]
]
