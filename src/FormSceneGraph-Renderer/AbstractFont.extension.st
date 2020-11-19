Extension { #name : #AbstractFont }

{ #category : #'*FormSceneGraph-Renderer' }
AbstractFont >> makeFormSGFontTextureAtlasPageEntryFor: character subpixelAllowed: subpixelAllowed [
	^ FormSGFontTextureAtlasPageEntry new
		glyphForm: (self characterFormAt: character);
		hasSubpixelAntialiasing: false;
		yourself
]

{ #category : #'*FormSceneGraph-Renderer' }
AbstractFont >> withSizeIncrementedBy: increment [
	^ self
]
