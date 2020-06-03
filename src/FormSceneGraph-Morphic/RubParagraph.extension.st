Extension { #name : #RubParagraph }

{ #category : #'*FormSceneGraph-Morphic' }
RubParagraph >> buildSceneGraphNodeWith: builder bounds: aRectangle color: aColor [
	| displayScanner offset leftInRun result |
	displayScanner := builder displayScannerFor: self.
	offset := aRectangle topLeft - self position.
	leftInRun := 0.
	self
		forLinesIn: aRectangle
		do: [ :line | 
			line first <= line last ifTrue: [
				leftInRun := displayScanner displayLine: line offset: offset leftInRun: leftInRun
			] ] .
			
	result := displayScanner sceneGraphNode.
	result isNullNode ifTrue: [ ^ result ].
	^ builder clip: result withRectangle: aRectangle
]
