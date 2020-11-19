Extension { #name : #LogicalFont }

{ #category : #'*FormSceneGraph-Renderer' }
LogicalFont >> makeFormSGFontTextureAtlasPageEntryFor: character subpixelAllowed: subpixelAllowed [
	^ self realFont makeFormSGFontTextureAtlasPageEntryFor: character subpixelAllowed: subpixelAllowed
]
