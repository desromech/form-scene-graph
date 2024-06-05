Extension { #name : 'ToggleMenuItemMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
ToggleMenuItemMorph >> buildKeyTextSceneGraphNodeWith: builder [
	self keyText ifNil: [^ builder null].
	^ self itemShortcut buildSceneGraphNodeWith: builder
]

{ #category : '*FormSceneGraph-MorphicP12' }
ToggleMenuItemMorph >> buildSceneGraphNodeWith: builder [
	| result |
	self isEnabled.
	result := super buildSceneGraphNodeWith: builder.
	result := result , (self buildKeyTextSceneGraphNodeWith: builder).
	^ result
]

{ #category : '*FormSceneGraph-MorphicP12' }
ToggleMenuItemMorph >> buildText: aStringOrText sceneGraphNodeWith: builder in: aRectangle color: stringColor [
	(self enabled not and: [self theme disabledItemStyle = #inset]) ifTrue: [
		^ (builder string: aStringOrText
					in: aRectangle 
					font: self fontToUse
					color: stringColor muchLighter lighter),
			(builder 	string: aStringOrText
					in: (aRectangle translateBy: -1)
					font: self fontToUse
					color: stringColor).
	] ifFalse: [
		^ builder string: aStringOrText
					in: aRectangle 
					font: self fontToUse
					color: stringColor
	].
]
