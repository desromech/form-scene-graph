"
I represent a single texture page for in the font texture atlas cache.
"
Class {
	#name : #FormSGFontTextureAtlasPage,
	#superclass : #Object,
	#instVars : [
		'cache',
		'modificationCount',
		'columns',
		'form',
		'remainingWidth'
	],
	#category : #'FormSceneGraph-Renderer-Font'
}

{ #category : #'instance creation' }
FormSGFontTextureAtlasPage class >> newAlpha [
	^ self basicNew initializeWithForm: (Form extent: self pageExtent depth: 8)
]

{ #category : #'instance creation' }
FormSGFontTextureAtlasPage class >> newColor [
	^ self basicNew initializeWithForm: (Form extent: self pageExtent depth: 32)
]

{ #category : #'instance creation' }
FormSGFontTextureAtlasPage class >> pageExtent [
	^ 2048 @ 256
]

{ #category : #accessing }
FormSGFontTextureAtlasPage >> cache [
	^ cache
]

{ #category : #accessing }
FormSGFontTextureAtlasPage >> cache: anObject [
	cache := anObject
]

{ #category : #accessing }
FormSGFontTextureAtlasPage >> form [
	^ form
]

{ #category : #accessing }
FormSGFontTextureAtlasPage >> form: anObject [
	form := anObject
]

{ #category : #'as yet unclassified' }
FormSGFontTextureAtlasPage >> increaseModificationCount [
	modificationCount := modificationCount + 1.
	cache recordModifiedPage: self.
]

{ #category : #initialization }
FormSGFontTextureAtlasPage >> initializeWithForm: theForm [
	form := theForm.
	modificationCount := 0.
	columns := OrderedCollection new.
	remainingWidth := form width - 2.
]

{ #category : #accessing }
FormSGFontTextureAtlasPage >> modificationCount [
	^ modificationCount
]

{ #category : #'as yet unclassified' }
FormSGFontTextureAtlasPage >> tryToInsertEntry: entry [
	| glyphForm |
	glyphForm := entry glyphForm.
	self assert: glyphForm isNotNil.
	columns do: [ :eachColumn |
		(eachColumn width >= glyphForm width and: [ eachColumn remainingHeight >= glyphForm height ]) ifTrue: [
			eachColumn insertEntry: entry.
			^ true
		]
	].

	remainingWidth >= glyphForm width ifTrue: [ 
		| newColumn |
		newColumn := FormSGFontTextureAtlasPageColumn new
			page: self;
			width: ((glyphForm width alignedTo: 4) min: remainingWidth);
			offset: form width - (remainingWidth + 1);
			remainingHeight: form height - 2;
			insertEntry: entry.
		remainingWidth := remainingWidth - newColumn width.
		
		"The border for the next column."
		remainingWidth > 0 ifTrue: [ remainingWidth := remainingWidth - 1 ].
		columns add: newColumn.
		^ true
	].
	
	^ false
]
