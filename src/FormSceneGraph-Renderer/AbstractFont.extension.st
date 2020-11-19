Extension { #name : #AbstractFont }

{ #category : #'*FormSceneGraph-Renderer' }
AbstractFont >> makeFormSGFontTextureAtlasPageEntryFor: character subpixelAllowed: subpixelAllowed [
	| glyphForm |
	glyphForm := (self characterFormAt: character) asTextureRenderingGlyphForm.
	^ FormSGFontTextureAtlasPageEntry new
		glyphForm: glyphForm;
		hasSubpixelAntialiasing: glyphForm depth = 32;
		yourself
]

{ #category : #'*FormSceneGraph-Renderer' }
AbstractFont >> withSizeIncrementedBy: increment [
	^ self
]
