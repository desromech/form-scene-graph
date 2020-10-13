"
I am a scene graph based world renderer that uses the Athens renderer.
"
Class {
	#name : #FormAthensSGWorldRenderer,
	#superclass : #FormSGWorldRenderer,
	#classVars : [
		'IsEnabled'
	],
	#category : #'FormSceneGraph-Morphic-WorldRenderer'
}

{ #category : #accessing }
FormAthensSGWorldRenderer class >> isApplicableFor: aWorld [

	^ self isEnabled and: [Smalltalk isHeadless and: [ CommandLineArguments new hasOption: 'interactive'  ]]
]

{ #category : #accessing }
FormAthensSGWorldRenderer class >> isEnabled [
	^ IsEnabled ifNil: [ IsEnabled := false ]
]

{ #category : #accessing }
FormAthensSGWorldRenderer class >> isEnabled: aBoolean [
	IsEnabled := aBoolean
]

{ #category : #accessing }
FormAthensSGWorldRenderer class >> isEnabledSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #isEnabled)
		parent: #appearance;
			label: 'Enable scene graph renderer (Required for Hi-DPI)';
		description: 'This enables the new scalable scene graph rendering framework. Effects are only visible after restarting the image.';
		target: self
]

{ #category : #accessing }
FormAthensSGWorldRenderer class >> priority [
	^ FormSGWorldRenderer priority + 1
]

{ #category : #operations }
FormAthensSGWorldRenderer >> displayNewSceneScene: newSceneGraph [
	| renderer |
	renderer := self osWindowRenderer.
	renderer drawDuring: [ :canvas |
		FormSGAthensRenderer render: newSceneGraph on: canvas
	].
	renderer updateAll; present
]

{ #category : #initialization }
FormAthensSGWorldRenderer >> osWindowRenderer [
		
	^ osWindow renderer ifNil: [
		osWindow newAthensRenderer.
		osWindow renderer
	].
	
]
