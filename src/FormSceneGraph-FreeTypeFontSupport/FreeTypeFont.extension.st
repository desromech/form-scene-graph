Extension { #name : #FreeTypeFont }

{ #category : #'*FormSceneGraph-FreeTypeFontSupport' }
FreeTypeFont >> makeFormSGFontTextureAtlasPageEntryFor: character subpixelAllowed: subpixelAllowed [
	| glyphForm |
	(FreeTypeSettings current useSubPixelAntiAliasing and: [ subpixelAllowed ]) ifFalse: [ ^ super makeFormSGFontTextureAtlasPageEntryFor: character subpixelAllowed: subpixelAllowed ].

	glyphForm := self 
		glyphOf: character 
		destDepth: 32 
		colorValue: (Color white pixelValueForDepth: 32)
		subpixelPosition: 0.
		
	^ FormSGFontTextureAtlasPageEntry new
		glyphForm: glyphForm;
		hasSubpixelAntialiasing: true;
		yourself
]
