Extension { #name : 'MenuItemMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
MenuItemMorph >> buildIconSceneGraphNodeWith: builder [
	| iconForm |
	self hasIcon ifFalse: [ ^ builder null ].
	
	iconForm := self iconForm.
	^ builder textureForm: iconForm at: bounds left @ (self top + ((self height - iconForm height) // 2)).

]

{ #category : '*FormSceneGraph-MorphicP12' }
MenuItemMorph >> buildSceneGraphNodeWith: builder [
	| result stringColor |
	result := builder null.
	self shouldBeHighlighted ifTrue: [
		result := builder fillRectangle: self bounds style: self selectionFillStyle.
		stringColor := self selectionTextColor
	] ifFalse: [
		stringColor := color
	].

	result := result , (self buildIconSceneGraphNodeWith: builder).
		
	result := result , (builder string: self contents 
		in: self menuStringBounds 
		font: self fontToUse 
		color: stringColor).
	result := result , (self buildSubmenuMarkerSceneGraphNodeWith: builder).
	^ result
]

{ #category : '*FormSceneGraph-MorphicP12' }
MenuItemMorph >> buildSubmenuMarkerSceneGraphNodeWith: builder [
	| subMenuMarker subMenuMarkerPosition |
	self hasSubMenu ifFalse: [ ^ builder null ].
	
	subMenuMarker := self subMenuMarker.
	subMenuMarkerPosition := (self right - subMenuMarker width) @ ((self top + self bottom - subMenuMarker height) // 2).
	^ builder textureForm: subMenuMarker at: subMenuMarkerPosition
]
