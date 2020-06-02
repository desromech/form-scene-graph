Extension { #name : #ThreePhaseButtonMorph }

{ #category : #'*FormSceneGraph-Morphic' }
ThreePhaseButtonMorph >> buildSceneGraphNodeWith: builder [
	state == #off ifTrue: [
		offImage ifNotNil: [^ builder texturedRectangle: bounds form: offImage]].
	state == #pressed ifTrue: [
		pressedImage ifNotNil: [^ builder texturedRectangle: bounds form: pressedImage]].
	state == #on ifTrue: [
		image ifNotNil: [^ builder texturedRectangle: bounds form: image]].
	^ builder null
]
