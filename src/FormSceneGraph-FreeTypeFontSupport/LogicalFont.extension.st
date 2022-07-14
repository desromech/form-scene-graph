Extension { #name : #LogicalFont }

{ #category : #'*FormSceneGraph-FreeTypeFontSupport' }
LogicalFont >> makeFormSGFontTextureAtlasPageEntryFor: character subpixelAllowed: subpixelAllowed [
	^ self realFont makeFormSGFontTextureAtlasPageEntryFor: character subpixelAllowed: subpixelAllowed
]
