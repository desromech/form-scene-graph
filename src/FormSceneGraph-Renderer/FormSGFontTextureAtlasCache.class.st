"
I am a cache for fonts that places glyphs dynamically in a large texture atlas. I am based in the following technique that is described for accelerated Android text rendering: https://medium.com/@romainguy/androids-font-renderer-c368bbde87d9
"
Class {
	#name : #FormSGFontTextureAtlasCache,
	#superclass : #Object,
	#instVars : [
		'frameIndex',
		'cachedCharacters',
		'alphaPages',
		'colorPages',
		'modifiedPages'
	],
	#category : #'FormSceneGraph-Renderer-Font'
}

{ #category : #api }
FormSGFontTextureAtlasCache >> beginFrame [
	frameIndex := frameIndex + 1.
	modifiedPages removeAll.
]

{ #category : #initialization }
FormSGFontTextureAtlasCache >> initialize [
	super initialize.
	frameIndex := 1.
	alphaPages := OrderedCollection new.
	colorPages := OrderedCollection new.
	cachedCharacters := Dictionary new.
	modifiedPages := Set new.
]

{ #category : #accessing }
FormSGFontTextureAtlasCache >> modifiedPages [
	^ modifiedPages
]

{ #category : #api }
FormSGFontTextureAtlasCache >> prepareForCharacter: character font: font subpixelAllowed: subpixelAllowed [
	^ cachedCharacters at: { character . font . subpixelAllowed } ifAbsentPut: [
		| entry |
		entry := font makeFormSGFontTextureAtlasPageEntryFor: character subpixelAllowed: subpixelAllowed.
		self submitNewEntryIntoTexture: entry.
		entry
	]
]

{ #category : #api }
FormSGFontTextureAtlasCache >> prepareForString: string font: font subpixelAllowed: subpixelAllowed [
	self prepareForString: string from: 1 to: string size font: font subpixelAllowed: subpixelAllowed
]

{ #category : #api }
FormSGFontTextureAtlasCache >> prepareForString: string from: startIndex to: endIndex font: font subpixelAllowed: subpixelAllowed [
	startIndex to: endIndex do: [ :i |
		self prepareForCharacter: (string at: i) font: font subpixelAllowed: subpixelAllowed
	]
]

{ #category : #api }
FormSGFontTextureAtlasCache >> prepareString: string from: startIndex to: endIndex font: font scaledFont: scaledFont subpixelAllowed: subpixelAllowed [
	startIndex to: endIndex do: [ :i |
		| character |
		character := string at: i.
		(self prepareForCharacter: character font: font subpixelAllowed: subpixelAllowed).
		(self prepareForCharacter: character font: scaledFont subpixelAllowed: subpixelAllowed)
	]
]

{ #category : #api }
FormSGFontTextureAtlasCache >> processString: string from: startIndex to: endIndex font: font scaledFont: scaledFont subpixelAllowed: subpixelAllowed entriesWith: aBlock [
	startIndex to: endIndex do: [ :i |
		| character |
		character := string at: i.
		aBlock
			value: (self prepareForCharacter: character font: font subpixelAllowed: subpixelAllowed)
			value: (self prepareForCharacter: character font: scaledFont subpixelAllowed: subpixelAllowed)
			value: character value: (i < endIndex ifTrue: [string at: i + 1] ifFalse: [nil])
	]
]

{ #category : #api }
FormSGFontTextureAtlasCache >> processString: string from: startIndex to: endIndex font: font subpixelAllowed: subpixelAllowed entriesWith: aBlock [
	startIndex to: endIndex do: [ :i |
		| character |
		character := string at: i.
		aBlock value: (self prepareForCharacter: character font: font subpixelAllowed: subpixelAllowed) value: character value: (i < endIndex ifTrue: [string at: i + 1] ifFalse: [nil])
	]
]

{ #category : #internal }
FormSGFontTextureAtlasCache >> recordModifiedPage: page [
	modifiedPages add: page
]

{ #category : #internal }
FormSGFontTextureAtlasCache >> submitNewEntryIntoTexture: newEntry [
	| pageList newPage |
	newEntry hasValidGlyphForm ifFalse: [ ^ self ].

	pageList := newEntry hasSubpixelAntialiasing
		ifTrue: [ colorPages ]
		ifFalse: [ alphaPages ].
	pageList do: [ :each |
		(each tryToInsertEntry: newEntry) ifTrue: [
			^ self
		]
	].

	newPage := newEntry glyphForm depth > 8
		ifTrue: [ FormSGFontTextureAtlasPage newColor ]
		ifFalse: [ FormSGFontTextureAtlasPage newAlpha ].
	newPage cache: self.
	newPage tryToInsertEntry: newEntry.
	pageList add: newPage.
]
