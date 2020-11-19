Extension { #name : #Form }

{ #category : #'*FormSceneGraph-Renderer' }
Form >> asTextureRenderingGlyphForm [
	| contentForm resultExtent |
	contentForm := depth <= 8
		ifTrue: [ self asFormOfDepth: 8 ]
		ifFalse: [ self inverted ].
	resultExtent := contentForm extent.
	^ (GlyphForm extent: resultExtent depth: contentForm depth bits: contentForm bits)
		offset: (offset ifNil: [0@0]);
		advance: resultExtent;
		linearAdvance: resultExtent;
		yourself
]

{ #category : #'*FormSceneGraph-Renderer' }
Form >> inverted [
	^ (self asFormOfDepth: 32) collectColors: [ :c |
		Color r: 1.0 - c red g: 1.0 - c green b: 1.0 - c blue alpha: c alpha
	]
]
