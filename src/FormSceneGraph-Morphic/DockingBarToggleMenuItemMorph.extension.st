Extension { #name : #DockingBarToggleMenuItemMorph }

{ #category : #'*FormSceneGraph-Morphic' }
DockingBarToggleMenuItemMorph >> buildSceneGraphNodeWith: builder [
	| stringColor stringBounds result |
	result := builder null.
	stringColor := (isSelected and: [ isEnabled ])
		ifTrue: [ result := builder fillRectangle: self bounds style: self selectionFillStyle.
			color negated ]
		ifFalse: [ color ].
	stringBounds := bounds.
	stringBounds := stringBounds left: stringBounds left + 4.
	self hasIcon
		ifTrue: [ | iconForm |
			iconForm := self iconForm.
			result := result , (builder textureForm: iconForm at: stringBounds left @ (self top + ((self height - iconForm height) // 2))).
			stringBounds := stringBounds left: stringBounds left + iconForm width + 2 ].
	self hasMarker ifTrue: [ stringBounds := stringBounds left: stringBounds left + self submorphBounds width + 8 ].
	stringBounds := stringBounds top: (stringBounds top + stringBounds bottom - self fontToUse height) // 2.
	result := result , (builder
		string: self contents
		in: stringBounds
		font: self fontToUse
		color: stringColor).
	self hasSubMenu
		ifTrue: [ | subMenuMarker subMenuMarkerPosition |
			subMenuMarker := self subMenuMarker.
			subMenuMarkerPosition := (self right - subMenuMarker width) @ ((self top + self bottom - subMenuMarker height) // 2).
			subMenuMarkerPosition := subMenuMarkerPosition - (4 @ -1).
			result := result , (builder textureForm: subMenuMarker at: subMenuMarkerPosition) ].
	^ result
]
