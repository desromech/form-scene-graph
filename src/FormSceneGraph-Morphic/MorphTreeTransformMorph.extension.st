Extension { #name : #MorphTreeTransformMorph }

{ #category : #'*FormSceneGraph-Morphic' }
MorphTreeTransformMorph >> buildClippedChildrenSceneGraphNodeListWith: builder [
	| submorphNodes top bottom |
	submorphs ifEmpty: [ ^ #() ].
	submorphNodes := OrderedCollection new.
	top := self rowAtLocation: builder clippingBounds topLeft.
	bottom := self rowAtLocation: builder clippingBounds bottomRight startingAt: top.
	bottom to: top by: -1 do: [:row | | m |
		m := submorphs basicAt: row.
		(self buildRawColorWith: builder forSubmorph: m) ifNotNil: [ :n |
			submorphNodes add: n
		].
		submorphNodes add: (m buildFullSceneGraphWith: builder)
	].

	^ submorphNodes
]

{ #category : #'*FormSceneGraph-Morphic' }
MorphTreeTransformMorph >> buildRawColorWith: builder forSubmorph: aSubMorph [
	| c frame |
	frame := (aSubMorph fullBounds withWidth: owner scroller innerBounds width) translateBy:(owner scroller offset x)@0.
	aSubMorph = owner listManager searchedElement
		ifTrue: [ 
			^ builder rectangle: frame color: owner secondarySelectionColor].
	owner listManager isCheckList
		ifTrue: [ 
			aSubMorph = owner listManager lastClickedMorph
				ifTrue: [ 
					^ builder rectangle: frame color: owner selectionColorToUse ] ]
		ifFalse: [ 
			aSubMorph selected
				ifTrue: [ 
					^ builder rectangle: frame color: owner selectionColorToUse ] ].
	(c := aSubMorph color) notNil
		ifTrue: [ 
			c isColor
				ifTrue: [ 
					^ builder rectangle: frame color: c ]
				ifFalse: [ 
					c origin: aSubMorph bounds topLeft.
					c direction: aSubMorph bounds width @ 0.
					^ builder rectangle: frame fillStyle: c ] ]
]
