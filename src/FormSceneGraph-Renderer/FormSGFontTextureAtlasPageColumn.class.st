"
I represent a column in a texture atlas page. I am used for computing the remaining height for placing glyphs.
"
Class {
	#name : #FormSGFontTextureAtlasPageColumn,
	#superclass : #Object,
	#instVars : [
		'page',
		'offset',
		'width',
		'remainingHeight',
		'nextRow'
	],
	#category : #'FormSceneGraph-Renderer-Font'
}

{ #category : #initialization }
FormSGFontTextureAtlasPageColumn >> initialize [
	super initialize.
	nextRow := 1.
]

{ #category : #adding }
FormSGFontTextureAtlasPageColumn >> insertEntry: newEntry [
	| glyphForm destPosition pageExtent |
	glyphForm := newEntry glyphForm.
	self assert: (glyphForm isNotNil and: [ glyphForm width <= width and: [ glyphForm height <= remainingHeight ] ]).
	
	destPosition := offset @ nextRow.
	pageExtent := page form extent.
	newEntry
		page: page;
		rectangle: (destPosition / pageExtent corner: (destPosition + glyphForm extent) / pageExtent).
		
	page form getCanvas drawImage: glyphForm at: destPosition.
	page increaseModificationCount.
	
	nextRow := nextRow + glyphForm height.
	remainingHeight := remainingHeight - glyphForm height.
	remainingHeight > 0 ifTrue: [
		remainingHeight := remainingHeight - 1.
		nextRow := nextRow + 1
	].
]

{ #category : #accessing }
FormSGFontTextureAtlasPageColumn >> offset [
	^ offset
]

{ #category : #accessing }
FormSGFontTextureAtlasPageColumn >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
FormSGFontTextureAtlasPageColumn >> page [
	^ page
]

{ #category : #accessing }
FormSGFontTextureAtlasPageColumn >> page: anObject [
	page := anObject
]

{ #category : #accessing }
FormSGFontTextureAtlasPageColumn >> remainingHeight [
	^ remainingHeight
]

{ #category : #accessing }
FormSGFontTextureAtlasPageColumn >> remainingHeight: anObject [
	remainingHeight := anObject
]

{ #category : #accessing }
FormSGFontTextureAtlasPageColumn >> width [
	^ width
]

{ #category : #accessing }
FormSGFontTextureAtlasPageColumn >> width: anObject [
	width := anObject
]
