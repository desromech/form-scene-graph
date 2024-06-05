Extension { #name : 'ToggleWithSymbolMenuItemShortcut' }

{ #category : '*FormSceneGraph-MorphicP12' }
ToggleWithSymbolMenuItemShortcut >> buildSceneGraphNodeWith: builder [
	| text keyFont keyBounds paragraph |
	text := self text.
	keyFont := self class symbolFont.

	keyBounds := self boundsForKeyText: text string font: keyFont.
	paragraph := Paragraph new
		compose: text
			style: (TextStyle fontArray: { keyFont })
			from: 1
			in: (0@0 corner: keyBounds corner);
		yourself.
	^ paragraph buildSceneGraphNodeWith: builder bounds: keyBounds color: self color
]
