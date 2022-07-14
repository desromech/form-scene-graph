Extension { #name : #GlyphForm }

{ #category : #'*FormSceneGraph-FreeTypeFontSupport' }
GlyphForm >> asTextureRenderingGlyphForm [
	^ self
]

{ #category : #'*FormSceneGraph-FreeTypeFontSupport' }
GlyphForm >> inverted [
	| result |
	result := super inverted.
	^ (self class extent: result extent depth: result depth bits: result bits)
		offset: offset;
		advance: advance;
		linearAdvance: linearAdvance;
		yourself
]
