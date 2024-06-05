Extension { #name : 'CheckboxButtonMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
CheckboxButtonMorph >> buildSceneGraphNodeWith: builder [
	| result imageToUse |
	result := builder fillRectangle: self bounds fillStyle: self fillStyle borderStyle: self borderStyle.
	imageToUse := self imageToUse.
	imageToUse ifNotNil: [
		result := result , (builder textureForm: imageToUse at: self innerBounds center - (imageToUse extent // 2))
	].

	((self state == #pressed or: [self state == #repressed]) and: [image isNil]) ifTrue: [
		result := result , (builder rectangle: self innerBounds color: (self paneColor alpha: 0.3))
	].
	(self enabled not and: [self theme fadeCheckboxWhenDisabled]) ifTrue: [
		result := result , (builder rectangle: self innerBounds color: (self paneColor alpha: 0.4))
	].

	^ result
]
