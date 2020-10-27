Extension { #name : #IceTipToolbarItemButtonMorph }

{ #category : #'*FormSceneGraph-Morphic' }
IceTipToolbarItemButtonMorph >> buildBadgeSceneGraphNodeWith: builder [
	| badgeString badgeBounds textBounds textWidth textHeight width result radius |
	
	badgeString := self badge asString.
	textWidth := self badgeFont widthOfString: badgeString.
	textHeight := self badgeFont height.
	width := 14 max: textWidth + 2.
	badgeBounds := ((bounds right - width - 2)@(bounds top + 2) extent: width@14).
	radius := badgeBounds extent / 2.0.
	result := builder ovalInRectangle: badgeBounds color: self badgeColor.
		
	textBounds := 
		(badgeBounds center - ((textWidth@textHeight) / 2.0)) + (1@0) 
		extent: textWidth@textHeight. 
	^ result , (builder string: badgeString in: textBounds font: self badgeFont color: self badgeTextColor)
]

{ #category : #'*FormSceneGraph-Morphic' }
IceTipToolbarItemButtonMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	self hasBadge ifTrue: [
		result := result , (self buildBadgeSceneGraphNodeWith: builder)
	].
	^ result
]
