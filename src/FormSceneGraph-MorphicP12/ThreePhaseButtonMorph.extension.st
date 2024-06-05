Extension { #name : 'ThreePhaseButtonMorph' }

{ #category : '*FormSceneGraph-MorphicP12' }
ThreePhaseButtonMorph >> buildSceneGraphNodeWith: builder [
	state == #off ifTrue: [
		offImage ifNotNil: [^ builder textureForm: offImage at: bounds origin]].
	state == #pressed ifTrue: [
		pressedImage ifNotNil: [^ builder textureForm: pressedImage at: bounds origin]].
	state == #on ifTrue: [
		image ifNotNil: [^ builder textureForm: image at: bounds origin]].
	^ builder null
]
