Extension { #name : #FormSGBuilder }

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> borderRectangle: aRectangle style: aBorderStyle [
	^ aBorderStyle buildSceneGraphNodeForBorder: aRectangle with: self
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> fillRectangle: aRectangle fillStyle: aFillStyle borderStyle: aBorderStyle [
	(aBorderStyle isNil or: [aBorderStyle width < 0]) ifTrue: [
		^ self fillRectangle: aRectangle style: aFillStyle
	].
	
	^ (self fillRectangle: (aRectangle insetBy: aBorderStyle width) style: aFillStyle) ,
		(self borderRectangle: aRectangle style: aBorderStyle)
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> fillRectangle: aRectangle style: aFillStyle [
	^ aFillStyle buildSceneGraphNodeForFilling: aRectangle with: self
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> frameRectangle: aRectangle width: width colors: colors dashes: dashes [
	self flag: 'TODO: Implement this properly.'.
	^ self null
]

{ #category : #'*FormSceneGraph-Morphic' }
FormSGBuilder >> rectangle: aRectangle fillStyle: aFillStyle borderStyle: aBorderStyle [
	(aBorderStyle isNil or: [aBorderStyle width < 0]) ifTrue: [
		^ self rectangle: aRectangle fillStyle: aFillStyle
	].
	
	^ (self rectangle: (aRectangle insetBy: aBorderStyle width) fillStyle: aFillStyle) ,
		(self borderRectangle: aRectangle style: aBorderStyle)
]
