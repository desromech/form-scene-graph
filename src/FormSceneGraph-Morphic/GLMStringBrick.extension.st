Extension { #name : #GLMStringBrick }

{ #category : #'*FormSceneGraph-Morphic' }
GLMStringBrick >> onBuildSceneGraphNodeWith: builder [
	| result |
	result := super onBuildSceneGraphNodeWith: builder.
	
	"self highlightedText isEmpty ifFalse: [
		self calculateHighlightingBounds do: [ :each |
			self highlightingLogic
				ifNil: [ aCanvas line: each bottomLeft to: each bottomRight width: 1 color: self textColor ]
				ifNotNil: [ self highlightingLogic cull: aCanvas cull: each ] ] ]."
	
	^ result , (builder
		string: self text
		in: (self calculateTextPosition extent: self bounds extent)
		font: self font
		color: self textColor)
]
