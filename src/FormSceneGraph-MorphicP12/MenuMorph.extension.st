Extension { #name : 'MenuMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
MenuMorph >> buildSceneGraphNodeWith: builder [
	| result |
	result := super buildSceneGraphNodeWith: builder.
	
	(self activeHand notNil and: [ self activeHand keyboardFocus == self
					and: [self rootMenu hasProperty: #hasUsedKeyboard]])
		ifTrue: [
		result := result , (builder borderRectangle: self innerBounds color: self theme menuKeyboardFocusColor width: self theme menuBorderWidth)
	].

	^ result
]

{ #category : '*FormSceneGraph-MorphicP12' }
MenuMorph >> shouldCacheSceneGraphSurface [
	^ true
]
