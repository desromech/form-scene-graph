"
I am a world renderer that uses OpenGL ES for rendering.
"
Class {
	#name : #FormSGOpenGLESWorldRenderer,
	#superclass : #FormSGAbstractWorldRenderer,
	#instVars : [
		'context',
		'drawCommandProcessor'
	],
	#pools : [
		'UFFIOpenGLConstants'
	],
	#category : #'FormSceneGraph-OpenGLESRenderer'
}

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> context [
	^ context ifNil: [ context := UFFIOpenGLESContext globalContext ]
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> displayNewSceneGraph: newSceneGraph withDamageRectangle: damageRectangle [
	osWindow ifNil: [ ^ self ].
	self context withWindow: osWindow do: [
		| commandList |
		commandList := FormSGGPUCommandListBuilder new.
		FormSGGPUCommandListRenderer render: newSceneGraph with: commandList.
		
		Transcript show: self drawingSurfaceExtent; cr.
		self drawCommandProcessor
			beginRenderPassWithExtent: self drawingSurfaceExtent clearColor: Color transparent;
			processDrawCommandList: commandList;
			endRenderPass.
		context swapBuffers: osWindow
	].
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> doActivate [

	| attributes initialExtent |
	
	initialExtent := world worldState realWindowExtent ifNil: [976@665].

	attributes := OSWindowAttributes new.
	attributes
		extent: initialExtent;
		title: Smalltalk image imageFile fullName;
		windowCentered:true;
		icon: (self iconNamed: #pharoBig);
		glAttributes: self context glAttributes.

	display := Form extent: initialExtent depth: 32.
	world extent: initialExtent.

	driver := self pickMostSuitableWindowDriver.
	attributes preferableDriver: driver.
	osWindow := OSWindow createWithAttributes: attributes eventHandler: (OSWindowMorphicEventHandler for: world).
	
	osWindow focus. 
	
	world worldState doFullRepaint.
	world displayWorld.
	
	OSWindowClipboard new beDefault.
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> drawCommandProcessor [
	^ drawCommandProcessor ifNil: [ drawCommandProcessor := FormSGOpenGLESDrawCommandProcessor for: self context ]
]

{ #category : #initialization }
FormSGOpenGLESWorldRenderer >> osWindowRenderer [
	osWindow ifNil: [ ^ nil ].
	^ nil
	
]
